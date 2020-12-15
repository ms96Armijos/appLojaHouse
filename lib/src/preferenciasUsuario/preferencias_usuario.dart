import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPreferencias() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get token {
    return _prefs.getString('token') ?? '';
  }

  set token(String value) {
    _prefs.setString('token', value);
  }

  get idUsuario {
    return _prefs.getString('idUsuario') ?? '';
  }

  set idUsuario(String value) {
    _prefs.setString('idUsuario', value);
  }

  Future clear() async {
    await _prefs.clear();
  }
}
