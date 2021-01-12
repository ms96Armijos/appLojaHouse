import 'package:applojahouse/src/bloc/provider.dart';
import 'package:applojahouse/src/common/debouncer.dart';
import 'package:applojahouse/src/utils/utils.dart';
import 'package:applojahouse/src/widgets/banner_widget.dart';
import 'package:applojahouse/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';

class CambiarPasswordPage extends StatefulWidget {
  @override
  _CambiarPasswordPage createState() => _CambiarPasswordPage();
}

class _CambiarPasswordPage extends State<CambiarPasswordPage> {
  LoginBloc loginBloc;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool visible = true;
  bool visibleConfirmarPassword = true;

@override
  void dispose() {
    // TODO: implement dispose
    loginBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    loginBloc = new LoginBloc();

    return Scaffold(
      key: scaffoldKey,
      drawer: MenuWidget(),
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }

  _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: [
                _crearPassword(bloc),
                _crearConfirmarPassword(bloc),
                SizedBox(
                  height: 30.0,
                ),
                _crearBoton(bloc),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.nuevaPasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText:visible,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.blueAccent,
                ),
                suffixIcon: IconButton(
                  icon: Icon(visible ? Icons.visibility_off : Icons.visibility),
                  onPressed: (){
                     setState(() {
                    visible = !visible;
                  });
                  },
                ),
                labelText: 'Nueva contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeNuevaPassword,
            
          ),
        );
      },
    );
  }

    _crearConfirmarPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.confirmarPasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText:visibleConfirmarPassword,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.blueAccent,
                ),
                suffixIcon: IconButton(
                  icon: Icon(visibleConfirmarPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: (){
                     setState(() {
                    visibleConfirmarPassword = !visibleConfirmarPassword;
                  });
                  },
                ),
                labelText: 'Confirmar contraseña',
                //counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.changeConfirmPassword,
            
          ),
        );
      },
    );
  }


  _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.formValidPasswordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
            child: Text('Cambiar contraseña'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 10.0,
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData
              ? () {
                  _cambiarPassword(context, bloc);
                }
              : null,
        );
      },
    );
  }

  _cambiarPassword(BuildContext context, LoginBloc bloc) async {
    String password = bloc.nuevaPassword.toString();
    String confirmarPassword = bloc.confirmarPassword.toString();
    final _debouncer = Debouncer(milliseconds: 2000);

    if(password == confirmarPassword){
      Map respuesta = await loginBloc.cambiarPassword(password);
    if (respuesta['ok']) {
      mostrarSnackBar('Se ha actualizado su contraseña');
      _debouncer.run(() => Navigator.pushReplacementNamed(context, 'home'));
    } else {
      mostrarAlerta(context, respuesta['mensaje']);
    }
    }else{
      mostrarSnackBar('Las contraseñas no coinciden');
    }
    
  }

  void mostrarSnackBar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromRGBO(0, 136, 235, 1.0),
          Color.fromRGBO(16, 88, 142, 1.0),
        ],
      )),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          right: -30.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          right: -10.0,
          child: circulo,
        ),
        Positioned(
          bottom: 120.0,
          right: 20.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          left: -20.0,
          child: circulo,
        ),
        BannerWidget(
          valor: 'Cambia tu contraseña',
        )
      ],
    );
  }
}
