import 'dart:convert';

import 'package:applojahouse/src/models/mensaje.model.dart';
import 'package:http/http.dart' as http;

class MensajeProvider{

  final String _url = 'http://192.168.1.4:3000';

  Future<Map<String, dynamic>> crearMensaje(MensajeElement mensaje) async {
    final url = '$_url/mensaje/crearmensaje';
    final resp = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: mensajeElementToJson(mensaje));
    final decodeData = json.decode(resp.body);
  
    print(decodeData);
    return decodeData;
  }
}