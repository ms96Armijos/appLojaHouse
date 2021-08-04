import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/usuario_model.dart';
import 'package:applojahouse/src/pages/login_page.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:applojahouse/src/widgets/banner_widget.dart';
import 'package:flutter/material.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final UsuarioModel usuario = new UsuarioModel();

  RegistroBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = new RegistroBloc();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    bloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
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
            padding: EdgeInsets.symmetric(vertical: 50.0),
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
                _crearNombre(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearApellido(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearCelular(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearEmail(bloc),
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
              child: Text('¿Ya tienes una cuenta?')),
          FlatButton(
            child: Text(
              'Inicia Sesión',
              style: TextStyle(color: Colors.blueAccent),
            ),
            onPressed: () {
              bloc.dispose();
              Navigator.pushReplacementNamed(context, 'login');

            },
          ),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }

  _crearNombre(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                ),
                labelText: 'Nombres',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeNombre,
          ),
        );
      },
    );
  }

  _crearApellido(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.apellidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                ),
                labelText: 'Apellidos',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeApellido,
          ),
        );
      },
    );
  }

  _crearCelular(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.celularStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.phone_android,
                  color: Colors.blueAccent,
                ),
                labelText: 'Celular',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeCelular,
          ),
        );
      },
    );
  }

  _crearEmail(RegistroBloc bloc) {
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

  _crearBoton(RegistroBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Crear cuenta'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 10.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData
              ? () {
                  _registroDeUsuario(context, bloc);
                }
              : null,
        );
      },
    );
  }

  _registroDeUsuario(BuildContext context, RegistroBloc bloc) async {
    usuario.nombre = bloc.nombre.toString();
    usuario.apellido = bloc.apellido.toString();
    usuario.movil = bloc.celular.toString();
    usuario.correo = bloc.email.toString();

    Map respuesta = await bloc.registrarNuevoUsuario(usuario);
    print(respuesta);
    if (respuesta['ok']) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
          (Route<dynamic> route) => false);
      //bloc.dispose();

      //Navigator.pushReplacementNamed(context, 'login');
    } else {
      mostrarAlerta(context, respuesta['mensaje']);
      //bloc.dispose();
    }
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
          valor: 'Regístrate en LojaHouse',
        )
      ],
    );
  }
}
