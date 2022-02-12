import 'package:applojahouse/src/bloc/mensaje_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/utils/debouncer.dart';
import 'package:applojahouse/src/models/mensaje.model.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:flutter/material.dart';

class MensajePage extends StatefulWidget {
  @override
  _MensajePageState createState() => _MensajePageState();
}

class _MensajePageState extends State<MensajePage> {
  final estiloTitulo = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  MensajeElement mensajeElement = new MensajeElement();

  MensajeBloc mensajeBloc;

  bool guardando = false;

  DateTime tiempo = new DateTime.now();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mensajeBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mensajeBloc = Provider.mensajeBloc(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Enviar mensaje'),
      ),
      body: Center(
        child: _mensajeForm(context),
      ),
    );
  }

  _mensajeForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 30.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
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
                  title: Text('Regresar',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black45)),
                  leading: Icon(Icons.arrow_back_outlined),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('home', (route) => false);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Contáctate con el administrador',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.deepOrangeAccent),
                ),
                SizedBox(
                  height: 30.0,
                ),
                _crearTituloDelMensaje(mensajeBloc),
                SizedBox(
                  height: 20.0,
                ),
                _crearAsuntoDelMensaje(mensajeBloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearEmail(mensajeBloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(mensajeBloc),
              ],
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  _crearBoton(MensajeBloc mensajeBloc) {
    return StreamBuilder(
      stream: mensajeBloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
            child: Text('Enviar mensaje'.toUpperCase()),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 10.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData
              ? () {
                  _crearMensaje(context, mensajeBloc);
                }
              : null,
        );
      },
    );
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _crearMensaje(BuildContext context, MensajeBloc mensajeBloc) async {
    mensajeElement.titulo = mensajeBloc.titulo.toString();
    mensajeElement.asunto = mensajeBloc.asunto.toString();
    mensajeElement.correo = mensajeBloc.email.toString();
    mensajeElement.fecha = tiempo;

    Map respuesta = await mensajeBloc.crearMensaje(mensajeElement);

    if (respuesta['ok']) {
      mostrarSnackBar('Mensaje enviado correctamente');
      final _debouncer = Debouncer(milliseconds: 2500);
      _debouncer.run(() => Navigator.pushReplacementNamed(context, 'home'));

      //mensajeBloc.dispose();

      //Navigator.pushReplacementNamed(context, 'login');
    } else {
      mostrarAlerta(context, respuesta['mensaje']);
      //mensajeBloc.dispose();
    }

    /*mostrarSnackBar('Mensaje enviado correctamente');
    final _debouncer = Debouncer(milliseconds: 2000);
    _debouncer.run(() => Navigator.pushReplacementNamed(context, 'home'));*/
    //Navigator.pop(context);
  }

  _crearTituloDelMensaje(MensajeBloc bloc) {
    return StreamBuilder(
      stream: bloc.tituloDelMensajeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: 'Título del mensaje',
                hintText: 'Ejm.: Recuperar cuenta',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0))),
            onChanged: bloc.changeTituloMensaje,
          ),
        );
      },
    );
  }

  _crearAsuntoDelMensaje(MensajeBloc bloc) {
    return StreamBuilder(
      stream: bloc.asuntoDelMensajeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            maxLines: 5,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                labelText: ('Descripción'),
                hintText: 'Escriba el asunto del mensaje aquí',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0))),
            onChanged: bloc.changeAsuntoMensaje,
          ),
        );
      },
    );
  }

  _crearEmail(MensajeBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: 'ejemplo@gmail.com',
                labelText: 'Correo Electrónico',
                errorText: snapshot.error,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0))),
            onChanged: bloc.changeEmail,
          ),
        );
      },
    );
  }
}
