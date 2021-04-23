import 'package:flutter/material.dart';

class FiltroInmueblePage extends StatefulWidget {
  @override
  _FiltroInmueblePageState createState() => _FiltroInmueblePageState();
}

class _FiltroInmueblePageState extends State<FiltroInmueblePage> {

  String _opcionSeleccionada0 = 'Volar';
  String _opcionSeleccionada1 = 'Rayos-X';
  String _opcionSeleccionada2 = 'Super Aliento';

  List<String> _poderes = ['Volar', 'Rayos-X', 'Super Aliento', 'Super Fuerza'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola Filtros'),),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              _crearDropdown0(),
              SizedBox(height: 20.0,),
              _crearDropdown1(),
              SizedBox(height: 20.0,),
              _crearDropdown2(),
              SizedBox(height: 20.0,),
              _crearBotonCancelar()
            ],
          ),
        ),
    );
  }

   Widget _crearDropdown0() {
    return Row(
      children: [
        Icon(Icons.toys),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
            child: DropdownButtonHideUnderline (
              child: DropdownButton(
              value: _opcionSeleccionada0,
              items: getOpcionesDropdown(),
              onChanged: (opt) {
                setState((){
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
        Icon(Icons.toys),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
            child: DropdownButtonHideUnderline (
              child: DropdownButton(
              value: _opcionSeleccionada1,
              items: getOpcionesDropdown(),
              onChanged: (opt) {
                setState((){
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
        Icon(Icons.toys),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
            child: DropdownButtonHideUnderline (
              child: DropdownButton(
              value: _opcionSeleccionada2,
              items: getOpcionesDropdown(),
              onChanged: (opt) {
                setState((){
                  _opcionSeleccionada2 = opt;
                });
              },
          ),
            ),
        )
      ],
    );
  }

    List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();
    _poderes.forEach((poder) {
      lista.add(DropdownMenuItem(
        child: Text(poder),
        value: poder,
      ));
    });
    return lista;
  }


    _crearBotonCancelar() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 100.0),
          child: RaisedButton(
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.pushReplacementNamed(context, 'home');
            },
            elevation: 4.0,
            splashColor: Colors.blueGrey,
            child: Row(
              children: [
                Text(
                  'Filtrar'.toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                SizedBox(width: 10.0,),
                Icon(Icons.search, size: 30.0,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

 