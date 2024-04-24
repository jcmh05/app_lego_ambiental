import 'package:applegoambiental/components/components.dart';
import 'package:flutter/material.dart';
import 'package:applegoambiental/models/models.dart';
import 'package:uuid/uuid.dart';

class AddOrder extends StatefulWidget {
  final Function addPedido;
  List<String> imagePaths;

  AddOrder({required this.addPedido, required this.imagePaths});

  @override
  State<AddOrder> createState() => _AddOrderState(imagePaths: imagePaths);
}

class _AddOrderState extends State<AddOrder> {
  List<String> imagePaths;

  _AddOrderState({required this.imagePaths});

  bool recogidaSeleccionada = true;
  bool borradoRecogida = false;



  Punto? puntoRecogida;
  Punto? puntoEntrega;

  String? ultimoPuntoBorrado;

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
                        if (imagePaths[index] == '00') {
                          mostrarMensaje('No se puede seleccionar este punto');
                          return;
                        }

                        int row = (index / 5).floor() + 1;
                        int col = index % 5 + 1;

                        setState(() {
                          if (ultimoPuntoBorrado == 'recogida') {
                            puntoRecogida = Punto(row, col, imagePaths[index]);
                            ultimoPuntoBorrado = null;
                          } else if (ultimoPuntoBorrado == 'entrega') {
                            puntoEntrega = Punto(row, col, imagePaths[index]);
                            ultimoPuntoBorrado = null;
                          } else {
                            if (recogidaSeleccionada) {
                              puntoRecogida = Punto(row, col, imagePaths[index]);
                            } else {
                              puntoEntrega = Punto(row, col, imagePaths[index]);
                            }
                            recogidaSeleccionada = !recogidaSeleccionada;
                          }
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
            Card(
              child: ListTile(
                title: Text(
                  '🟡 Punto de recogida: ${puntoRecogida?.toString() ?? 'No seleccionado'}',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      puntoRecogida = null;
                      ultimoPuntoBorrado = 'recogida';
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text(
                  '🟠 Punto de entrega: ${puntoEntrega?.toString() ?? 'No seleccionado'}',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      puntoEntrega = null;
                      ultimoPuntoBorrado = 'entrega';
                    });
                  },
                ),
              ),
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
                  if (validarPuntos()){
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
                    mostrarMensaje('Seleccion de puntos incorrecta');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validarPuntos() {
    if (puntoRecogida != null && puntoEntrega != null) {
      return true;
    }
    return false;
  }
}

