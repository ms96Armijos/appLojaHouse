import 'dart:io';

import 'package:applojahouse/src/bloc/perfil_bloc.dart';
import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/pages/login_page.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:applojahouse/src/utils/debouncer.dart';
import 'package:applojahouse/src/models/usuario_model.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:applojahouse/src/pages/home_page.dart';


class PerfilPage extends StatefulWidget {
  @override
  _PerfilPageState createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  PickedFile _imageFile;
  final _globalKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final ImagePicker _picker = ImagePicker();

  bool circularProgress = false;
  PerfilBloc perfilBloc;
  final usuarioProvider = UsuarioProvider();
  final preferencias = new PreferenciasUsuario();

  bool estaLogueado = false;


  Future<void> verificarToken() async{
    bool verify = await usuarioProvider.verificarToken();
    if(verify){
      estaLogueado = false;
      preferencias.clear();
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false); 
    }else{
      estaLogueado = true;
      print('Token válido ${preferencias.token}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      verificarToken();
    });
  }

  TextEditingController _nombresController = TextEditingController();
  TextEditingController _apellidosController = TextEditingController();
  TextEditingController _cedulaController = TextEditingController();
  TextEditingController _celularController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  String id = '';
  String fotoUser = '';

  @override
  Widget build(BuildContext context) {
    perfilBloc = Provider.perfilBloc(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Perfil de usuario'),
        ),
        key: scaffoldKey,
        //drawer: MenuWidget(),
        body: Form(
          key: _globalKey,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            children: [
              FutureBuilder(
                future: perfilBloc.cargarUsuario(),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasError) {
                    print("eroro: " + snapshot.hasError.toString());
                  }
                  if (snapshot.hasData && snapshot.data['usuario'] != null) {
                    _nombresController.text =
                        snapshot.data['usuario']['nombre'];
                    _apellidosController.text =
                        snapshot.data['usuario']['apellido'];
                    _cedulaController.text = snapshot.data['usuario']['cedula'];
                    _celularController.text = '0'+snapshot.data['usuario']['movil'].toString().substring(4,13);
                    _telefonoController.text =
                        snapshot.data['usuario']['convencional'];
                    id = snapshot.data['usuario']['_id'];
                    if(snapshot.data['usuario']['imagen'].toString().isEmpty){
                      fotoUser = snapshot.data['usuario']['imagen'][0]['url'].toString();
                    }else{
                      fotoUser = URLFOTOPERFIL;
                    }
                    //print(snapshot.data['usuario']['imagen'][0]['url']);
                    return Column(
                      children: [
                        actualizarImagenPerfilUsuario(),
                        _crearBotonActualizarFoto(),
                        _crearNombre(perfilBloc),
                        SizedBox(
                          height: 15.0,
                        ),
                        _crearApellido(perfilBloc),
                        SizedBox(
                          height: 15.0,
                        ),
                        _crearCedula(perfilBloc),
                        SizedBox(
                          height: 15.0,
                        ),
                        _crearCelular(perfilBloc),
                        SizedBox(
                          height: 15.0,
                        ),
                        _crearTelefono(perfilBloc),
                        SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _crearBotonCancelar(),
                            _crearBoton(perfilBloc),
                          ],
                        )
                      ],
                    );
                  }else {
                    print("no hay datos ");
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
                                  placeholder:
                                      AssetImage('assets/img/sorry.jpg'),
                                  image: AssetImage('assets/img/sorry.jpg'),
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Text("No hay información del perfil",
                                    style: TextStyle(
                                        fontSize: 19.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent)),
                                SizedBox(
                                  height: 30.0,
                                ),
                                _crearBotonRegresar(context),
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
            ],
          ),
        ));
  }

      _crearBotonRegresar(BuildContext context) {
    return RaisedButton(
      color: Colors.blueAccent,
      onPressed: () {
        //Navigator.pop(context);
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomePage()), (Route<dynamic> route) => false);
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home');
      },
      elevation: 4.0,
      splashColor: Colors.blueGrey,
      child: Text(
        'Regresar'.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }

  _crearBoton(PerfilBloc bloc) {
    return StreamBuilder(
      //stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              child: Text('Actualizar Perfil'.toUpperCase()),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 5.0,
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: () => _editarPerfilUsuario(context, bloc));
      },
    );
  }

  _crearBotonCancelar() {
    return RaisedButton(
      color: Colors.black26,
      onPressed: () {
        //Navigator.pop(context);
        Navigator.pushReplacementNamed(context, 'home');
      },
      elevation: 4.0,
      splashColor: Colors.blueGrey,
      child: Text(
        'Cancelar'.toUpperCase(),
        style: TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    );
  }

  _crearBotonActualizarFoto() {
    return (_imageFile == null)
        ? Container()
        : RaisedButton(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15.0),
            child: Container(
              child: Text(
                'Actualizar imagen',
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            color: Colors.blueAccent,
            textColor: Colors.white,
            onPressed: _imageFile != null
                ? () async {
                    final _debouncer = Debouncer(milliseconds: 2000);
                    if (mounted)
                      setState(() {
                        circularProgress = true;
                      });

                    if (_imageFile.path != null) {
                      var imagenResponse =
                          await perfilBloc.actualizarImagen(_imageFile.path);
                      mostrarSnackBar('Imagen actualizada exitosamente');
                      _debouncer.run(() =>
                          Navigator.pushReplacementNamed(context, 'perfil'));

                      if (imagenResponse.statusCode == 200) {
                        if (mounted)
                          setState(() {
                            circularProgress = false;
                            _imageFile = null;
                          });
                        //Navigator.pushReplacementNamed(context, 'perfil');

                        /* Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);*/
                      }
                    } else {
                      if (mounted)
                        setState(() {
                          circularProgress = false;
                        });
                      //Navigator.pushReplacementNamed(context, 'perfil');

                      /*Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false);*/
                    }
                  }
                : null,
          );
  }

  _editarPerfilUsuario(BuildContext context, PerfilBloc bloc) async {
    /*String nombre = bloc.nombre.toString();
    String apellido = bloc.apellido.toString();
    String cedula = bloc.cedula.toString();
    String celular = bloc.celular.toString();
    String telefono = bloc.telefono.toString();*/
    if (!_globalKey.currentState.validate()) return;
    UsuarioModel user = new UsuarioModel();

    user.nombre = _nombresController.text.toString();
    user.apellido = _apellidosController.text.toString();
    user.cedula = _cedulaController.text.toString();
    user.movil = '593'+_celularController.text.toString();
    user.convencional = _telefonoController.text.toString();
    user.id = id;

    /*user.nombre = nombre;
    user.apellido = apellido;
    user.cedula = cedula;
    user.movil = celular;
    user.convencional = telefono;
    user.id = id;*/

    //print(user.nombre);

    //print(user.id);

    final respuesta = await perfilBloc.editarDatosDelPerfilUsuario(user);
    print('Respuesta: $respuesta');
    mostrarSnackBar('Datos actualizados exitosamente');
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  actualizarImagenPerfilUsuario() {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? NetworkImage(fotoUser)
                : FileImage(File(_imageFile.path)),
            backgroundColor: Colors.blueAccent,
          ),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((builder) => botonDeActualizarPerfil()));
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.yellowAccent,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  botonDeActualizarPerfil() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Text(
            "Buscar foto de perfil",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                icon: Icon(Icons.camera),
                onPressed: () {
                  tomarFotografia(ImageSource.camera);
                },
                label: Text("Cámara"),
              ),
              FlatButton.icon(
                icon: Icon(Icons.image),
                onPressed: () {
                  tomarFotografia(ImageSource.gallery);
                },
                label: Text("Galería"),
              )
            ],
          )
        ],
      ),
    );
  }

  tomarFotografia(ImageSource source) async {
    final pickedFile = await _picker.getImage(
      source: source,
    );
    if (mounted)
      setState(() {
        _imageFile = pickedFile;
        _crearBotonActualizarFoto();
      });
  }

  _crearNombre(PerfilBloc bloc) {
    return StreamBuilder(
      //initialData: _nombresController.text.toString(),
      //stream: bloc.nombreStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _nombresController.text = value,
            validator: (value) {
              if (value.length <= 0) {
                return 'Ingrese sus nombres';
              } else {
                return null;
              }
            },
            controller: _nombresController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                ),
                labelText: 'Nombres',
                counterText: snapshot.data,
                errorText: snapshot.error),
            //onChanged: bloc.changeNombre,
          ),
        );
      },
    );
  }

  _crearApellido(PerfilBloc bloc) {
    return StreamBuilder(
      //initialData: _apellidosController.text.toString(),
      //stream: bloc.apellidoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _apellidosController.text = value,
            validator: (value) {
              if (value.length <= 0) {
                return 'Ingrese sus apellidos';
              } else {
                return null;
              }
            },
            controller: _apellidosController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                ),
                labelText: 'Apellidos',
                counterText: snapshot.data,
                errorText: snapshot.error),
            // onChanged: bloc.changeApellido,
          ),
        );
      },
    );
  }

  _crearCedula(PerfilBloc bloc) {
    return StreamBuilder(
      //initialData: _cedulaController.text.toString(),
      //stream: bloc.cedulaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _cedulaController.text = value,
            validator: (value) {
              if (value.length <= 0 || value.length <10) {
                return 'Ingrese su número de cédula';
              } else {
                return null;
              }
            },
            controller: _cedulaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.markunread_mailbox_outlined,
                  color: Colors.blueAccent,
                ),
                labelText: 'Cédula',
                counterText: snapshot.data,
                errorText: snapshot.error),
            //onChanged: bloc.changeCedula,
          ),
        );
      },
    );
  }

  _crearCelular(PerfilBloc bloc) {
    return StreamBuilder(
      //initialData: _celularController.text.toString(),
      //stream: bloc.celularStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _celularController.text = value,
            validator: (value) {
              if (value.length <= 0 || value.length <10) {
                return 'Ingrese su número de celular';
              } else if(value.length>10){
                return 'Debe contener 10 dígitos';
              }else {
                return null;
              }
            },
            controller: _celularController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.phone_android,
                  color: Colors.blueAccent,
                ),
                labelText: 'Celular',
                counterText: snapshot.data,
                errorText: snapshot.error),
            //onChanged: bloc.changeCelular,
          ),
        );
      },
    );
  }

  _crearTelefono(PerfilBloc bloc) {
    return StreamBuilder(
      //initialData: _telefonoController.text.toString(),
      //stream: bloc.telefonoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: (value) => _telefonoController.text = value,
            validator: (value) {
              if (value.length <= 0) {
                return 'Ingrese su número de teléfono';
              } else {
                return null;
              }
            },
            controller: _telefonoController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.phone_callback,
                  color: Colors.blueAccent,
                ),
                labelText: 'Teléfono',
                counterText: snapshot.data,
                errorText: snapshot.error),
            //onChanged: bloc.changeTelefono,
          ),
        );
      },
    );
  }
}
