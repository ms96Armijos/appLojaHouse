import 'dart:convert';

import 'package:applojahouse/src/models/visita_model.dart';
import 'package:applojahouse/src/models/visitas.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class VisitaProvider {
  final String _url = URL;
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
    if(resp.statusCode == 200){
      final decodeData = json.decode(resp.body);
      print(decodeData);
      return true;
    }else{
      return null;
    }
  }

  Future<Map<String, dynamic>> eliminarVisita(
      String id, String estado) async {
    final authData = {'estado': estado};

    final url = '$_url/visita/eliminarvisita/$id?token=${preferenciaToken.token}';

    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(authData));
        
    print(resp.body);
    if(resp.statusCode == 200){
      final decodeData = json.decode(resp.body);
      return decodeData;
    }else{
      return null;
    }
  }

 /* Future<int> borrarVisita(String id) async {
    final url = '$_url/visita/eliminarvisita/$id?token=${preferenciaToken.token}';
    final resp = await http.delete(url);
    print(resp.body);

    return 1;
  }*/
}
