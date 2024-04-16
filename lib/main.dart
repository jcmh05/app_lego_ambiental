import 'package:flutter/material.dart';

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
    'assets/images/ambiental1.png',
    'assets/images/ambiental2.png',
    'assets/images/ambiental3.png',
    'assets/images/ambiental4.png',
    'assets/images/ambiental5.png',
    'assets/images/ambiental6.png',
    'assets/images/ambiental7.png',
    'assets/images/ambiental8.png',
    'assets/images/ambiental9.png',
    'assets/images/ambiental10.png',
    'assets/images/ambiental11.png',
    'assets/images/ambiental12.png',
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
        body: GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.0,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: imagePaths.length, // Usa la longitud de la lista de imágenes
          itemBuilder: (context, index) => ElevatedButton(
            onPressed: () {},
            child: Image.asset(imagePaths[index]), // Usa la lista de imágenes
          ),
        ),
      ),
    );
  }
}
