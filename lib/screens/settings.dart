import 'package:applegoambiental/components/components.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ipAddressController = TextEditingController(text: LocalStorage().getIpAddress());
  final _portController = TextEditingController(text: LocalStorage().getPort().toString());
  final _mapTopicController = TextEditingController(text: LocalStorage().getMapTopic());
  final _orderTopicController = TextEditingController(text: LocalStorage().getOrderTopic());
  final _odometryTopicController = TextEditingController(text: LocalStorage().getOdometryTopic());
  final _completeOrderTopicController = TextEditingController(text: LocalStorage().getCompleteOrderTopic());

  bool _hasChanged = false;

  @override
  void dispose() {
    _ipAddressController.dispose();
    _portController.dispose();
    _mapTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ipAddressController,
                decoration: InputDecoration(labelText: 'Dirección IP'),
                onChanged: (value) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
              TextFormField(
                controller: _portController,
                decoration: InputDecoration(labelText: 'Puerto'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
              TextFormField(
                controller: _mapTopicController,
                decoration: InputDecoration(labelText: 'Topic para el mapa'),
                onChanged: (value) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
              TextFormField(
                controller: _orderTopicController,
                decoration: InputDecoration(labelText: 'Topic para los pedidos'),
                onChanged: (value) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
              TextFormField(
                controller: _odometryTopicController,
                decoration: InputDecoration(labelText: 'Topic para la odometría'),
                onChanged: (value) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
              TextFormField(
                controller: _completeOrderTopicController,
                decoration: InputDecoration(labelText: 'Topic para la orden completa'),
                onChanged: (value) {
                  setState(() {
                    _hasChanged = true;
                  });
                },
              ),
              if (_hasChanged)
                ElevatedButton(
                  onPressed: () {
                    LocalStorage().setIpAddress(_ipAddressController.text);
                    LocalStorage().setPort(int.parse(_portController.text));
                    LocalStorage().setMapTopic(_mapTopicController.text);
                    LocalStorage().setOrderTopic(_orderTopicController.text);
                    LocalStorage().setOdometryTopic(_odometryTopicController.text);
                    LocalStorage().setCompleteOrderTopic(_completeOrderTopicController.text);
                    setState(() {
                      _hasChanged = false;
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Guardar'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}