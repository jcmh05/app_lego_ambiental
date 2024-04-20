import 'package:fluttertoast/fluttertoast.dart';

void mostrarMensaje(String mensaje) {
  Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_LONG,
  );
}