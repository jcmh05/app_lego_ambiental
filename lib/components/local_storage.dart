
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:applegoambiental/components/components.dart';
import 'package:hive/hive.dart';

class LocalStorage{
  final Log = logger(LocalStorage);
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;

  LocalStorage._internal();

  late Box _mqttBox;

  Future<void> init() async {
    // Inicializar Hive
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    // Abrir la caja para almacenar los datos de usuario
    _mqttBox = await Hive.openBox('mqtt');

    Log.i('LocalStorage inicializado');
  }

  Future<void> setIpAddress(String ipAddress) async {
    await _mqttBox.put('ipAddress', ipAddress);
    Log.i('Dirección IP actualizada: $ipAddress');
  }

  String getIpAddress() {
    return _mqttBox.get('ipAddress', defaultValue: '192.168.0.100');
  }

  Future<void> setPort(int port) async {
    await _mqttBox.put('port', port);
    Log.i('Puerto actualizado: $port');
  }

  int getPort() {
    return _mqttBox.get('port', defaultValue: 1883);
  }

  Future<void> setMapTopic(String mapTopic) async {
    await _mqttBox.put('mapTopic', mapTopic);
    Log.i('Topic del mapa actualizado: $mapTopic');
  }

  String getMapTopic() {
    return _mqttBox.get('mapTopic', defaultValue: 'map');
  }

  Future<void> setMapList(List<String> mapList) async {
    String mapListString = mapList.join(",");
    await _mqttBox.put('mapList', mapListString);
    Log.i('Lista del mapa actualizada: $mapListString');
  }

  List<String> getMapList() {
    List<String> imagePathsDefault = [
      '01', '09', '01', '04', '01',
      '00', '08', '01', '08', '01',
      '01', '10', '00', '02', '00',
      '00', '08', '05', '08', '01',
      '04', '07', '11', '06', '00',
      '02', '00', '03', '09', '05',
      '03', '01', '00', '02', '02',
    ];
    String defaultMapListString = imagePathsDefault.join(",");
    String mapListString = _mqttBox.get('mapList', defaultValue: defaultMapListString);
    return mapListString.split(',');
  }

  Future<void> clear() async {
    await _mqttBox.clear();
    Log.i('LocalStorage limpiado');
  }
}