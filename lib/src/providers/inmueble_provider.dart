
import 'dart:convert';

import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class InmuebleProvider {
  final String _url = URL;
  final preferenciaToken = new PreferenciasUsuario();

  Future<InmuebleModel> obtenerInmuebles() async {
    final url = '$_url/inmueble/inmuebles/publicos/movil';

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    print(resp.statusCode);    

    if(resp.statusCode == 200){
      final body = inmuebleModelFromJson(resp.body);
      return body;

    }else{
      return null;
    }
    //print(body.inmuebles.map((e) => e.imagen));
    //body.inmuebles.forEach((element) {print(element.imagen);});
  }

  Future<InmuebleModel> buscarInmueble(String query) async {
    final url = '$_url/inmueble/buscar/$query';

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );
    print(resp.statusCode);

    if( resp.statusCode == 200 ){
      final body = inmuebleModelFromJson(resp.body);
      return body;
    }else{
      return null;
    }
  }


  Future<Map<String, dynamic>> busquedaAnidadaInmuebles(String tipo, String ubicacion, String precio) async {
    final url = '$_url/busqueda/coleccion/inmuebles/'+tipo+'/'+ubicacion+'/'+precio;

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    //print(resp.body);
    final body = json.decode(resp.body);

    /*for (var i = 0; i < body['inmuebles'].length; i++) {
      print(i);
    }*/
    if(resp.statusCode == 200){
      return body;
    }else{
      return {'ok': false,'inmuebles': null};
    }
    /*if( resp.statusCode == 200 ){
      final body = inmuebleModelFromJson(resp.body);
      return body;
    }else{
      return null;
    }*/
  }
}
