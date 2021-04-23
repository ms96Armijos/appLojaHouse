import 'package:applojahouse/src/common/debouncer.dart';
import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/models/visita_model.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferencias_usuario.dart';
import 'package:applojahouse/src/providers/visita_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';

class VisitaPage extends StatefulWidget {
  @override
  _VisitaPageState createState() => _VisitaPageState();
}

class _VisitaPageState extends State<VisitaPage> {
  final estiloTitulo = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold);
  final estiloSubTitulo = TextStyle(fontSize: 13.0, color: Colors.grey);

  TextEditingController _fechaController = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  VisitaModel visitaModel = new VisitaModel();

  Inmueble inmuebleModel = new Inmueble();

  final visitaProvider = new VisitaProvider();
  final preferencias = new PreferenciasUsuario();

  bool guardando = false;
  String _fecha = '';

  DateTime tiempo = new DateTime.now();

  
  @override
  Widget build(BuildContext context) {
    final inmuebleObtenido = ModalRoute.of(context).settings.arguments;

    if (inmuebleObtenido != null) {
      inmuebleModel = inmuebleObtenido;
      visitaModel.usuarioarrendatario = preferencias.idUsuario;
      visitaModel.inmueble = inmuebleModel.id;
      print('bien');
    } else {
      print('nulo');
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Visitas'),
        /* actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              _crearCardInformacionInmueble(),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    _crearBanerSolicitarVisita(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _crearBoton(),
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

  String _fechaActual(DateTime fecha) {
    String fechaFormateada = DateFormat('dd-MM-yyyy').format(fecha);
    return fechaFormateada;
  }

  _crearCardInformacionInmueble() {
    return Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            _crearSliderDeImagenes(),
            _crearTitulo(),
            _crearTextoDescripcion(),
            SizedBox(
              height: 20.0,
            )
          ],
        ));
  }

  _crearBanerSolicitarVisita() {
    return Card(
        elevation: 2.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          child: Column(
            children: [
              Text(
                '¡Solicita una visita ahora!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: Colors.deepOrangeAccent),
              ),
              Divider(),
              SizedBox(
                height: 10.0,
              ),
              _crearFecha(context),
              SizedBox(
                height: 20.0,
              ),
              _crearDescripcionDeLaVisita(),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ));
  }

  _crearFechaDeVisita() {
    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: ('Fecha de visita'),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      onSaved: (value) => visitaModel.fecha = DateTime.parse(value),
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese la fecha de visita';
        } else {
          return null;
        }
      },
    );
  }

  _crearDescripcionDeLaVisita() {
    return TextFormField(
      initialValue:
          'Hola, estoy interesado en su inmueble \"${inmuebleModel.nombre}\" y me gustaría estar en contacto con usted para poder llegar a un acuerdo. Muchas gracias por su tiempo, hasta luego.',
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          labelText: ('Descripción'),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
      onSaved: (value) => visitaModel.descripcion = value,
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese su descripción';
        } else {
          return null;
        }
      },
    );
  }

  _crearEstadoDelInmueble() {
    return TextFormField(
      initialValue: inmuebleModel.id.toString(),
      textCapitalization: TextCapitalization.sentences,
      textAlign: TextAlign.start,
      onSaved: (value) => visitaModel.inmueble = value.toString(),
      validator: (value) {
        if (value.length <= 0) {
          return 'No hay estado';
        } else {
          return null;
        }
      },
    );
  }

  _crearServiciosDelInmueble() {
    return TextFormField(
      initialValue: inmuebleModel.servicio.toString(),
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Servicios que incluye'),
      enabled: false,
      onSaved: (value) => inmuebleModel.precioalquiler = int.parse(value),
      validator: (value) {
        if (value.length <= 0) {
          return 'No hay servicios';
        } else {
          return null;
        }
      },
    );
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

    /*return ListView(
                      shrinkWrap: true,
                      children: inmuebleModel.imagen
                          .map(
                            (e) => ,
              
                            /*Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: FadeInImage(
                                        placeholder: AssetImage('assets/img/jar-loading.gif'),
                                        image: NetworkImage(e),
                                        height: 300.0,
                                        width: 300.0,
                                        fit: BoxFit.cover,
                                      ))
                                ],
                              )*/
                          )
                          .toList());*/
  }

  _crearTitulo() {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    inmuebleModel.nombre.toString(),
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
                    inmuebleModel.direccion.toString(),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text('Servicios incluidos:', style: estiloSubTitulo),
                  Text(
                    inmuebleModel.servicio
                        .toString()
                        .replaceAll('[', '')
                        .replaceAll(']', ''),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  inmuebleModel.estado.toString(),
                  style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.money_off_csred_outlined,
                      color: Colors.red,
                      size: 20.0,
                    ),
                    Text(
                      inmuebleModel.precioalquiler.toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ],
                )
              ],
            )
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
                      'Descripción:',
                      textAlign: TextAlign.start,
                      style: estiloSubTitulo,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      inmuebleModel.descripcion.toString(),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  _crearBoton() {
    return RaisedButton.icon(
        padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.blueAccent,
        textColor: Colors.white,
        icon: Icon(Icons.send),
        label: Text(
          'Solicitar Visita',
          style: TextStyle(fontSize: 15.0),
        ),
        onPressed: (guardando) ? null : _submit);
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    if(mounted)
    setState(() {
      guardando = true;
    });

    visitaProvider.crearVisita(visitaModel);

    /*if (visitaModel.id == null) {
      visitaProvider.crearVisita(visitaModel);
    } else {
      visitaProvider.editarVisita(visitaModel);
    }*/

    print('hola ' + visitaModel.fecha.toString());
    mostrarSnackBar('Visita registrada exitosamente');
    final _debouncer = Debouncer(milliseconds: 2000);
    _debouncer.run(() => Navigator.pushReplacementNamed(context, 'home'));
    //Navigator.pop(context);
  }

  _crearFecha(BuildContext context) {
    return TextFormField(
      controller: _fechaController,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Fecha de visita',
        labelText: 'Fecha de visita',
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese la fecha de visita';
        } else {
          return null;
        }
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime.now(),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      String fechaFormateada = DateFormat('dd-MM-yyyy').format(picked);
      if(mounted)
      setState(() {
        _fecha = fechaFormateada;
        _fechaController.text = _fecha;
        visitaModel.fecha = picked;
      });
    } else {
      if(mounted)
      setState(() {
        _fechaController.text = _fechaActual(tiempo);
      });
    }
  }
}
