import 'dart:async';
import 'dart:io';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:firebase_messaging/firebase_messaging.dart';




class PushNotificationsProvider{

  final _mensajesStreamController = StreamController<String>.broadcast();

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
   final _preferenciasDelUsuario = new PreferenciasUsuario();




Stream<String> get mensajes => _mensajesStreamController.stream;


  initNotifications(){
    _firebaseMessaging.requestNotificationPermissions();

    _firebaseMessaging.getToken().then((tokenValue) async{
      print('===== FCM Token ====');
      print('mi token $tokenValue');
      _preferenciasDelUsuario.tokenFCM = tokenValue;
      print('GUARDADO: ${_preferenciasDelUsuario.tokenFCM}');
    //guardar el token
      });

      _firebaseMessaging.configure(
        onMessage: (info){
          print('==== On Message ====');
          print(info);

          String argumento = 'no-data';
          if(Platform.isAndroid){
            argumento = info['data']['Comida']??'no-data';
          }
          _mensajesStreamController.sink.add(argumento);
        },

        onLaunch: (info){
          print('==== On Message ====');
          print(info);
          
        },

        onResume: (info){
          print('==== On Message ====');
          print(info);
          final argumento = info['data']['Comida'];
          print(argumento);
          String argumentoResume = 'no-data';
          if(Platform.isAndroid){
            argumentoResume = info['data']['Comida']??'no-data';
          }
          _mensajesStreamController.sink.add(argumentoResume);
        }
      );

  }


  _dispose(){
    _mensajesStreamController.close();
  }
}