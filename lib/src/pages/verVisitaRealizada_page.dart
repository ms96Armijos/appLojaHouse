import 'dart:io';

import 'package:applojahouse/src/bloc/perfil_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/visitas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VerVisitaRealizadaPage extends StatefulWidget {
  @override
  _VerVisitaRealizadaPageState createState() => _VerVisitaRealizadaPageState();
}

class _VerVisitaRealizadaPageState extends State<VerVisitaRealizadaPage> {
  final estiloTitulo = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  Visita visitaModel = new Visita();

  bool guardando = false;

  PerfilBloc usuarioBloc;

  void launchWhatsApp({
    @required int phone,
    @required String message,
  }) async {
    String url() {
      if (Platform.isAndroid) {
        // add the [https]
        return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
      } else {
        // add the [https]
        return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'No se puede realizar esta acción ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final visitaObtenida = ModalRoute.of(context).settings.arguments;
    usuarioBloc = Provider.perfilBloc(context);

    for (var item in visitaObtenida) {
      print(item['estado']);
      visitaModel = Visita(
        estado: item["estado"],
        id: item["_id"],
        fecha: DateTime.parse(item["fecha"]),
        descripcion: item["descripcion"],
        inmueble: Inmueble.fromJson(item["inmueble"]),
        usuarioarrendatario: Usuarioarrendatario.fromJson(item["usuarioarrendatario"]),
        );
    }




    /*if (visitaObtenida != null) {
      visitaModel = visitaObtenida;
      print('bien');
    } else {
      print('nulo');
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalle de la solicitud de visita',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _crearCardInformacionInmueble(),
              Form(
                child: Column(
                  children: [
                    // _crearBoton(),
                    SizedBox(
                      height: 20.0,
                    ),
                    //_crearDisponible()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _crearCardInformacionInmueble() {
    return Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            _crearSliderDeImagenes(),
            SizedBox(
              height: 15.0,
            ),
            Container(
                child: Column(
              children: [
                _crearTitulo(),
                _crearTextoDescripcion(),
                SizedBox(
                  height: 10.0,
                ),
                Divider(),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: Text(
                  'Información de contacto del arrendador',
                  style: TextStyle(
                      //fontFamily: 'ubuntu',
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent),
                )),
                SizedBox(
                  height: 15.0,
                ),
                FutureBuilder(
                    future: usuarioBloc.cargarUsuarioEspecifico(
                        visitaModel.inmueble.usuario.toString()),
                    builder: (BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot) {
                      //print(visitaModel.inmueble.usuario);
                      if (snapshot.hasData) {
                        return Container(
                            child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: (snapshot.data['usuario']
                                            ['imagen'] !=
                                        null)
                                    ? NetworkImage(
                                        snapshot.data['usuario']['imagen'][0]['url'].toString())
                                    : NetworkImage(
                                        'https://cdn2.f-cdn.com/contestentries/1316431/24595406/5ae8a3f2e4e98_thumb900.jpg'),
                              ),
                              title: Text(snapshot.data['usuario']['nombre'] +
                                  ' ' +
                                  snapshot.data['usuario']['apellido']),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () => {
                                    if(snapshot.data['usuario']['convencional'].toString().length>0){
                                      launch('tel://' +
                                      snapshot.data['usuario']['convencional'])
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      _contador(
                                          context,
                                          'Llama al\nmóvil',
                                          Icons.phone_android),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                InkWell(
                                  onTap: () => {
                                    if(snapshot.data['usuario']['movil'].toString().length>0){
                                      launchWhatsApp(
                                      phone: int.parse(
                                          snapshot.data['usuario']['movil']),
                                      message: 'Hola, \"${snapshot.data['usuario']['nombre']}\" estoy interesado en su inmueble publicado en LOJAHOUSE y me gustaría acercarme a visitarlo.')
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      _contador(
                                          context,
                                          'Envía un\nWhatsapp',
                                          Icons.phone_android),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                InkWell(
                                  onTap: () => {
                                    if(snapshot.data['usuario']['convencional'].toString().length>0){
                                      launch('tel://' +
                                      snapshot.data['usuario']['convencional'])
                                    }
                                  },
                                  child: _contador(
                                      context,
                                      'Llama al\nConvencional',
                                      Icons.add_ic_call_sharp),
                                )
                              ],
                            ),
                          ],
                        ));
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
                SizedBox(
                  height: 10.0,
                ),
              ],
            )),
            SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }

  _crearSliderDeImagenes() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      height: 250.0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/caracol.gif'),
              image: NetworkImage(visitaModel.inmueble.imagen[index].url.toString()),
              height: 300.0,
              width: 300.0,
              fit: BoxFit.cover,
            ),
          );
        },
        autoplay: true,
        itemCount: visitaModel.inmueble.imagen.length,
        pagination: new SwiperPagination(),
      ),
    );
  }

  _crearTitulo() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    visitaModel.inmueble.nombre.toString(),
                    style: estiloTitulo,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'La visita será el:',
                    style: estiloSubTitulo,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  _fecha(context, visitaModel),
                  SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'La visita está:',
                    style: estiloSubTitulo,
                  ),
                  Text(
                    visitaModel.estado.toString(),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _crearTextoDescripcion() {
    return SafeArea(
      child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción de la solicitud:',
                      textAlign: TextAlign.start,
                      style: estiloSubTitulo,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      visitaModel.descripcion.toString(),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _fecha(BuildContext context, Visita visita) {
    String fechaFormateada = DateFormat('dd-MM-yyyy').format(visita.fecha);
    return Text(
      fechaFormateada,
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
    );
  }

  _contador(
    BuildContext context,
    String tipo,
    IconData logo,
  ) {
    return Column(
      children: <Widget>[
        Icon(
          logo,
          size: 18.0,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          tipo,
          style: TextStyle(fontSize: 12.0),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
