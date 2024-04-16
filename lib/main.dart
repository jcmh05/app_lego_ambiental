import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:applegoambiental/components/components.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kebab Campeón Transportes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Kebab Campeón Transportes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Lista de rutas de imágenes
  final List<String> imagePaths = [
    'assets/images/01.png',
    'assets/images/09.png',
    'assets/images/01.png',
    'assets/images/04.png',
    'assets/images/01.png',
    'assets/images/00.png',
    'assets/images/08.png',
    'assets/images/01.png',
    'assets/images/08.png',
    'assets/images/01.png',
    'assets/images/01.png',
    'assets/images/10.png',
    'assets/images/00.png',
    'assets/images/02.png',
    'assets/images/00.png',
    'assets/images/00.png',
    'assets/images/08.png',
    'assets/images/05.png',
    'assets/images/08.png',
    'assets/images/01.png',
    'assets/images/04.png',
    'assets/images/07.png',
    'assets/images/11.png',
    'assets/images/06.png',
    'assets/images/00.png',
    'assets/images/02.png',
    'assets/images/00.png',
    'assets/images/03.png',
    'assets/images/09.png',
    'assets/images/05.png',
    'assets/images/03.png',
    'assets/images/01.png',
    'assets/images/00.png',
    'assets/images/02.png',
    'assets/images/02.png',


    // Agrega más rutas de imágenes aquí
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: Theme.of(context).textTheme.headline6,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
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
                itemCount: imagePaths.length, // Usa la longitud de la lista de imágenes
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    int row = (index / 5).floor() + 1; // Calcula la fila
                    int col = index % 5 + 1; // Calcula la columna
                    if (imagePaths[index] == 'assets/images/00.png') {
                      mostrarMensaje("Piso: ${row}x${col} pulsado");
                    } else {
                      mostrarMensaje("Pulsa un edificio");
                    }
                  },
                  child: Image.asset(
                    imagePaths[index],
                    fit: BoxFit.cover, // Esto hará que la imagen llene todo el espacio disponible
                  ), // Usa la lista de imágenes
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button3d(
                onPressed: () {
                  mostrarMensaje("Botón presionado");
                },
                child: Text(
                  'Botón',
                  style: TextStyle(color: Colors.white),
                ),
                style: Button3dStyle.BLUE,
                width: 200.0,
                height: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void mostrarMensaje(String mensaje) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_LONG,
  );
}