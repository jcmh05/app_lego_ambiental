import 'dart:async';
import 'package:applegoambiental/components/components.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';

class MqttManager {
  final Log = logger(MqttManager);


  late MqttServerClient client;

  final StreamController<String> _messageController = StreamController<String>.broadcast();

  Stream<String> get messageStream => _messageController.stream;

  MqttManager() {
    _setupMqttClient();
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(LocalStorage().getIpAddress(), 'flutter_client', LocalStorage().getPort());
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  Future<void> connect() async {
    try {
      await client.connect();
    } catch (e) {
      Log.e('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      Log.i('Connected to MQTT broker');
    } else {
      Log.e('Connection failed: ${client.connectionStatus}');
      disconnect();
    }
  }

  void disconnect() {
    client.disconnect();
    _onDisconnected();
  }

  void _onConnected() {
    Log.i('Connected');
    client.subscribe(LocalStorage().getMapTopic(), MqttQos.atMostOnce);
  }

  void _onDisconnected() {
    Log.i('Disconnected');
  }



  void _onSubscribed(String topic) {
    Log.i('Subscribed to topic: $topic');

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      Log.i("Message received: ${c[0].topic} ");
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String newLocation = MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

      _messageController.add(newLocation);
      Log.i('Received message: $newLocation from topic: ${c[0].topic}>');
    });
  }

  void publishMessage(String topic, String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);

    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void dispose() {
    _messageController.close();
  }
}