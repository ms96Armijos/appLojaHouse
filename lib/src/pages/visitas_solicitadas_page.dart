import 'dart:async';
import 'dart:convert';

import 'package:applojahouse/src/pages/home_page.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class VisitasSolicitadasArrPage extends StatefulWidget {
  @override
  _VisitasSolicitadasArrPageState createState() =>
      _VisitasSolicitadasArrPageState();
}

class _VisitasSolicitadasArrPageState extends State<VisitasSolicitadasArrPage> {
  final estiloTitulo = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  ScrollController _scrollController = new ScrollController();
  final preferenciaToken = new PreferenciasUsuario();

  List<dynamic> listadoVisitasSolicitadas = new List();
  int _total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtener6();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        obtener6();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController?.dispose();
    print('Dispose...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Solicitudes de visita Arrendatario',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        //drawer: MenuWidget(),
        body: (listadoVisitasSolicitadas.length > 0)
            ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: (listadoVisitasSolicitadas.length),
                  itemBuilder: (context, index) {
                    return _crearItemVisita(
                        context, listadoVisitasSolicitadas, index);
                    //print(inn.servicio);
                  },
                ),
              )
            : Center(
                child: Container(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.0,
                          ),
                          Text(
                            "¡Lo siento!",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          FadeInImage(
                            placeholder: AssetImage('assets/img/empty.png'),
                            image: AssetImage('assets/img/empty.png'),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text("No has solicitado visitas",
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent)),
                          SizedBox(
                            height: 30.0,
                          ),
                          _crearBotonCancelar(context),
                          SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    )),
              ));
  }

    _crearBotonCancelar(BuildContext context) {
    return RaisedButton(
      color: Colors.blueAccent,
      onPressed: () {
        Navigator.pop(context);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
       //obtenerVisitas();
      },
      elevation: 4.0,
      splashColor: Colors.blueGrey,
      child: Text(
        'Regresar'.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }
  

  _crearItemVisita(BuildContext context,
      List<dynamic> listadoVisitasSolicitadas, int index) {
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearTitulo(context, listadoVisitasSolicitadas, index),
          ],
        ),
      ),
    );
  }

  _crearTitulo(BuildContext context, List<dynamic> listadoVisitasSolicitadas,
      int index) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                        context, 'visitasrealizadas',
                        arguments: {listadoVisitasSolicitadas[index][index]}),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solicitud realizada al inmueble:',
                          style: estiloSubTitulo,
                        ),
                        Text(
                          listadoVisitasSolicitadas[index][index]['inmueble']
                                  ['nombre']
                              .toString(),
                          //visita.inmueble.nombre.toString(),
                          style: estiloTitulo,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Estado de la solicitud',
                          style: estiloSubTitulo,
                        ),
                        Text(
                          listadoVisitasSolicitadas[index][index]['estado']
                              .toString(),
                          //visita.estado.toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          'Fecha de visita',
                          style: estiloSubTitulo,
                        ),
                        _fecha(
                          context,
                          listadoVisitasSolicitadas[index][index]['fecha']
                              .toString(),
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pushNamed(context, 'visitasrealizadas',
                      arguments: {listadoVisitasSolicitadas[index][index]}),
                  child: Column(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Text(
                            'Ver más',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              _crearBotonEliminar(listadoVisitasSolicitadas, index)
              ],
            ),
          ],
        ),
      ),
    );
  }

  _crearBotonEliminar(List<dynamic> listadoVisitasSolicitadas, int index) {
    return RaisedButton(
      child: Icon(Icons.delete),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 1.0,
      color: Colors.redAccent,
      textColor: Colors.white,
      onPressed: listadoVisitasSolicitadas[index][index]['estado'].toString() ==
                  'PENDIENTE' ||
              listadoVisitasSolicitadas[index][index]['estado'].toString() ==
                  'RECHAZADA'
          ? () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Eliminar Visita'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              '¿Desea eliminar la siguiente solicitud de visita?')
                        ],
                      ),
                      actions: [
                        FlatButton(
                          child: Text('Cancelar'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text('Aceptar'),
                          onPressed: () {
                            eliminarVisitaEstado(
                                context, listadoVisitasSolicitadas, index);
                          },
                        ),
                      ],
                    );
                  });
            }
          : null,
    );
  }

  eliminarVisitaEstado(BuildContext context,
      List<dynamic> listadoVisitasSolicitadas, int index) async {
    final authData = {'estado': 'ELIMINADA'};

    final url =
        '$URL/visita/eliminarvisita/${listadoVisitasSolicitadas[index][index]['_id']}?token=${preferenciaToken.token}';

    final resp = await http.put(url,
        headers: {"Content-type": "application/json"},
        body: json.encode(authData));

    print(resp.body);
    final decodeData = json.decode(resp.body);
    Navigator.pushReplacementNamed(context, 'visitas');
    return decodeData;
  }

  _fecha(BuildContext context, String fecha) {
    String fechaObtenida = fecha;
    DateTime dt = DateTime.parse(fechaObtenida);

    String fechaFormateada = DateFormat('dd-MM-yyyy').format(dt);
    return Text(
      fechaFormateada,
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
    );
  }

  obtenerVisitas() async {
    final response = await http.get(
      '$URL/visita/arrendatario/visitasolicitadamovil?token=${preferenciaToken.token}',
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      _total = json.decode(response.body)['total'];
      if(mounted)
      setState(() {
        if (listadoVisitasSolicitadas.length < _total) {
          print('Agregando: ${listadoVisitasSolicitadas.length}');
          listadoVisitasSolicitadas.add(json.decode(response.body)['visitas']);
          //print('GEN: ${listadoVisitasSolicitadas.length}');
        } else {
          return;
        }
      });
    } else {
      throw Exception('Error al cargar visitas');
    }
    print('ja: ${listadoVisitasSolicitadas.length}');
  }

  obtener6() {
    for (var i = 0; i < 6; i++) {
      if (listadoVisitasSolicitadas.length <= _total) {
        print('listado: ${listadoVisitasSolicitadas.length}');
        print('total: $_total');
        obtenerVisitas();
      } else {
        return;
      }
    }
  }

  Future<Null> obtenerPrimerosRegistros() async{
    final duration = new Duration( seconds: 2);
    new Timer(duration, (){
      listadoVisitasSolicitadas.clear();
      _total=0;
      obtener6();
    });

    return Future.delayed(duration);
  }
}
