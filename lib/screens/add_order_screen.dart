import 'package:applegoambiental/components/components.dart';
import 'package:flutter/material.dart';
import 'package:applegoambiental/models/models.dart';
import 'package:uuid/uuid.dart';

class AddOrder extends StatefulWidget {
  final Function addPedido;

  const AddOrder({super.key, required this.addPedido});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {

  bool recogidaSeleccionada = true;

  final List<String> imagePaths = [
    '01', '09', '01', '04', '01',
    '00', '08', '01', '08', '01',
    '01', '10', '00', '02', '00',
    '00', '08', '05', '08', '01',
    '04', '07', '11', '06', '00',
    '02', '00', '03', '09', '05',
    '03', '01', '00', '02', '02',
  ];

  Punto? puntoRecogida;
  Punto? puntoEntrega;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Añadir pedido'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                ),
                itemCount: imagePaths.length,
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    int row = (index / 5).floor() + 1;
                    int col = index % 5 + 1;

                    setState(() {
                      if (recogidaSeleccionada) {
                        puntoRecogida = Punto(row, col);
                      } else {
                        puntoEntrega = Punto(row, col);
                      }
                      recogidaSeleccionada = !recogidaSeleccionada;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: puntoRecogida != null && puntoRecogida!.x == (index / 5).floor() + 1 && puntoRecogida!.y == index % 5 + 1
                          ? Border.all(color: Colors.yellow, width: 3.0)
                          : puntoEntrega != null && puntoEntrega!.x == (index / 5).floor() + 1 && puntoEntrega!.y == index % 5 + 1
                          ? Border.all(color: Colors.orange, width: 3.0)
                          : null,
                    ),
                    child: Image.asset(
                      "assets/images/" + imagePaths[index] + ".png",
                      fit: BoxFit.cover,
                    ),
                  )
                ),
              ),
            ),
            Text(
              '🟡Punto de recogida: ${puntoRecogida?.toString() ?? 'No seleccionado'}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '🟠Punto de entrega: ${puntoEntrega?.toString() ?? 'No seleccionado'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20.0,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Button3d(
                width: 300.0,
                height: 50.0,
                child: Text(
                  'Realizar pedido✅',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                style: Button3dStyle(
                    topColor: Color(0xff2aadd5),
                    backColor: Color(0xff2494b4),
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {
                  if (puntoRecogida != null && puntoEntrega != null){
                    var uuid = Uuid();
                    String shortId = uuid.v4().substring(0, 8);

                    Pedido nuevoPedido = Pedido(
                      id: shortId,
                      coordenadasRecogida: puntoRecogida!,
                      coordenadasEntrega: puntoEntrega!,
                    );
                    widget.addPedido(nuevoPedido);
                    Navigator.pop(context);
                  }else{
                    mostrarMensaje('Selecciona los puntos primero');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}