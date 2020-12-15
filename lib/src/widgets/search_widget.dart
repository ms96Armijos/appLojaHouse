import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/providers/inmueble_provider.dart';
import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';
  final inmuebleProvider = new InmuebleProvider();

  final peliculas = [
    'Spiderman',
    'Hackers',
    'Robocop',
    'IA',
    'La muerte',
    'Capitan America',
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones de nuestro AppBar
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        //tiempo de animación
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen cuando la persona escribe
    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: inmuebleProvider.buscarInmueble(query),
      builder:
          (BuildContext context, AsyncSnapshot<InmuebleModel> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;

          return ListView.builder(
            itemCount: peliculas.inmuebles.length,
            itemBuilder: (context, i) {
              {
                Inmueble inmuebleObtenido = peliculas.inmuebles[i];
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        // _crearSliderDeImagenes(context, inmuebleObtenido),
                        ListTile(
                          leading: FadeInImage(
                            placeholder: AssetImage('assets/img/camera.png'),
                            image: NetworkImage(inmuebleObtenido.imagen[0]),
                            width: 50.0,
                            fit: BoxFit.contain,
                          ),
                          title: Text(inmuebleObtenido.nombre),
                          subtitle: Text(inmuebleObtenido.estado),
                          trailing: Text('\$'+inmuebleObtenido.precioalquiler.toString()),
                          onTap: () {
                            close(context, null);
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
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //PARA BUSCAR EN CODIGO LOCAL(QUEMADO)
  /* @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen cuando la persona escribe

    final listaSugerida = (query.isEmpty)
        ? peliculasRecientes
        : peliculas.where(
            (peli) => peli.toLowerCase().startsWith(query.toLowerCase())).toList();


    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[i]),
          onTap: () {
            seleccion = listaSugerida[i];
            showResults(context);
          },
        );
      },
    );
  }*/
}
