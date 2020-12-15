import 'dart:io';

import 'package:applojahouse/src/bloc/contrato_bloc.dart';
import 'package:applojahouse/src/bloc/perfil_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:applojahouse/src/pages/visualizarContrato_page.dart';
import 'package:applojahouse/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ListaContratosPage extends StatefulWidget {
  @override
  _ListaContratosPageState createState() => _ListaContratosPageState();
}

class _ListaContratosPageState extends State<ListaContratosPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);


 

  @override
  Widget build(BuildContext context) {
    final contratoBloc = Provider.contratoBloc(context);
    contratoBloc.obtenerContratos();

   

    return Scaffold(
      appBar: AppBar(
        title: Text('Contratos del arrendatario'),
      ),
      drawer: MenuWidget(),
      body: _crearListadoInmuebles(contratoBloc),
    );
  }

  _crearListadoInmuebles(ContratoBloc contratoBloc) {
    return StreamBuilder(
      stream: contratoBloc.contratosStream,
      builder: (BuildContext context, AsyncSnapshot<ContratoModel> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.contratos.length,
              itemBuilder: (context, index) {
                Contrato contrato = snapshot.data.contratos[index];
                return Column(
                  children: [
                    _crearItemContrato(context, contrato),
                  ],
                );
                //print(inn.servicio);
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }


  _crearItemContrato(BuildContext context, Contrato contrato) {
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearTitulo(context, contrato),
           
            //DOWNLOAD
          ],
        ),
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

  _crearTitulo(BuildContext context, Contrato contrato) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => Navigator.pushNamed(context, 'acuerdo',
                    arguments: contrato),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      'nombre del contrato',
                      style: estiloSubTitulo,
                    ),
                    Text(
                      contrato.nombrecontrato.toString(),
                      style: estiloTitulo,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Meses de alquiler',
                      style: estiloSubTitulo,
                    ),
                    Text(contrato.tiempocontrato.toString()),
                    /*Text(
                      'Inicio del contrato',
                      style: estiloSubTitulo,
                    ),
                    _fecha(context, contrato.fechainicio),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Fin del contrato',
                      style: estiloSubTitulo,
                    ),
                    _fecha(context, contrato.fechafin),*/
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, 'acuerdo', arguments: contrato),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.arrow_forward,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'El contrato\nestá',
                      style: estiloSubTitulo,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      contrato.acuerdo,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (contrato.acuerdo != 'ACEPTADO')
                              ? Colors.redAccent
                              : Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
