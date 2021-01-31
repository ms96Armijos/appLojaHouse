import 'dart:convert';

import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class ContratoProvider {
  final String _url = 'http://192.168.1.4:3000';
  final preferenciaToken = new PreferenciasUsuario();

  Future<ContratoModel> obtenerContratos() async {
    final url =
        '$_url/contrato/arrendatario/obtenercontratos/0?token=${preferenciaToken.token}';

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    //Si el código es de acceso no autorizado, retorna null
    if (resp.statusCode == 401) {
      return contratoModelFromJson(resp.body);
    } else {
      final body = contratoModelFromJson(resp.body);
      return body;
    }

    //print(body);
    //return body;
  }

  Future<bool> verificartoken() async {
    final url =
        '$_url/contrato/arrendatario/obtenercontratos/0?token=${preferenciaToken.token}';
    bool result;
    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    //Si el código es de acceso no autorizado, retorna null
    if (resp.statusCode == 401) {
      result = true;
    } else {
      result = false;
    }
    return result;

    //print(body);
    //return body;
  }

  Future<ContratoModel> obtenerContratoEspecifico(String id) async {
    final url = '$_url/contrato/obtenercontrato/$id' +
        '?token=' +
        preferenciaToken.token;
    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );
    final body = contratoModelFromJson(resp.body);
    //print(resp.body);
    return body;
  }

  Future<Map<String, dynamic>> aceptarContrato(
      String id, String acuerdo, String estado) async {
    final authData = {'acuerdo': acuerdo, 'estado': estado};

    final url =
        '$_url/contrato/acuerdo/$id/aceptar?token=' + preferenciaToken.token;
    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(authData));
    print(resp.body);
    final decodeData = json.decode(resp.body);

    return decodeData;
  }

  //TODO: EDITAR ESTE MÉTODO
  Future<int> borrarContrato(String id) async {
    final url = '$_url/visita/eliminarvisita/$id?token=';
    final resp = await http.delete(url);
    print(resp.body);

    return 1;
  }
}
