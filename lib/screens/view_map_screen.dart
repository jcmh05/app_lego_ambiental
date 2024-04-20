import 'package:flutter/material.dart';
import 'package:applegoambiental/components/components.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ViewMapScreen extends StatefulWidget {
  const ViewMapScreen({super.key});

  @override
  State<ViewMapScreen> createState() => _ViewMapScreenState();
}

class _ViewMapScreenState extends State<ViewMapScreen> {

  // Mapa principal
  final List<String> imagePaths = [
    '01', '09', '01', '04', '01',
    '00', '08', '01', '08', '01',
    '01', '10', '00', '02', '00',
    '00', '08', '05', '08', '01',
    '04', '07', '11', '06', '00',
    '02', '00', '03', '09', '05',
    '03', '01', '00', '02', '02',
  ];

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
              child: Image.asset(
                "assets/images/" + imagePaths[index] + ".png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
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