import 'dart:async';

import 'package:applojahouse/src/utils/validators.dart';
import 'package:applojahouse/src/models/usuario_model.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class RegistroBloc with Validators {


    final _nombreController = BehaviorSubject<String>();
    final _apellidoController = BehaviorSubject<String>();
    final _celularController = BehaviorSubject<String>();
    final _emailController = BehaviorSubject<String>();

  //RECUPERAR LOS DATOS DEL STREAM
  Stream<String> get nombreStream => _nombreController.stream;
  Stream<String> get apellidoStream => _apellidoController.stream;
  Stream<String> get celularStream => _celularController.stream;
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);


  Stream<bool> get formValidStream => Rx.combineLatest4(nombreStream, apellidoStream, celularStream, emailStream, (n, a, c, e) => true);

  //INSERTAR VALORES AL STREAM
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeApellido => _apellidoController.sink.add;
  Function(String) get changeCelular => _celularController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;


  //OBTENER LOS ULTIMOS VALORES INGRESADOS A LOS STREAMS
  String get nombre => _nombreController.value;
  String get apellido => _apellidoController.value;
  String get celular => _celularController.value;
  String get email => _emailController.value;


  final _registroUsuarioProvider = new UsuarioProvider();


 Future<Map<String, dynamic>> registrarNuevoUsuario(UsuarioModel usuario) async{
    Map data = await _registroUsuarioProvider.crearUsuario(usuario);

    if(data.toString().contains('token')){
      return data;
    }else{
      return data;
    }

  }

  dispose(){
    print('dispose');
    _nombreController?.close();
    _apellidoController?.close();
    _celularController?.close();
    _emailController?.close();
  }
}
