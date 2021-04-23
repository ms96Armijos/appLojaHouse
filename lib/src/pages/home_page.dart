import 'package:applojahouse/src/bloc/inmueble_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/pages/login_page.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:applojahouse/src/widgets/menu_widget.dart';
import 'package:applojahouse/src/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
  int currentTab = 0;

class _HomePageState extends State<HomePage> {
  final estiloTitulo = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);

  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);
  final usuarioProvider = UsuarioProvider();
  final preferencias = new PreferenciasUsuario();

    int _currentTab = 1;


  Future<void> verificarToken() async{
    bool verify = await usuarioProvider.verificarToken();
    if(verify){
     Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
    }else{
      print('Token válido');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificarToken();
  }

  @override
  Widget build(BuildContext context) {
    final inmuebleBloc = Provider.inmuebleBloc(context);
    inmuebleBloc.cargarInmuebles();

    return Scaffold(
      appBar: AppBar(
        title: Text('LojaHouse'),
        actions: [
          IconButton(
            icon: Icon(Icons.search), onPressed: (){
              showSearch(
                context: context, 
                delegate: DataSearch()
                );
            }
            ),
        ],
      ),
      drawer: MenuWidget(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (int value) {
          if(mounted)
          setState(() {
            _currentTab = value; 

            if(_currentTab == 0 ){
              Navigator.pushNamed(context, 'filtroinmueble');
            }

           if(_currentTab == 1 ){
              Navigator.pushNamed(context, 'mensaje');
            }

            if(_currentTab == 2 ){
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
            title: Text('Filtrar'),
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
      ),
      body: 
          _crearListadoInmuebles(inmuebleBloc)
      //floatingActionButton: _crearBoton(context),
    );
  }

  _crearListadoInmuebles(InmuebleBloc inmuebleBloc) {
    return StreamBuilder(
      stream: inmuebleBloc.inmueblesStream,
      builder: (BuildContext context, AsyncSnapshot<InmuebleModel> snapshot) {
        if (snapshot.hasData) {
          final inmuebles = snapshot.data.inmuebles;
          return ListView.builder(
            itemCount: inmuebles.length,
            itemBuilder: (context, i) {
              {
                Inmueble inmuebleObtenido = snapshot.data.inmuebles[i];

                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        //_crearSliderDeImagenes(context, inmuebleObtenido),
                        _crearItemInmueble(context, inmuebleObtenido),
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
                            placeholder: AssetImage('assets/img/sorry.jpg'),
                            image: AssetImage('assets/img/sorry.jpg'),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text("No tienes visitas solicitadas",
                              style: TextStyle(
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent)),
                          SizedBox(
                            height: 30.0,
                          ),
                          //_crearBotonCancelar(),
                          SizedBox(
                            height: 30.0,
                          ),
                        ],
                      ),
                    )),
              );
        }
      },
    );
  }

  

  _crearItemInmueble(BuildContext context, Inmueble inmueble) {
    /*return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion){
        //Eliminar un inmueble asi se llama desde el provider
        //inmueblesProvider.borrarInmueble(inmueble.id);
      },*/
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearSliderDeImagenes(context, inmueble),
            _crearTitulo(context, inmueble),
            SizedBox(
              height: 25.0,
            )
          ],
        ),
      ),
    );
  }

  _crearTitulo(BuildContext context, Inmueble inmueble) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, 'visita', arguments: inmueble),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      inmueble.nombre.toString(),
                      style: estiloTitulo,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Dirección',
                      style: estiloSubTitulo,
                    ),
                    Text(
                      inmueble.direccion.toString(),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text('Servicios incluidos:', style: estiloSubTitulo),
                    Text(
                      inmueble.servicio
                          .toString()
                          .replaceAll('[', '')
                          .replaceAll(']', ''),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, 'visita', arguments: inmueble),
              child: Column(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 40.0,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    inmueble.estado.toString(),
                    style:
                        TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.money_off_csred_outlined,
                        color: Colors.red,
                        size: 20.0,
                      ),
                      Text(
                        inmueble.precioalquiler.toString(),
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _crearSliderDeImagenes(BuildContext context, Inmueble inmuebleModel) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      width: double.infinity,
      height: 250.0,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/img/jar-loading.gif'),
              image: NetworkImage(inmuebleModel.imagen[index]),
              height: 300.0,
              width: 300.0,
              fit: BoxFit.cover,
            ),
          );
        },
        autoplay: true,
        itemCount: inmuebleModel.imagen.length,
        pagination: new SwiperPagination(),
      ),
    );
  }
}

