import 'package:applegoambiental/components/components.dart';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:applegoambiental/components/mqttmanager.dart';

class ViewMqttScreen extends StatefulWidget {
  MqttManager mqttManager;

  ViewMqttScreen({required this.mqttManager});

  @override
  _ViewMqttScreenState createState() => _ViewMqttScreenState(mqttManager: mqttManager);
}

class _ViewMqttScreenState extends State<ViewMqttScreen> {
  MqttManager mqttManager;

  _ViewMqttScreenState({required this.mqttManager});

  void reconnect() async {
    widget.mqttManager.disconnect();
    mqttManager = MqttManager();
    await mqttManager.connect();
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
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.circle,
              color: widget.mqttManager.client.connectionStatus!.state == MqttConnectionState.connected
                  ? Colors.green
                  : Colors.red,
            ),
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