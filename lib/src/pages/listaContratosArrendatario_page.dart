import 'dart:async';
import 'dart:io';

import 'package:applojahouse/src/bloc/contrato_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:applojahouse/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListaContratosPage extends StatefulWidget {
  @override
  _ListaContratosPageState createState() => _ListaContratosPageState();
}

class _ListaContratosPageState extends State<ListaContratosPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  ContratoBloc contratoBloc;

  ScrollController _scrollController = new ScrollController();

  List<int> _listaNumeros = new List();
  int _ultimoDato;
  int _total = 0;
  bool estaCargando=false;

 
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //agregar6(_ultimoDato);
    _ultimoDato = 0;

    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
          //agregar6(6);
          if(_ultimoDato>=0 && _ultimoDato <= _total){
            obtenerMasData();
          print('Maximo dato: $_ultimoDato');
          }
      }

      if(_scrollController.position.pixels == _scrollController.position.minScrollExtent){
          if(_ultimoDato!=0){
            obtenerMenosData();
          print('Minimo dato: $_ultimoDato');
          }
      }

    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    contratoBloc.dispose();
    _ultimoDato=0;
    print('Dispose...');
  }

  @override
  Widget build(BuildContext context) {
    contratoBloc = Provider.contratoBloc(context);
    contratoBloc.obtenerContratos(_ultimoDato);

   

    return Scaffold(
      appBar: AppBar(
        title: Text('Contratos del arrendatario'),
        actions: [
          FlatButton(
            child: CircleAvatar(
              child: Icon(Icons.refresh),
              backgroundColor: Colors.white54,
            ),
            onPressed: ()=>obtenerMenosData(),
          )
        ],
      ),
      drawer: MenuWidget(),
      body: Stack(children: [
       
        _crearListadoInmuebles(contratoBloc),
        crearLoading()
      ],),
    );
  }

  _crearListadoInmuebles(ContratoBloc contratoBloc) {
    return StreamBuilder(
      stream: contratoBloc.contratosStream,
      builder: (BuildContext context, AsyncSnapshot<ContratoModel> snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
              onRefresh: obtenerDataPrincipal,
              
              child: ListView.builder(
              controller: _scrollController,
                itemCount: snapshot.data.contratos.length,
                itemBuilder: (context, index) {
                  _total = snapshot.data.total;
                  Contrato contrato = snapshot.data.contratos[index];
                  return Column(
                    children: [
                      _crearItemContrato(context, contrato),
                    ],
                  );
                  //print(inn.servicio);
                }),
          );
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

  agregar6(int valor){
    /*_ultimoDato = _ultimoDato+valor;

     if(_ultimoDato >= _total){
       print('No se puede avanzar');
     }
      if (_ultimoDato < 0) {
       print('No se puede retroceder');
      }
    _ultimoDato+=valor;
    contratoBloc.obtenerContratos(_ultimoDato);
    print('La suma es $_ultimoDato');*/

    for (var i = 0; i < valor; i++) {
      if(_ultimoDato <= _total){
        _ultimoDato++;
        print("Agrega mas: $_ultimoDato");
      //_listaNumeros.add(_ultimoDato);
      }else{
        print('No se puede $_total');
      }
    }

    setState(() {
      
    });
  }

  quitar6(int valor){
    
    for (var i = 0; i < valor; i++) {
      if(_ultimoDato <= _total){
        _ultimoDato--;
        print("Quita mas: $_ultimoDato");
      //_listaNumeros.add(_ultimoDato);
      }else{
        print('No se puede $_total');
      }
    }

    setState(() {
      
    });
  }

  Future obtenerMasData() async{

    estaCargando = true;
    setState(() {
      
    });

    final duracion = new Duration(seconds: 2);
    new Timer(duracion, respuestaMasData);
  }

  void respuestaMasData(){
    estaCargando = false;
    agregar6(6);
    if(_ultimoDato == _total){
      _ultimoDato=0;
    }
  }

    Future obtenerMenosData() async{

    estaCargando = true;
    setState(() {
      
    });

    final duracion = new Duration(seconds: 2);
    new Timer(duracion, respuestaMenosData);
  }

  void respuestaMenosData(){
    estaCargando = false;
    quitar6(6);
  }

    crearLoading(){
    if(estaCargando){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
          SizedBox(height: 15.0,)
        ],
      );
    }else{
      return Container();
    }
  }


 Future<Null> obtenerDataPrincipal() async{
    final duracion = new Duration(seconds: 2);
     new Timer(duracion, (){
      _ultimoDato=0;
    });
  return Future.delayed(duracion);
  }

}
