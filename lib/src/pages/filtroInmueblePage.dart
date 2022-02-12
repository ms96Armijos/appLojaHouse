import 'dart:convert';
import 'package:applojahouse/src/pages/home_page.dart';
import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/providers/inmueble_provider.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;

class FiltroInmueblePage extends StatefulWidget {
  @override
  _FiltroInmueblePageState createState() => _FiltroInmueblePageState();
}

class _FiltroInmueblePageState extends State<FiltroInmueblePage> {
  String _opcionSeleccionada0 = 'Casa';
  String _opcionSeleccionada1 = 'Gran Colombia';
  String _opcionSeleccionada2 = '>200';

  final estiloTitulo = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  final _inmuebleProvider = new InmuebleProvider();
  Inmueble inn;
  var count;

      int _currentTab = 1;
          bool estaLogueado = false;
        final usuarioProvider = UsuarioProvider();
       final preferencias = new PreferenciasUsuario();

  List<Inmueble> data = [];

  List<String> _direccion = ["Gran Colombia", "San José", "San Vicente", "Capulí Loma", "El pedestal",
"Clodoveo", "Turunuma", "Belén", "Plateado", "Borja", "Obrapía", "Menfis", "Chotacruz",
"Bolonia", "Eucaliptos", "Tierras Coloradas", "Céli Román", "Alborada", "Miraflores", "Barrio Central", "Santo Domingo", "18 de Noviembre", "Juán de Salinas",
"24 de Mayo", "Orillas del Zamora", "Perpetuo Socorro", "Ramón Pinto", "San Juan de El Valle", "Las Palmas", "San Cayetano", "Santiago Fernández",
"Jipiro", "La inmaculada", "La inmaculada", "Chingulanchi", "La Paz", "Amable María", "Máximo Agustín Rodríguez", "Pucará", "Pradera",
"Yaguarcuna", "Los Geranios", "El Rosal", "Capulí", "Zamora Huayco", "La Argelia", "San Isidro", "Héroes del Cenepa", "Sol de los Andes",
"Santa Teresita", "Daniel Álvarez", "Tebaida", "Isidro Ayora", "San Pedro", "Colinas Lojanas",
"Ciudad Alegría", "Juan José Castillo", "Pitas", "La Banda", "Motupe", "Sauces Norte", "Zalapa", "Carigán"];
  List<String> _tipoInmueble = ["Casa", "Departamento", "Cuarto", "Minidepartamento"];
  List<String> _precio = ['<50', '50-100','100-150', '150-200', '>200'];

  Future<InmuebleModel> buscarInmueble(
      String tipo, String ubicacion, String precio) async {
        if(precio == '>200'){
          precio = '200-0';
        }
    final url = URL+'/busqueda/coleccion/inmuebles/' +
        tipo +
        '/' +
        ubicacion +
        '/' +
        precio;

    final resp = await http.get(
      url,
      headers: {"Content-type": "application/json"},
    );

    if (resp.statusCode == 200) {
      final body = inmuebleModelFromJson(resp.body);
      return body;
    } else {
      return null;
    }
  }


