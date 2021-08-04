import 'dart:convert';

import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class ContratoProvider {
  final String _url = URL;
  final preferenciaToken = new PreferenciasUsuario();

  Future<ContratoModel> obtenerContratos(int cantidad) async {
    final url =
        '$_url/contrato/arrendatario/obtenercontratos/$cantidad?token=${preferenciaToken.token}';

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    //Si el código es de acceso no autorizado, retorna null
    if (resp.statusCode == 401) {
      return contratoModelFromJson(resp.body);
    } else {
      final body = contratoModelFromJson(resp.body);
      //print('Total: ${body.total}');
      return body;
    }

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

    if( resp.statusCode == 200){
      final body = contratoModelFromJson(resp.body);
      return body;
    }else{
      return null;
    }
    //print(resp.body);
  }

  Future<Map<String, dynamic>> aceptarContrato(
    String id, String acuerdo, String estado) async {
    final data = {'acuerdo': acuerdo, 'estado': estado};
    final url = '$_url/contrato/acuerdo/$id/aceptar?token=' + preferenciaToken.token;
    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(data));
    if(resp.statusCode == 200){
      final decodeData = json.decode(resp.body);
      return decodeData;
    }else{
      return null;
    }
  }

  //TODO: EDITAR ESTE MÉTODO
  Future<int> borrarContrato(String id) async {
    final url = '$_url/visita/eliminarvisita/$id?token=';
    final resp = await http.delete(url);
    print(resp.body);
    return 1;
  }
}
