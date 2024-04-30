import 'dart:async';

import 'package:applegoambiental/models/models.dart';
import 'package:applegoambiental/screens/add_order_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:applegoambiental/components/components.dart';

class OrderScreen extends StatefulWidget {
  MqttManager mqttManager;

  OrderScreen({required this.mqttManager});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late StreamSubscription<String> _messageSubscription;

  List<String> imagePaths = LocalStorage().getMapList();

  @override
  void initState() {
    super.initState();

    // Actualiza el mapa cada vez que recibe uno nuevo
    _messageSubscription = widget.mqttManager.messageStream.listen((newLocation) {
      var splitMessage = newLocation.split(':');
      var topic = splitMessage[0];
      var message = splitMessage[1];

      if (topic == LocalStorage().getMapTopic()) {
        setState(() {
          imagePaths = convertStringToList(message);
          LocalStorage().setMapList(imagePaths);
        });
      } else if (topic == LocalStorage().getOdometryTopic()) {
        LocalStorage().setOdometry(message);
      }
    });
  }

  void addPedido(Pedido pedido) {
    setState(() {
      LocalStorage().addPedidoEnEspera(pedido);
    });

    String message = '${pedido.coordenadasRecogida.x}${pedido.coordenadasRecogida.y}${pedido.coordenadasEntrega.x}${pedido.coordenadasEntrega.y}';
    widget.mqttManager.publishMessage(LocalStorage().getOrderTopic(), message);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildSection('Pedidos en espera:', LocalStorage().getPedidosEnEspera()),
                Divider( thickness: 1.0,),
                _buildSection('Pedidos en curso:', LocalStorage().getPedidosEnCurso()),
                Divider( thickness: 1.0,),
                _buildSection('Pedidos finalizados:', LocalStorage().getPedidosFinalizados()),
                Divider( thickness: 1.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Button3d(
                    width: 300.0,
                    height: 50.0,
                    child: Text(
                      'Nuevo pedido 📦',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    style: Button3dStyle(
                        topColor: Color(0xFF207c9e),
                        backColor: Color(0xFF17566e),
                        borderRadius: BorderRadius.circular(50)
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => AddOrder(addPedido: addPedido,imagePaths: imagePaths,),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            var begin = Offset(0,-1);
                            var end = Offset.zero;
                            var curve = Curves.fastOutSlowIn;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }

  Widget _buildSection(String title, List<Pedido> pedidos) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(pedidos[index].toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        setState(() {
                          pedidos.removeAt(index);
                        });
                        if (title == 'Pedidos en espera:') {
                          await LocalStorage().removePedidoEnEspera(index);
                        } else if (title == 'Pedidos en curso:') {
                          await LocalStorage().removePedidoEnCurso(index);
                        } else if (title == 'Pedidos finalizados:') {
                          await LocalStorage().removePedidoFinalizado(index);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
