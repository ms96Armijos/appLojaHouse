import 'dart:convert';

import 'package:applojahouse/src/models/mensaje.model.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class MensajeProvider{

  final String _url = URL;

  Future<Map<String, dynamic>> crearMensaje(MensajeElement mensaje) async {
    final url = '$_url/mensaje/crearmensaje';
    final resp = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: mensajeElementToJson(mensaje));
    if(resp.statusCode == 200){
      final decodeData = json.decode(resp.body);
      print(decodeData);
      return decodeData;
    }else{
      return null;
    }
  }
}