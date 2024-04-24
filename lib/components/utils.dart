import 'package:fluttertoast/fluttertoast.dart';

void mostrarMensaje(String mensaje) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_LONG,
  );
}

/**
 * Convierte un string 02020001050307...010701
 * en una lista de id de las fotos para construir
 * el mapa
 */
List<String> convertStringToList(String input) {
  List<String> result = [];
  for (int i = 0; i < input.length; i += 2) {
    result.add(input.substring(i, i + 2));
  }
  return result;
}