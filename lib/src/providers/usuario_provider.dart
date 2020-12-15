import 'dart:convert';

import 'package:applojahouse/src/models/usuario_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _url = 'http://192.168.1.4:3000';
      final preferencias = new PreferenciasUsuario();


  Future<Map<String, dynamic>> crearUsuario(UsuarioModel usuario) async {
    final url = '$_url/usuario/crearusuario';
    final resp = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: usuarioModelToJson(usuario));
    final decodeData = json.decode(resp.body);

    //responde el mensaje de error del backend o la respuesta json
    //print(decodeData['mensaje']);

    return decodeData;
  }

  Future<Map<String, dynamic>> obtenerUsuario() async{
    final url = '$_url/usuario/obtenerusuario/' + preferencias.idUsuario +'?token='+ preferencias.token;
    final resp = await http.get( url, headers: {"Content-type": "application/json"},);
    final body = json.decode(resp.body);
   //print(body);
    return body;
  }


  Future<Map<String, dynamic>> obtenerUsuarioEspecifico(String id) async{
    final url = '$_url/usuario/obtenerusuario/$id'+'?token='+ preferencias.token;
    final resp = await http.get( url, headers: {"Content-type": "application/json"},);
    final body = json.decode(resp.body);
    //print(resp.body);
    return body;
  }









 Future<http.StreamedResponse> actualizarImagen(String filePath) async{
    final url = '$_url/img/usuarios/${preferencias.idUsuario}';
    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("imagen", filePath));

    request.headers.addAll(
      {"Content-type": "multipart/form-data"}
      );

      var response = request.send();
      return response;
  }


  Future<bool> editarDatosDelPerfilUsuario(UsuarioModel usuario) async{
    final url = '$_url/usuario/actualizarusuario/${preferencias.idUsuario}?token=${preferencias.token}';
    final respuesta = await http.put(url, headers: {"Content-type": "application/json"}, body: usuarioModelToJson(usuario));
    final body = json.decode(respuesta.body);
    print(body);
    return true;
  }

  Future<Map<String, dynamic>> login(String correo, String password) async {
    final authData = {'correo': correo, 'password': password};

    final url = '$_url/login';
    final resp = await http.post(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(authData));
    final decodeData = json.decode(resp.body);

   // print(decodeData);
    return decodeData;
  }


    Future<Map<String, dynamic>> reseteoPassword(String correo) async {
    final authData = {'correo': correo};

    final url = '$_url/usuario/reseteopassword';
    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(authData));
    final decodeData = json.decode(resp.body);

   // print(decodeData);
    return decodeData;
  }

     Future<Map<String, dynamic>> cambiarPassword(String password) async {
    final authData = {'password': password};

    final url = '$_url/usuario/cambiarpassword/${preferencias.idUsuario}?token=${preferencias.token}';
    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(authData));
    final decodeData = json.decode(resp.body);

    //print(preferencias);
    return decodeData;
  }


 Future<Map<String, dynamic>> validarUsuario(String correo) async{
    final url = '$_url/usuario/validar/usuario/$correo';
    final resp = await http.get( url, headers: {"Content-type": "application/json"},);
    final body = json.decode(resp.body);
    return body;
  }
}
