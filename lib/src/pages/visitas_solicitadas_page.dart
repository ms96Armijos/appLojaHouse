import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/bloc/visita_bloc.dart';
import 'package:applojahouse/src/models/visitas.dart';
import 'package:applojahouse/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

class VisitasSolicitadasPage extends StatelessWidget {
  final estiloTitulo = TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    final visitaBloc = Provider.visitaBloc(context);
    visitaBloc.cargarVisitas();
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Solicitudes de visita realizadas',
            style: TextStyle(fontSize: 15.0),
          ),
        ),
        drawer: MenuWidget(),
        body: Container(
          child: Card(
            child: _crearListadoInmuebles(visitaBloc),
          ),
        ));
  }

  _crearListadoInmuebles(VisitaBloc inmuebleBloc) {
    return StreamBuilder(
      stream: inmuebleBloc.getvisitasStream,
      builder: (BuildContext context, AsyncSnapshot<GetvisitaModel> snapshot) {
        if (snapshot.hasData) {
          final visitas = snapshot.data.visitas;
          return ListView.builder(
            itemCount: visitas.length,
            itemBuilder: (context, i) {
              {
                Visita visits = visitas[i];
                //print(visits.usuarioarrendatario.imagen);

                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [_crearItemVisita(context, visits)],
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

  _crearItemVisita(BuildContext context, Visita visita) {
    return Container(
      child: Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearTitulo(context, visita),
            SizedBox(
              height: 25.0,
            )
          ],
        ),
      ),
    );
  }

  _crearTitulo(BuildContext context, Visita visita) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () =>
                    Navigator.pushNamed(context, 'visitasrealizadas', arguments: visita),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Solicitud realizada al inmueble:',
                      style: estiloSubTitulo,
                    ),
                    Text(
                      visita.inmueble.nombre.toString(),
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
                      visita.estado.toString(),
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
                    _fecha(context, visita),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () =>
                  Navigator.pushNamed(context, 'visitasrealizadas', arguments: visita),
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
            )
          ],
        ),
      ),
    );
  }

  _fecha(BuildContext context, Visita visita) {
    String fechaFormateada = DateFormat('dd-MM-yyyy').format(visita.fecha);
    return Text(
      fechaFormateada,
      style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
    );
  }

  _crearSliderDeImagenes(BuildContext context, Visita visita) {
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
              image: NetworkImage(visita.inmueble.imagen[index]),
              height: 300.0,
              width: 300.0,
              fit: BoxFit.cover,
            ),
          );
        },
        autoplay: true,
        itemCount: visita.inmueble.imagen.length,
        pagination: new SwiperPagination(),
      ),
    );
  }
}
