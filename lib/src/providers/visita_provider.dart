import 'dart:convert';

import 'package:applojahouse/src/models/visita_model.dart';
import 'package:applojahouse/src/models/visitas.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class VisitaProvider {
  final String _url = 'http://192.168.1.4:3000';
  final preferenciaToken = new PreferenciasUsuario();

  Future<GetvisitaModel> obtenerVisitas() async {
    final url =
        '$_url/visita/arrendatario/visitasolicitada/0?token=${preferenciaToken.token}';

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    //Si el código es de acceso no autorizado, retorna null
    if (resp.statusCode == 401) {
      return null;
    } else {
      final body = getvisitaModelFromJson(resp.body);
      return body;
    }

    //print(body);
    //return body;
  }

  Future<bool> crearVisita(VisitaModel visita) async {
    final url = '$_url/visita/crearvisita?token=${preferenciaToken.token}';
    final resp = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: visitaModelToJson(visita));
    print(resp.body);
    final decodeData = json.decode(resp.body);
    print(url);

    print(decodeData);

    return true;
  }

  Future<bool> editarVisita(VisitaModel visita) async {
    final url = '$_url/visita/actualizarvisita/${visita.id}/?token=';
    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(visita));
    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;
  }

  Future<int> borrarVisita(String id) async {
    final url = '$_url/visita/eliminarvisita/$id?token=';
    final resp = await http.delete(url);
    print(resp.body);

    return 1;
  }
}
