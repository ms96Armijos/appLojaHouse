import 'package:applojahouse/src/bloc/contrato_bloc.dart';
import 'package:applojahouse/src/bloc/inmueble_bloc.dart';
export 'package:applojahouse/src/bloc/inmueble_bloc.dart';

import 'package:applojahouse/src/bloc/login_bloc.dart';
import 'package:applojahouse/src/bloc/perfil_bloc.dart';
export 'package:applojahouse/src/bloc/login_bloc.dart';

import 'package:applojahouse/src/bloc/registro_bloc.dart';
export 'package:applojahouse/src/bloc/registro_bloc.dart';

import 'package:applojahouse/src/bloc/visita_bloc.dart';
export 'package:applojahouse/src/bloc/visita_bloc.dart';

import 'package:flutter/material.dart';

class Provider extends InheritedWidget {

  final loginBloc = LoginBloc();
  final _visitaBloc = VisitaBloc();
  final _inmuebleBloc = InmuebleBloc();
  final _registroBloc = RegistroBloc();
  final _perfilBloc = PerfilBloc();
  final _contratoBloc = ContratoBloc();



  static Provider _instance;

  factory Provider({Key key, Widget child}){
    
    if(_instance == null){
      _instance = new Provider._internal(key: key, child: child,);
    }

    return _instance;
  }

  

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBloc;
  }

    static VisitaBloc visitaBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._visitaBloc;
  }

  static InmuebleBloc inmuebleBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._inmuebleBloc;
  }

  static RegistroBloc registroBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._registroBloc;
  }

    static PerfilBloc perfilBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._perfilBloc;
  }

     static ContratoBloc contratoBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._contratoBloc;
  }
}
