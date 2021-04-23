import 'dart:async';

import 'package:applojahouse/src/bloc/validators.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class LoginBloc with Validators{

  final _preferenciasDelUsuario = new PreferenciasUsuario();

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _nuevaPasswordController = BehaviorSubject<String>();
  final _confirmarPasswordController = BehaviorSubject<String>();

  //RECUPERAR LOS DATOS DEL STREAM
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarCampoDeTextoVacio);
  Stream<String> get nuevaPasswordStream => _nuevaPasswordController.stream.transform(validarPassword);
  Stream<String> get confirmarPasswordStream => _confirmarPasswordController.stream.transform(validarPassword);


  Stream<bool> get formValidStream => Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);
  Stream<bool> get formValidCorreoStream => emailStream.withLatestFrom(emailStream, (t, s) => true);
  Stream<bool> get formValidPasswordStream => Rx.combineLatest2(nuevaPasswordStream, confirmarPasswordStream, (e, p) => true);

  //INSERTAR VALORES AL STREAM
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeNuevaPassword => _nuevaPasswordController.sink.add;
  Function(String) get changeConfirmPassword => _confirmarPasswordController.sink.add;



  //OBTENER LOS ULTIMOS VALORES INGRESADOS A LOS STREAMS
  String get email => _emailController.value;
  String get password => _passwordController.value;
  String get nuevaPassword => _nuevaPasswordController.value;
  String get confirmarPassword => _confirmarPasswordController.value;

  final _loginUsuarioProvider = new UsuarioProvider();


   Future<Map<String, dynamic>> loguearUsuario(String correo, String password) async{
    Map data = await _loginUsuarioProvider.login(correo, password);


Map<String, dynamic> decodedToken = JwtDecoder.decode(data['token']);
  // Now you can use your decoded token
  //print('Token ${decodedToken['usuario']['_id']}');

    if(data.toString().contains('token')){
      _preferenciasDelUsuario.token = data['token'];
      _preferenciasDelUsuario.idUsuario = decodedToken['usuario']['_id'];
      //_preferenciasDelUsuario.idUsuario = _preferenciasDelUsuario.tokenFCM;
      return data;
    }else{
      return data;
    }
  }
  

   Future<Map<String, dynamic>> reseteoPassword(String correo) async{
    Map data = await _loginUsuarioProvider.reseteoPassword(correo);
      //print(data);
      return data;
  }

    Future<Map<String, dynamic>> cambiarPassword(String password) async{
    Map data = await _loginUsuarioProvider.cambiarPassword(password);
      //print(data);
      return data;
  }

      Future<Map<String, dynamic>> validarUsuario(String correo) async{
    Map data = await _loginUsuarioProvider.validarUsuario(correo);
      //print(data);
      return data;
  }

    //TODO: Corregir esto del token
    Future<bool> editarTokenFCMDelUsuario(firebaseToken) async {
    final respuesta =
        await _loginUsuarioProvider.editarTokenFCMDelUsuario(firebaseToken);
    return respuesta;
  }

  dispose(){
    _emailController?.close();
    _passwordController?.close();
    _confirmarPasswordController?.close();
    _nuevaPasswordController?.close();
  }
}
