import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/pages/aceptarContrato_page.dart';
import 'package:applojahouse/src/pages/cambiarPassword_page.dart';
import 'package:applojahouse/src/pages/enviarMensajePage.dart';
import 'package:applojahouse/src/pages/filtroInmueblePage.dart';
import 'package:applojahouse/src/pages/home_page.dart';
import 'package:applojahouse/src/pages/listaContratosArrendatario_page.dart';
import 'package:applojahouse/src/pages/login_page.dart';
import 'package:applojahouse/src/pages/perfil_page.dart';
import 'package:applojahouse/src/pages/registro_page.dart';
import 'package:applojahouse/src/pages/reseteoPassword_page.dart';
import 'package:applojahouse/src/pages/verVisitaRealizada_page.dart';
import 'package:applojahouse/src/pages/crearVisita_page.dart';
import 'package:applojahouse/src/pages/visitas_solicitadas_page.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/singleton/conexion_singleton.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferencias = new PreferenciasUsuario();
  await preferencias.initPreferencias();

  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*final pushProvider = PushNotificationsProvider();
    pushProvider.initNotifications();

    pushProvider.mensajes.listen((data) {
      print('Argumento');
      print(data);
      navigatorKey.currentState.pushNamed('recibirnotificacion', arguments: data);
    });*/
    
  }
  @override
  Widget build(BuildContext context) {
    
    //final preferencias = new PreferenciasUsuario();

    //print("FCM: ${preferencias.tokenFCM}");

  /*  if(preferencias.token != true){
      print(preferencias.token);
    }else{
      preferencias.clear();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }*/
    return Provider(
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('es', 'ES'),
        ],
        debugShowCheckedModeBanner: false,
        //navigatorKey: navigatorKey,
        title: 'Material App',
        initialRoute: 'home',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'home': (BuildContext context) => HomePage(),
          //'usuario': (BuildContext context) => UsuarioPage(),
          'visita': (BuildContext context) => VisitaPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'perfil': (BuildContext context) => PerfilPage(),
          'reseteopassword': (BuildContext context) => ReseteoPasswordPage(),
          'cambiopassword': (BuildContext context) => CambiarPasswordPage(),
          'visitas': (BuildContext context) => VisitasSolicitadasArrPage(),
          'visitasrealizadas': (BuildContext context) => VerVisitaRealizadaPage(),
          'listacontratos': (BuildContext context) => ListaContratosArrPage(),
          'acuerdo': (BuildContext context) => AceptarContratoPage(),
          'mensaje': (BuildContext context) => MensajePage(),
          'filtroinmueble': (BuildContext context) => FiltroInmueblePage(),
          //'notification': (BuildContext context) => NotificacionPage(),
          //'recibirnotificacion': (BuildContext context) => RecibirNotificacionPage(),
        },
        theme: ThemeData(primaryColor: Colors.blueAccent),
      ),
    );
  }
}
