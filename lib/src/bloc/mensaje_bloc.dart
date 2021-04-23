import 'dart:async';
import 'package:applojahouse/src/bloc/validators.dart';
import 'package:applojahouse/src/models/mensaje.model.dart';
import 'package:applojahouse/src/providers/mensaje_provider.dart';
import 'package:rxdart/rxdart.dart';

class MensajeBloc with Validators{

  final _tituloDelMensajeController = new BehaviorSubject<String>();
  final _asuntoDelMensajeController = new BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  

    //RECUPERAR LOS DATOS DEL STREAM
    Stream<String> get tituloDelMensajeStream => _tituloDelMensajeController.stream;
    Stream<String> get asuntoDelMensajeStream => _asuntoDelMensajeController.stream;
    Stream<String> get emailStream => _emailController.stream.transform(validarEmail);


  Stream<bool> get formValidStream => Rx.combineLatest3(tituloDelMensajeStream, asuntoDelMensajeStream, emailStream, (t, a, e) => true);


  //INSERTAR VALORES AL STREAM
  Function(String) get changeTituloMensaje => _tituloDelMensajeController.sink.add;
  Function(String) get changeAsuntoMensaje => _asuntoDelMensajeController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;


  //OBTENER LOS ULTIMOS VALORES INGRESADOS A LOS STREAMS
  String get titulo => _tituloDelMensajeController.value;
  String get asunto => _asuntoDelMensajeController.value;
  String get email => _emailController.value;

final _mensajeProvider = new MensajeProvider();

 Future<Map<String, dynamic>> crearMensaje(MensajeElement mensaje) async{
    Map data = await _mensajeProvider.crearMensaje(mensaje);
      return data;
  }


  dispose(){
    _tituloDelMensajeController?.close();
    _asuntoDelMensajeController?.close();
    _emailController?.close();
  }
}