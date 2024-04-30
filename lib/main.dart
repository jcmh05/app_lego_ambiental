import 'package:applegoambiental/components/components.dart';
import 'package:flutter/material.dart';
import 'package:applegoambiental/screens/screens.dart';

import 'components/mqttmanager.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();

  // Limpia las 3 listas de pedidos
  LocalStorage().clearPedidosEnEspera();
  LocalStorage().clearPedidosEnCurso();
  LocalStorage().clearPedidosFinalizados();

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
  late MqttManager manager;

  void mqttConnect() async {
    manager = MqttManager();
    await manager.connect();
  }

  @override
  void initState() {
    super.initState();
    mqttConnect();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // The number of tabs
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
                Tab(icon: Icon(Icons.local_shipping_outlined, color: Colors.white,)),
                Tab(icon: Icon(Icons.map_outlined, color: Colors.white)),
                Tab(icon: Icon(Icons.remove_red_eye_outlined, color: Colors.white)),
              ],
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Navega a la pantalla de ajustes
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              OrderScreen(mqttManager: manager,),
              ViewMapScreen(mqttManager: manager,),
              ViewMqttScreen(mqttManager: manager,),
            ],
          ),
        ),
      ),
    );
  }
}