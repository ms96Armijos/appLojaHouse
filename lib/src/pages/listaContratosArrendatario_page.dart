import 'dart:async';
import 'dart:convert';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:applojahouse/src/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaContratosArrPage extends StatefulWidget {
  @override
  _ListaContratosArrPageState createState() => _ListaContratosArrPageState();
}

class _ListaContratosArrPageState extends State<ListaContratosArrPage> {
  final estiloTitulo = TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  ScrollController _scrollController;
  final preferenciaToken = new PreferenciasUsuario();

  List<dynamic> listadoDeContratos = [];
  int _total = 0;

  final usuarioProvider = UsuarioProvider();
    bool estaLogueado = false;


  Future<void> verificarToken() async{
    bool verify = await usuarioProvider.verificarToken();
    if(verify){
      estaLogueado = false;
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
    }else{
      estaLogueado = true;
      print('Token válido ${preferenciaToken.token}');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarToken();
  
  _scrollController  = new ScrollController();
    //agregar6(_ultimoDato);
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
          title: Text('Contratos del arrendatario'),
        ),
        //drawer: MenuWidget(),
        body: (listadoDeContratos.length > 0)
            ? RefreshIndicator(
              onRefresh: obtenerPrimerosRegistros,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: listadoDeContratos.length,
                    itemBuilder: (context, index) {
                      return _crearItemContrato(
                          context, listadoDeContratos, index);
                      //print(inn.servicio);
                    }),
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
                          Text("No tienes Contratos generados",
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
        //Navigator.pushReplacementNamed(context, 'home');
      },
      elevation: 4.0,
      splashColor: Colors.blueGrey,
      child: Text(
        'Regresar'.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }

  _crearItemContrato(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearTitulo(context, listadoDeContratos, index),
            //DOWNLOAD
          ],
        ),
      ),
    );
  }

  _crearTitulo(
      BuildContext context, List<dynamic> listadoDeContratos, int index) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  //Navigator.pop(context);
                  Navigator.pushNamed(context, 'acuerdo',
                    arguments: {listadoDeContratos[index][index]});
                },
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
                      listadoDeContratos[index][index]['nombrecontrato']
                          .toString(),
                      style: estiloTitulo,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Meses de alquiler',
                      style: estiloSubTitulo,
                    ),
                    Text(listadoDeContratos[index][index]['tiempocontrato']
                        .toString()),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                //Navigator.pop(context);
                Navigator.pushNamed(context, 'acuerdo',
                  arguments: {listadoDeContratos[index][index]});
              },
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
                      listadoDeContratos[index][index]['acuerdo'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (listadoDeContratos[index][index]['acuerdo']
                                      .toString() !=
                                  'ACEPTADO')
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

  fetchData() async {
    final response = await http.get(
      '$URL/contrato/arrendatario/obtenercontratosmovil?token=${preferenciaToken.token}',
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      _total = json.decode(response.body)['total'];
      if(mounted)
      setState(() {
        if (listadoDeContratos.length < _total) {
          listadoDeContratos.add(json.decode(response.body)['contratos']);
        } else {
          return;
        }
      });
    } else {
      return false;
    }
    //print(listadoDeContratos.length);
  }

  obtener6() {
    for (var i = 0; i < 6; i++) {
      if (listadoDeContratos.length <= _total) {
        print('listado: ${listadoDeContratos.length}');
        print('total: $_total');
        fetchData();
      } else {
        return;
      }
    }
  }

  Future<Null> obtenerPrimerosRegistros() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {
      listadoDeContratos.clear();
      _total = 0;
      obtener6();
    });

    return Future.delayed(duration);
  }
}
