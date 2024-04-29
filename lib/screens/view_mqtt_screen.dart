import 'package:applegoambiental/components/components.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:applegoambiental/components/mqttmanager.dart';

class ViewMqttScreen extends StatefulWidget {
  final MqttManager mqttManager;

  ViewMqttScreen({required this.mqttManager});

  @override
  _ViewMqttScreenState createState() => _ViewMqttScreenState();
}

class _ViewMqttScreenState extends State<ViewMqttScreen> {
  void reconnect() async {
    widget.mqttManager.disconnect();
    await widget.mqttManager.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mqttManager.client.connectionStatus!.state == MqttConnectionState.connected
              ? 'Conectado a ${LocalStorage().getIpAddress()}'
              : 'No conectado',
        ),
        actions: <Widget>[
          Icon(
            Icons.circle,
            color: widget.mqttManager.client.connectionStatus!.state == MqttConnectionState.connected
                ? Colors.green
                : Colors.red,
          ),
        ],
      ),
      body: Center(
        child: Text('MQTT Explorer'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reconnect,
        tooltip: 'Reconnect',
        child: Icon(Icons.refresh),
      ),
    );
  }
}