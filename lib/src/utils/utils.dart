import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//String URL = 'http://192.168.1.56:3000';
String URL = 'https://backendlh.herokuapp.com';
String ACEPTADO = 'ACEPTADO';
String VIGENTE = 'VIGENTE';
String URLFOTOPERFIL = 'https://cdn.pixabay.com/photo/2016/08/31/11/54/user-1633248_960_720.png';


bool esNumero(String valor) {
  if (valor.isEmpty) return false;
  final numero = num.tryParse(valor);

  return (numero == null) ? false : true;
}


void mostrarAlerta( BuildContext context, String mensaje){

  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Credenciales incorrectas'),
        content: Text(mensaje),
        actions: [
          FlatButton( 
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
            )
        ],
      );
    }
  );
}