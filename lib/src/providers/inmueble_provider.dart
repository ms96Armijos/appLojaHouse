import 'dart:convert';

import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class InmuebleProvider {
  final String _url = 'http://192.168.1.4:3000';
  final preferenciaToken = new PreferenciasUsuario();

  Future<InmuebleModel> obtenerInmuebles() async {
    final url = '$_url/inmueble/inmuebles/publicos/movil';

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    final body = inmuebleModelFromJson(resp.body);
    //print(body.inmuebles.map((e) => e.imagen));
    //body.inmuebles.forEach((element) {print(element.imagen);});
    return body;
  }

  Future<int> borrarInmueble(String id) async {
    final url = '$_url/usuario/eliminarinmueble/$id?toke=';
    final resp = await http.delete(url);
    print(resp.body);
    return 1;
  }

  Future<InmuebleModel> buscarInmueble(String query) async {
    final url = '$_url/busqueda/coleccion/inmuebles/$query?token='+preferenciaToken.token;

    
    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );
    print(resp.statusCode);

    final body = inmuebleModelFromJson(resp.body);
    return body;
  }
}
