import 'package:applojahouse/src/models/usuario_model.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:flutter/material.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  final formKey = GlobalKey<FormState>();

  UsuarioModel usuarioModel = new UsuarioModel();

  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _crearNombre(),
                _crearApellido(),
                _crearCorreo(),
                _crearMovil(),
                _crearRol(),
                _crearBoton(),
                //_crearDisponible()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _crearNombre() {
    return TextFormField(
      initialValue: usuarioModel.nombre,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Nombres'),
      onSaved: (value) => usuarioModel.nombre = value,
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese sus nombres';
        } else {
          return null;
        }
      },
    );
  }

  _crearApellido() {
    return TextFormField(
      initialValue: usuarioModel.apellido,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Apellidos'),
      onSaved: (value) => usuarioModel.apellido = value,
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese sus apellidos';
        } else {
          return null;
        }
      },
    );
  }

    _crearCorreo() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      initialValue: usuarioModel.correo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Correo electrónico'),
      onSaved: (value) => usuarioModel.correo = value,
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese su correo electrónico';
        } else {
          return null;
        }
      },
    );
  }

  _crearMovil() {
    return TextFormField(
      initialValue: usuarioModel.movil,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Celular'),
      onSaved: (value) => usuarioModel.movil = value,
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese su número de celular';
        } else {
          return null;
        }
      },
    );
  }

  _crearRol() {
    return TextFormField(
      initialValue: usuarioModel.rol,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Rol'),
      onSaved: (value) => usuarioModel.rol = value,
      validator: (value) {
        if (value.length <= 0) {
          return 'Ingrese su rol';
        } else {
          return null;
        }
      },
    );
  }
  _crearBoton() {
    return RaisedButton.icon(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.deepPurple,
        textColor: Colors.white,
        label: Text('Guardar'),
        icon: Icon(Icons.save),
        onPressed: _submit);
  }

  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    print(usuarioModel.nombre);
    print(usuarioModel.apellido);
    print(usuarioModel.correo);
    print(usuarioModel.movil);
    print(usuarioModel.estado);
    print(usuarioModel.rol);

    usuarioProvider.crearUsuario(usuarioModel);
  }

 /* _crearDisponible() {
    return SwitchListTile(
      value: true,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        usuarioModel.estado = value;
      }),
    );
  }*/
}
