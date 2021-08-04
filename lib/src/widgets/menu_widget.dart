import 'package:applojahouse/src/pages/login_page.dart';
import 'package:applojahouse/src/preferenciasUsuario/preferenciasUsuario.dart';
import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final preferencias = new PreferenciasUsuario();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/fondodrawer.jpeg'),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(Icons.house),
            title: Text('Buscar inmuebles'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
            },
          ),
          ListTile(
            leading: Icon(Icons.view_agenda),
            title: Text('Visitas solicitadas'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'visitas');
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Contratos de alquiler'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'listacontratos');
            },
          ),
          /*ListTile(
            leading: Icon(Icons.person),
            title: Text('Mi perfil'),
            onTap: (){
              Navigator.pop(context);
              Navigator.pushNamed(context, 'perfil', arguments: preferencias.idUsuario);
            },
          ),*/
          
          Padding(
            padding: EdgeInsets.only(bottom: 230),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.security),
            title: Text('Cambiar Contraseña'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'cambiopassword');
            },
          ),

          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Salir'),
            onTap: () {
              preferencias.clear();
              Navigator.pop(context);
              Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false);
              /*Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()),
                  (Route<dynamic> route) => false);*/
              //Navigator.pushReplacementNamed(context, '');
            },
          ),
        ],
      ),
    );
  }
}
