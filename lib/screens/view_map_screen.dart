import 'dart:async';

import 'package:flutter/material.dart';
import 'package:applegoambiental/components/components.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ViewMapScreen extends StatefulWidget {
  MqttManager mqttManager;

  ViewMapScreen({required this.mqttManager});

  @override
  State<ViewMapScreen> createState() => _ViewMapScreenState();
}

class _ViewMapScreenState extends State<ViewMapScreen> {
  late StreamSubscription<String> _messageSubscription;
  int robotIndex = (int.parse(LocalStorage().getOdometry()[0]) - 1) * 5 + int.parse(LocalStorage().getOdometry()[1]) - 1;

  // Mapa principal
   List<String> imagePaths = LocalStorage().getMapList();

  @override
  void initState() {
    super.initState();

    _messageSubscription = widget.mqttManager.messageStream.listen((newLocation) {
      var splitMessage = newLocation.split(':');
      var topic = splitMessage[0];
      var message = splitMessage[1];

      if (topic == LocalStorage().getMapTopic()) {
        setState(() {
          imagePaths = convertStringToList(message);
          LocalStorage().setMapList(imagePaths);
          //mostrarMensaje("Nuevo mapa");
        });
      } else if (topic == LocalStorage().getOdometryTopic()) {
        LocalStorage().setOdometry(message);
        setState(() {
          var odometry = LocalStorage().getOdometry();
          var row = int.parse(odometry[0]);
          var col = int.parse(odometry[1]);
          robotIndex = (row - 1) * 5 + col - 1; // Calcula el índice basado en la odometría
        });
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription.cancel(); // Cancela la suscripción al stream
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Visualización del mapa',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1.0,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
            ),
            itemCount: imagePaths.length, // Usa la longitud de la lista de imágenes
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                int row = (index / 5).floor() + 1; // Calcula la fila
                int col = index % 5 + 1;

                mostrarMensaje("Pulsado: ${row}x${col}");
              },
              child: Stack(
                children: <Widget>[
                  Image.asset(
                    "assets/images" + LocalStorage().getSkin() + "/" + imagePaths[index] + ".png",
                    fit: BoxFit.cover,
                  ),
                  if (index == robotIndex)
                    Center(
                      child: Transform.scale(
                        scale: 0.7,
                        child: Image.asset(
                          "assets/robot.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Button3d(
            onPressed: () {
              String currentSkin = LocalStorage().getSkin();
              String newSkin;

              if (currentSkin == '1') {
                newSkin = '2';
              } else if (currentSkin == '2') {
                newSkin = '3';
              } else {
                newSkin = '1';
              }

              LocalStorage().setSkin(newSkin);
              setState(() {
              });
            },
            child: Text(
              'Cambiar skin',
              style: TextStyle(color: Colors.white),
            ),
            style: Button3dStyle.BLUE,
            width: 200.0,
            height: 50.0,
          ),
        )
      ],
    );
  }
}

void mostrarMensaje(String mensaje) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_LONG,
  );
}