    /*Future<void> verificarToken() async{
    bool verify = await usuarioProvider.verificarToken();
    if(verify){
      estaLogueado = false;
     Navigator.pop(context);
      Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
     //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
    }else{
      estaLogueado = true;
      print('Token válido ${preferencias.token}');
    }
  }*/

  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      verificarToken();
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inmuebles'),
      ),
     // drawer: preferencias.token.toString().length>0? MenuWidget(): null,
      /*bottomNavigationBar: preferencias.token.toString().length>0? BottomNavigationBar(
        currentIndex:  _currentTab,
        onTap: (int value) {
          if(mounted)
          setState(() {
            _currentTab = value; 

            if(_currentTab == 0 ){
              Navigator.pushReplacementNamed(context, 'home');
            }

           if(_currentTab == 1 ){
              Navigator.pushNamed(context, 'mensaje');
            }
  
            if(_currentTab == 2){
              Navigator.pushNamed(context, 'perfil', arguments: preferencias.idUsuario);
            }

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.filter_alt,
              size: 30.0,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 30.0,
            ),
            title: Text('Mensaje'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              size: 30.0,
            ),
            title: Text('Perfil'),
          ),
        ],
      ):
      BottomNavigationBar(
        currentIndex:  _currentTab,
        onTap: (int value) {
          if(mounted)
          setState(() {
            _currentTab = value; 

            if(_currentTab == 0 ){
              Navigator.pushReplacementNamed(context, 'home');
            }

           if(_currentTab == 1 ){
              Navigator.pushNamed(context, 'mensaje');
            }
  
            if(_currentTab == 2){
              Navigator.pushNamed(context, 'login');
            }

          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30.0,
            ),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              size: 30.0,
            ),
            title: Text('Mensaje'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.login,
              size: 30.0,
            ),
            title: Text('Login'),
          ),
        ],
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            ListTile(
            leading: Icon(Icons.arrow_back_outlined),
            title: Text('Regresar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
            },
          ),
            _crearDropdown0(),
            SizedBox(
              height: 20.0,
            ),
            _crearDropdown1(),
            SizedBox(
              height: 20.0,
            ),
            _crearDropdown2(),
            SizedBox(
              height: 20.0,
            ),
            Divider(),
            /*_crearBotonCancelar(),
            count != 0 && inn != null
                ? datos(data)
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100.0),
                    child: Text(
                      'No hay información',
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent),
                    ),
                  ),*/

            Expanded(
              child: FutureBuilder(
                future: buscarInmueble(_opcionSeleccionada0,
                    _opcionSeleccionada1, _opcionSeleccionada2),
                builder: (BuildContext context,
                    AsyncSnapshot<InmuebleModel> snapshot) {
                  if (snapshot.hasData) {
                    final inmuebles = snapshot.data;
                    return ListView.builder(
                      itemCount: inmuebles.inmuebles.length,
                      itemBuilder: (context, i) {
                        {
                          Inmueble inmuebleObtenido = inmuebles.inmuebles[i];
                          return SingleChildScrollView(
                            child: Container(
                              child: Column(
                                children: [
                                  _crearSliderDeImagenes(
                                      context, inmuebleObtenido),
                                  // _crearSliderDeImagenes(context, inmuebleObtenido),
                                  ListTile(
                                    /*leading: CircleAvatar(
                            backgroundImage: NetworkImage(inmuebleObtenido.imagen[0]),
                            radius: 30.0,
                          ),*/
                                    title: Text(inmuebleObtenido.nombre,
                                        style: estiloTitulo),
                                    subtitle: Text(inmuebleObtenido.estado,
                                        style: estiloSubTitulo),
                                    trailing: Text(
                                      '\$' +
                                          inmuebleObtenido.precioalquiler
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(context, 'visita',
                                          arguments: inmuebleObtenido);
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                          //print(inn.servicio);
                        }
                      },
                    );
                  } else {
                    return Center(
                child: Container(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "No hay resultados",
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          FadeInImage(
                            placeholder: AssetImage('assets/img/empty.png'),
                            image: AssetImage('assets/img/empty.png'),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text("Elige otros criterios de búsqueda",
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent)),
                          SizedBox(
                            height: 30.0,
                          ),
                          SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    )),
              );
                  }
                },
              ),
            )
            //LISTADO DE INMUEBLES FILTRADOS
            /* Expanded(
                child: FutureBuilder(
                  future: verificarToken(),
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.hasError) {
                      print("eroro: " + snapshot.hasError.toString());
                    }
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data['inmuebles'].length,
                          itemBuilder: (context, index) {
                            return Text(
                                '${snapshot.data["inmuebles"][index]["nombre"]}');
                            //print(inn.servicio);
                          });
                    } else {
                      print("no hay datos");
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              )*/

            /* Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final dataInmueble = data[index];
                  return ListTile(
                    title: Text(dataInmueble.nombre),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            )*/
            ,/*ListTile(
            leading: Icon(Icons.arrow_back_outlined),
            title: Text('Regresar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45)),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
            },
          ),*/],
        ),
      ),
    );
  }



  Widget _crearDropdown0() {
    return Row(
      children: [
        Icon(Icons.home),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _opcionSeleccionada0,
              isDense: true,
              items: getOpcionesDropdown(),
              onChanged: (opt) {
                setState(() {
                  _opcionSeleccionada0 = opt;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _crearDropdown1() {
    return Row(
      children: [
        Icon(Icons.directions),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _opcionSeleccionada1,
              items: getOpcionesDropdown1(),
              onChanged: (opt) {
                setState(() {
                  _opcionSeleccionada1 = opt;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _crearDropdown2() {
    return Row(
      children: [
        Icon(Icons.attach_money_rounded),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _opcionSeleccionada2,
              items: getOpcionesDropdown2(),
              onChanged: (opt) {
                setState(() {
                  _opcionSeleccionada2 = opt;
                });
              },
            ),
          ),
        )
      ],
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown2() {
    List<DropdownMenuItem<String>> lista = new List();
    _precio.forEach((precio) {
      lista.add(DropdownMenuItem(
        child: Text(precio),
        value: precio,
      ));
    });
    return lista;
  }

    List<DropdownMenuItem<String>> getOpcionesDropdown1() {
    List<DropdownMenuItem<String>> lista = new List();
    _direccion.forEach((direccion) {
      lista.add(DropdownMenuItem(
        child: Text(direccion),
        value: direccion,
      ));
    });
    return lista;
  }

    List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();
    _tipoInmueble.forEach((tipo) {
      lista.add(DropdownMenuItem(
        child: Text(tipo),
        value: tipo,
      ));
    });
    return lista;
  }

}


_crearSliderDeImagenes(BuildContext context, Inmueble inmuebleModel) {
  return Container(
    padding: EdgeInsets.only(top: 10.0),
    width: double.infinity,
    height: 250.0,
    child: inmuebleModel.imagen.length > 0
        ? Swiper(
            itemBuilder: (BuildContext context, int index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/caracol.gif'),
                  image: NetworkImage(inmuebleModel.imagen[index].url.toString()),
                  height: 300.0,
                  width: 300.0,
                  fit: BoxFit.cover,
                ),
              );
            },
            autoplay: true,
            itemCount: inmuebleModel.imagen.length,
            pagination: new SwiperPagination(),
          )
        : FadeInImage(
            placeholder: AssetImage('assets/img/no-image.png'),
            image: AssetImage('assets/img/no-image.png'),
            height: 300.0,
            width: 300.0,
            fit: BoxFit.cover,
          ),
  );
}
