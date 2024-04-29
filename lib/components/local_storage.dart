
import 'package:applegoambiental/models/models.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:applegoambiental/components/components.dart';
import 'package:hive/hive.dart';

class LocalStorage{
  final Log = logger(LocalStorage);
  static final LocalStorage _instance = LocalStorage._internal();
  factory LocalStorage() => _instance;

  LocalStorage._internal();

  late Box _mqttBox;
  late Box _pedidosEnEsperaBox;
  late Box _pedidosEnCursoBox;
  late Box _pedidosFinalizadosBox;

  Future<void> init() async {
    // Inicializar Hive
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);

    // Abrir las cajas de datos
    _mqttBox = await Hive.openBox('mqtt');
    _pedidosEnEsperaBox = await Hive.openBox('pedidosEnEspera');
    _pedidosEnCursoBox = await Hive.openBox('pedidosEnCurso');
    _pedidosFinalizadosBox = await Hive.openBox('pedidosFinalizados');

    Log.i('LocalStorage inicializado');
  }

  /////////////// Dirección IP del servidor///////////////
  Future<void> setIpAddress(String ipAddress) async {
    await _mqttBox.put('ipAddress', ipAddress);
    Log.i('Dirección IP actualizada: $ipAddress');
  }

  String getIpAddress() {
    return _mqttBox.get('ipAddress', defaultValue: '192.168.0.100');
  }

  /////////////// Puerto ///////////////
  Future<void> setPort(int port) async {
    await _mqttBox.put('port', port);
    Log.i('Puerto actualizado: $port');
  }

  int getPort() {
    return _mqttBox.get('port', defaultValue: 1883);
  }

  /////////////// Mapa  ///////////////
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

  /////////////// Topic para recibir mapas ///////////////
  Future<void> setMapTopic(String mapTopic) async {
    await _mqttBox.put('mapTopic', mapTopic);
    Log.i('Topic del mapa actualizado: $mapTopic');
  }

  String getMapTopic() {
    return _mqttBox.get('mapTopic', defaultValue: 'map');
  }

  /////////////// Topic para enviar pedidos ///////////////
  Future<void> setOrderTopic(String orderTopic) async {
    await _mqttBox.put('orderTopic', orderTopic);
    Log.i('Topic del pedido actualizado: $orderTopic');
  }

  String getOrderTopic() {
    return _mqttBox.get('orderTopic', defaultValue: '/GrupoK/order');
  }

  ////////////// Topic para recibir odometría //////////////
  Future<void> setOdometryTopic(String odometryTopic) async {
    await _mqttBox.put('odometryTopic', odometryTopic);
    Log.i('Topic de odometría actualizado: $odometryTopic');
  }

  String getOdometryTopic() {
    return _mqttBox.get('odometryTopic', defaultValue: '/GrupoK/odometry');
  }

  ////////// Topic para recibir pedido completado //////////
  Future<void> setCompleteOrderTopic(String completeOrderTopic) async {
    await _mqttBox.put('completeOrderTopic', completeOrderTopic);
    Log.i('Topic de orden completa actualizado: $completeOrderTopic');
  }

  String getCompleteOrderTopic() {
    return _mqttBox.get('completeOrderTopic', defaultValue: '/GrupoK/complete');
  }

  //////////////// Borrado de caja de datos de mqtt////////////////
  Future<void> clear() async {
    await _mqttBox.clear();
    Log.i('LocalStorage limpiado');
  }

  // Métodos para la caja de pedidos en espera
  Future<void> addPedidoEnEspera(Pedido pedido) async {
    await _pedidosEnEsperaBox.add(pedido.toJson());
  }

  List<Pedido> getPedidosEnEspera() {
    return _pedidosEnEsperaBox.values.map((json) => Pedido.fromJson(json)).toList().cast<Pedido>();
  }

  Future<void> removePedidoEnEspera(int index) async {
    await _pedidosEnEsperaBox.deleteAt(index);
  }

  Future<void> clearPedidosEnEspera() async {
    await _pedidosEnEsperaBox.clear();
  }

  // Métodos para la caja de pedidos en curso
  Future<void> addPedidoEnCurso(Pedido pedido) async {
    await _pedidosEnCursoBox.add(pedido.toJson());
  }

  List<Pedido> getPedidosEnCurso() {
    return _pedidosEnCursoBox.values.map((json) => Pedido.fromJson(json)).toList().cast<Pedido>();
  }

  Future<void> removePedidoEnCurso(int index) async {
    await _pedidosEnCursoBox.deleteAt(index);
  }

  Future<void> clearPedidosEnCurso() async {
    await _pedidosEnCursoBox.clear();
  }

  // Métodos para la caja de pedidos finalizados
  Future<void> addPedidoFinalizado(Pedido pedido) async {
    await _pedidosFinalizadosBox.add(pedido.toJson());
  }

  List<Pedido> getPedidosFinalizados() {
    return _pedidosFinalizadosBox.values.map((json) => Pedido.fromJson(json)).toList().cast<Pedido>();
  }

  Future<void> removePedidoFinalizado(int index) async {
    await _pedidosFinalizadosBox.deleteAt(index);
  }

  Future<void> clearPedidosFinalizados() async {
    await _pedidosFinalizadosBox.clear();
  }

  // Método para limpiar todas las cajas de pedidos
  Future<void> clearAllPedidos() async {
    await clearPedidosEnEspera();
    await clearPedidosEnCurso();
    await clearPedidosFinalizados();
  }
}