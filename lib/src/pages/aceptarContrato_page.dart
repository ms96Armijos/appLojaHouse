import 'dart:io';

import 'package:applojahouse/src/bloc/contrato_bloc.dart';
import 'package:applojahouse/src/bloc/perfil_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:applojahouse/src/pages/visualizarContrato_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AceptarContratoPage extends StatefulWidget {
  @override
  _AceptarContratoPagePageState createState() =>
      _AceptarContratoPagePageState();
}

class _AceptarContratoPagePageState extends State<AceptarContratoPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  Contrato contratoModel = new Contrato();

  bool guardando = false;

  ContratoBloc contratoBloc;

  bool _blouearCheck = false;

  PerfilBloc usuarioBloc;

  Map<String, dynamic> dataUsuarioArrendador;

  Map<String, dynamic> dataUsuarioArrendatario;

  Directory directorioDelDocumento;
  String pathDelDocumento;

  final pdf = pw.Document();

  String cambiarEstado;


  /**PARA DESBLOQUEAR EL BOTÓN LEER CONTRATO*/
    bool existeArrendador = false;
    bool existeArrendatario = false;
  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    contratoBloc?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contratoObtenido = ModalRoute.of(context).settings.arguments;
    print(contratoObtenido);
    contratoBloc = Provider.contratoBloc(context);

    usuarioBloc = Provider.perfilBloc(context);


    for (var item in contratoObtenido) {
      print(item['tiempocontrato']);
      contratoModel = Contrato(
        acuerdo: item['acuerdo'],
        id: item['_id'],
        nombrecontrato: item["nombrecontrato"],
        fechainicio: DateTime.parse(item["fechainicio"]),
        fechafin: DateTime.parse(item["fechafin"]),
        tiempocontrato: item["tiempocontrato"],
        monto: item["monto"],
        usuarioarrendador: Usuarioarrenda.fromJson(item["usuarioarrendador"]),
        usuarioarrendatario: Usuarioarrenda.fromJson(item["usuarioarrendatario"]),
        inmueble: InmuebleContrato.fromJson(item["inmueble"]),
        );
    }

    /*if (contratoObtenido != null) {
      contratoModel = contratoObtenido;
      print('bien');
    } else {
      print('nulo');
    }*/

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contrato de arrendamiento',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _crearCardInformacionInmueble(context),
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


  _escribirEnPdf(Contrato contrato) {
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(15),
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text('Contrato de arrendamiento')),
            pw.Paragraph(
                text:
                    'Por medio del presente dejamos manifiesta constancia, entre nosotros: Sr(a). ${dataUsuarioArrendador['usuario']['nombre'] + dataUsuarioArrendador['usuario']['apellido']} con cédula de identidad ${dataUsuarioArrendador['usuario']['cedula']}, al que más adelante se  lo identificará con el nombre de ARRENDADOR. Y al Sr(a). ${dataUsuarioArrendatario['usuario']['nombre'] + dataUsuarioArrendatario['usuario']['apellido']}, con cédula de identidad ${dataUsuarioArrendatario['usuario']['cedula']}, al que más adelante se le identificará con el nombre de ARRENDATARIO. Entre ambos convenimos libremente en celebrar el presente contrato de arrendamiento, bajo el tenor de las siguientes cláusulas:'),
            pw.Paragraph(
                text:
                    'PRIMERA.- El arrendador da en arrendamiento al arrendatario un ${contrato.inmueble.tipo} ubicado en ${contrato.inmueble.direccion} y que consta de los servicios de: ${contrato.inmueble.servicio.toString().replaceAll('[', '').replaceAll(']', '')}'),
            pw.Paragraph(
                text:
                    'SEGUNDA.- El arrendatario se compromete a mantener en perfectas condiciones el local arrendado y lo destinará única y exclusivamente para el uso de MOTIVO DE USO sin poder darle otro uso, salvo convenio posterior con el arrendador/a.'),
            pw.Paragraph(
                text:
                    'TERCERA.- El canon de arrendamiento será de \$${contrato.monto.toString()} dólares, valor que será cancelado de forma mensual, pagaderos y por mesadas anticipadas entre los tres primeros días del  inicio de cada mes, el mismo que dará inicio desde ${contrato.fechainicio.toString()} hasta el ${contrato.fechafin.toString()}}.En caso de ser renovado el contrato, y de así expresarlo el arrendatario se lo hará previo un reajuste del canon suscrito anteriormente. La renovación comprenderá el período de un año.En este tenor las partes renuncian expresamente el acogerse a un canon distinto del acordado tanto para este contrato, cuanto para su futura renovación. Así el arrendatario renuncia a cualquier reclamo o acción legal, que tenga como fuente este antecedente.'),
            pw.Paragraph(
                text:
                    'CUARTA.- El plazo del presente contrato es de ${contrato.tiempocontrato.toString()} meses, el mismo que termina el ${contrato.fechafin.toString()}, pudiendo ser renovado el mismo de común acuerdo entre las partes en convenio.'),
            pw.Paragraph(
                text:
                    'QUINTA.- Para el término o fin del contrato, las partes deberán comunicar con noventa días de anticipación, conforme lo determina la ley, y en caso de que no se cancelen dos pensiones locativas consecutivas será motivo válido para que el arrendador/a pueda dar por terminado el presente contrato.'),
            pw.Paragraph(
                text:
                    'SEXTA.- El arrendatario declara que recibe en perfectas condiciones el local arrendado para el goce de su uso estipulado en la cláusula segunda y comprometiéndose a mantenerlo en buen estado; y, a realizar los arreglos locativos pertinentes que el caso lo amerite si existiere leve deterioro. Por otro lado, toda mejora que se desee<br> hacer  en el local arrendado se lo realizará previo el consentimiento de la arrendadora.'),
            pw.Paragraph(
                text:
                    'SÉPTIMA.- El pago de los servicios básicos será cancelado por cuenta exclusiva del arrendatario.'),
            pw.Paragraph(
                text:
                    'OCTAVA.- En caso de presentarse alguna controversia de orden legal, las partes renuncian expresamente domicilio y fuero, y se someten a los jueces competentes de la Ciudad de.....,provincia de..., y, al trámite Verbal Sumario que de darse el caso lo amerite.'),
            pw.Paragraph(
                text:
                    'NOVENA.- Y para dejar constancia entre las  partes y convenidas en mutuo  acuerdo  para su consecuencia final de este acto de contrato de todo lo expuesto en su contenido. Firman conjuntamente en la Ciudad de<br> ..., provincia de ..... Ecuador, el  .... del 2020'),
            pw.Paragraph(text: 'El acuerdo está ${contrato.acuerdo}'),
          ];
        }));
  }

  Future _guardarPDF(Contrato contrato) async {
    directorioDelDocumento = await getApplicationDocumentsDirectory();
    pathDelDocumento = directorioDelDocumento.path;

    File file = File('$pathDelDocumento/${contrato.nombrecontrato}.pdf');
    file.writeAsBytesSync(await pdf.save());
  }

  _usuarioObtenidoArrendador(Contrato contrato) {
    return FutureBuilder(
        future:
            usuarioBloc.cargarUsuarioEspecifico(contrato.usuarioarrendador.id),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          //print(visitaModel.inmueble.usuario);
          if (snapshot.hasData) {
            dataUsuarioArrendador = snapshot.data;
            existeArrendador = true;
            return Container();
          } else {
            existeArrendador = false;
            return CircularProgressIndicator();
          }
        });
  }

  _usuarioObtenidoArrendatario(Contrato contrato) {
    return FutureBuilder(
        future: usuarioBloc
            .cargarUsuarioEspecifico(contrato.usuarioarrendatario.id),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          //print(visitaModel.inmueble.usuario);
          if (snapshot.hasData) {
            existeArrendatario = true;
            dataUsuarioArrendatario = snapshot.data;
            return Container();
          } else {
            existeArrendatario = false;
            return CircularProgressIndicator();
          }
        });
  }

  _crearCardInformacionInmueble(BuildContext context) {
    return Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            Container(
                child: Column(
              children: [
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  'Acepta tu contrato de arrendamiento',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold),
                ),
                _crearTitulo(context),
                SizedBox(
                  height: 5.0,
                ),
              ],
            )),
            SizedBox(
              height: 20.0,
            ),
          ],
        ));
  }

  _crearTitulo(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Contrato:',
                    style: estiloSubTitulo,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    contratoModel.nombrecontrato.toString(),
                    style: estiloTitulo,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Inicio del contrato:',
                            style: estiloSubTitulo,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          _fecha(context, contratoModel.fechainicio),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Fin del contrato:', style: estiloSubTitulo),
                          SizedBox(
                            height: 5.0,
                          ),
                          _fecha(context, contratoModel.fechafin),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Meses de alquiler:',
                            style: estiloSubTitulo,
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            contratoModel.tiempocontrato.toString(),
                            style: TextStyle(
                                fontSize: 13.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('Pago mensual:', style: estiloSubTitulo),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.money_off_csred_outlined,
                                color: Colors.red,
                                size: 20.0,
                              ),
                              Text(
                                contratoModel.monto.toString(),
                                style: TextStyle(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Divider(),
                  
                  _usuarioObtenidoArrendador(contratoModel),
                  _usuarioObtenidoArrendatario(contratoModel),
                  RaisedButton(
                    child: Container(
                      child: Text('Leer contrato'),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    elevation: 5.0,
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    onPressed: () async {

                      print('Hola: ${contratoModel.acuerdo}');
                      _escribirEnPdf(contratoModel);
                      await _guardarPDF(contratoModel);
                      directorioDelDocumento =
                          await getApplicationDocumentsDirectory();
                      String pathDelDocumento = directorioDelDocumento.path;

                      String fullPath =
                          '$pathDelDocumento/${contratoModel.nombrecontrato}.pdf';
                      //Navigator.pop(context);
                      Navigator.push(
                          context,
                        new MaterialPageRoute(
                        builder: (context) => VisualizarContratoPDFPage(path: fullPath)));
                    },
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _crearCheckBox(),
                      _crearBotonAceptarContrato(context, contratoBloc),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [_crearAvisoDelAcuerdo()],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _crearBotonAceptarContrato(BuildContext context, ContratoBloc bloc) {
    return RaisedButton(
        color: Colors.blueAccent,
        onPressed: (_blouearCheck != false)
            ? () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Aceptar Contrato'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      Text('Si ha leido el contrato y está de acuerdo, por favor seleccione Aceptar')
                    ],
                    ),
                    actions: [
                      FlatButton(
                        child: Text('Cancelar'),
                        onPressed: ()=> Navigator.of(context).pop(),
                        ),
                      FlatButton(
                        child: Text('Aceptar'),
                        onPressed: (){_aceptarAcuerdo(context, bloc);},
                        ),
                    ],
                  );
                }
              );

                
              }
            : null,
        elevation: 4.0,
        splashColor: Colors.lightBlueAccent,
        child: Row(
          children: [
            Text(
              'Aceptar contrato',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ));
  }

  _aceptarAcuerdo(BuildContext context, ContratoBloc bloc) async {
    String aceptarAcuerdo = '';
    if (_blouearCheck == true) {
      aceptarAcuerdo = 'ACEPTADO';
      cambiarEstado="VIGENTE";
      print(aceptarAcuerdo);
      Map respuesta =
          await bloc.aceptarContrato(contratoModel.id, aceptarAcuerdo, cambiarEstado);
      Navigator.pushReplacementNamed(context, 'listacontratos');
      print(respuesta);
    }
    if (aceptarAcuerdo == '') {
      print('no se puede realizar esta acción');
    }
  }

  _crearCheckBox() {
    return Checkbox(
        value: _blouearCheck,
        onChanged: (contratoModel.acuerdo != 'ACEPTADO')
            ? (value) {
              if(mounted)
                setState(() {
                  _blouearCheck = value;
                });
              }
            : null);
  }

  _crearAvisoDelAcuerdo() {
    return Container(
      child: Row(
        children: [
          Text('El contrato está: '),
          Text(
            contratoModel.acuerdo,
            style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  _fecha(BuildContext context, DateTime fecha) {
    String fechaFormateada = DateFormat('dd-MM-yyyy').format(fecha);
    return Text(
      fechaFormateada,
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
    );
  }
}
