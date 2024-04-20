import 'package:flutter/material.dart';
import 'package:applegoambiental/screens/screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transportes Kebab Campeón',
      color: Colors.white,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF17566e)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Transportes Kebab Campeón'),
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
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // The number of tabs
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.local_shipping_outlined, color: Colors.white,)), // Icon for the first tab
                Tab(icon: Icon(Icons.remove_red_eye_outlined, color: Colors.white)), // Icon for the second tab
              ],
            ),
          ),
          body: TabBarView(
            children: [
              OrderScreen(), // The first tab
              ViewMapScreen(), // The second tab, replace with your second screen
            ],
          ),
        ),
      ),
    );
  }
}