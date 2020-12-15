import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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