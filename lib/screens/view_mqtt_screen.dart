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
  List<String> messages = ['No messages yet', 'No messages yet', 'No messages yet'];

  _ViewMqttScreenState({required this.mqttManager});

  @override
  void initState() {
    super.initState();
    mqttManager.messageStream.listen((message) {
      setState(() {
        if (message.startsWith(LocalStorage().getMapTopic())) {
          messages[0] = message;
        } else if (message.startsWith(LocalStorage().getOdometryTopic())) {
          messages[1] = message;
        } else if (message.startsWith(LocalStorage().getCompleteOrderTopic())) {
          messages[2] = message;
        }
      });
    });
  }

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
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reconnect,
        tooltip: 'Reconnect',
        child: Icon(Icons.refresh),
      ),
    );
  }
}