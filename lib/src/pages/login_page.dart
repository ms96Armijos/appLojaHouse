import 'dart:async';

import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/singleton/conexion_singleton.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:applojahouse/src/widgets/banner_widget.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginBloc bloc = new LoginBloc();

  //para verificar si el smartphone tiene internet
  StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  bool visible = true;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String firenaseToken;


  @override
  initState() {
    super.initState();
    
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);

    _firebaseMessaging.getToken().then((value) {
      print('mi token $value');
    
    firenaseToken = value;
      

  _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async{
        print('onResume: $message');
      }
    );

  
});


        //print('conecction status: $_connectionChangeStream');
  }

  void connectionChanged(dynamic hasConnection) {
    if(mounted)
    setState(() {
      isOffline = !hasConnection;
      //print('conection: $hasConnection');
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                ListTile(
            leading: Icon(Icons.arrow_back_outlined),
            title: Text('Regresar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
            },
          ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        (isOffline)
                            ? Column(children: [
                              Text(
                                'No tienes conexión a internet',
                                style: TextStyle(
                                    backgroundColor: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 20.0,),
                              CircularProgressIndicator()
                            ],)
                            : Container()
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20.0,),
                _crearEmail(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'reseteopassword');
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                      alignment: Alignment.centerRight,
                      child: Text('¿Olvidaste tu contraseña?')),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              alignment: Alignment.centerLeft,
              child: Text('¿No tienes cuenta?')),
          FlatButton(
            child: Text(
              'Regístrate',
              style: TextStyle(color: Colors.blueAccent),
            ),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'registro'),
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  _crearEmail(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.email,
                  color: Colors.blueAccent,
                ),
                hintText: 'ejemplo@gmail.com',
                labelText: 'Correo Electrónico',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }

  _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: visible,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.blueAccent,
                ),
                suffixIcon: IconButton(
                  icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    if(mounted)
                    setState(() {
                      visible = !visible;
                    });
                  },
                ),
                labelText: 'Contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changePassword,
          ),
        );
      },
    );
  }

  _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
            child: Text('Iniciar sesión'.toUpperCase()),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 10.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData
              ? () {
                  _login(context, bloc);
                }
              : null,
        );
      },
    );
  }

  _login(BuildContext context, LoginBloc bloc) async {
    String correo = bloc.email.toString();
    String password = bloc.password.toString();

    Map usuarioArrendatario = await bloc.validarUsuario(correo);
    //SI OCURRE UN ERROR IMPRIMO EL MENSAJE EN UN SNACKBAR
    if (usuarioArrendatario['ok'] == false) {
      mostrarSnackBar(usuarioArrendatario['mensaje']);
    }

    //VERIFICO QUE SOLO SEAN USUARIOS ARRENDATARIOS PARA ACCEDER A LA APP
      print(usuarioArrendatario['usuario']);
    if (usuarioArrendatario['usuario'] == 'ARRENDATARIO') {
      Map respuesta = await bloc.loguearUsuario(correo, password);
      if (respuesta['ok']) {
            //TODO: Corregir esto del token
         await bloc.editarTokenFCMDelUsuario(firenaseToken);
        //_preferenciasDelUsuario.tokenFCM
        Navigator.pushReplacementNamed(context, 'home');
      } else {
        mostrarAlerta(context, respuesta['mensaje']);
      }
    }else{
      mostrarAlerta(context, 'El usuario no es un arrendatario');
    }

    /**/
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(0, 136, 235, 1.0),
          Color.fromRGBO(16, 88, 142, 1.0),
        ],
      )),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          right: -30.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          right: -10.0,
          child: circulo,
        ),
        Positioned(
          bottom: 120.0,
          right: 20.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          left: -20.0,
          child: circulo,
        ),
        BannerWidget(
          valor: 'Inicia sesión en LojaHouse',
        ),
      ],
    );
  }
}
