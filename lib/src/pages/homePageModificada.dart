import 'dart:convert';

import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/providers/inmueble_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inmueblesProvider = new InmuebleProvider();
  List<String> lista;
  Future<InmuebleModel> obtenerInmuebles() async {
    print("entroe a obetner ");
    final url = 'http://192.168.1.4:3000/inmueble/inmuebles/publicos/movil';
    final resp = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    final body = inmuebleModelFromJson(resp.body);
    return body;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: FutureBuilder(
        future: obtenerInmuebles(),
        builder: (BuildContext context,
            AsyncSnapshot<InmuebleModel> snapshot) {
          if (snapshot.hasError) {
            print("eroro: " + snapshot.hasError.toString());
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.inmuebles.length,
              itemBuilder: (context, index){
                Inmueble inn = snapshot.data.inmuebles[index];
                return Text("${inn.nombre}");
                //print(inn.servicio);
              });
          } else {
            print("no hay datos ");
             return Center(
            child: CircularProgressIndicator(),
          );
          }
        },
      ),
      //floatingActionButton: _crearBoton(context),
    );
  }

 /* _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'usuario'));
  }*/

  /*_crearListadoInmuebles() {
    return FutureBuilder(
      future: obtenerInmuebles(),
      builder: (BuildContext context, AsyncSnapshot<InmuebleModel> snapshot) {
        print('datos obtenidos ' + snapshot.data.toString());
        if (snapshot.hasData) {
          print("ffffff" + snapshot.data.publicado);
          /*final inmuebles = snapshot.data;
          return ListView.builder(
            itemBuilder: (context, i) => _crearItemInmueble(inmuebles),
          );*/
        } else {
          print('no puede llegar');
          /* return Center(
            child: CircularProgressIndicator(),
          );*/
        }
      },
    );
  }*/

  /* _crearItemInmueble(InmuebleModel inmueble) {
    return ListTile(
      title: Text('${inmueble.nombre} - ${inmueble.precioalquiler}'),
      subtitle: Text(inmueble.id),
      onTap: () => {},
    );
  }*/
}
