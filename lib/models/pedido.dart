enum EstadoPedido { EN_ESPERA, EN_CURSO, COMPLETADO }

class Punto {
  int x;
  int y;
  String idMapa;

  Punto(this.x, this.y, this.idMapa);

  String get getidMapa => this.idMapa;

  @override
  String toString() {
    return '(${this.x}, ${this.y})';
  }

}

class Pedido {
  final String id;
  Punto coordenadasRecogida;
  Punto coordenadasEntrega;
  EstadoPedido estado;

  Pedido({
    required this.id,
    required this.coordenadasRecogida,
    required this.coordenadasEntrega,
    this.estado = EstadoPedido.EN_ESPERA,
  });

  // Getters
  String get getId => this.id;
  Punto get getCoordenadasRecogida => this.coordenadasRecogida;
  Punto get getCoordenadasEntrega => this.coordenadasEntrega;
  EstadoPedido get getEstado => this.estado;

  // Setters
  set setCoordenadasRecogida(Punto nuevoPunto) {
    this.coordenadasRecogida = nuevoPunto;
  }

  set setCoordenadasEntrega(Punto nuevoPunto) {
    this.coordenadasEntrega = nuevoPunto;
  }

  set setEstado(EstadoPedido nuevoEstado) {
    this.estado = nuevoEstado;
  }

  @override
  String toString() {
    return 'Pedido: $id\nRecogida: $coordenadasRecogida\nEntrega: $coordenadasEntrega';
  }
}