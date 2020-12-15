import 'package:applojahouse/src/models/usuario_model.dart';
import 'package:applojahouse/src/providers/usuario_provider.dart';
import 'package:http/http.dart' as http;

class PerfilBloc {
  /*final _nombreController = BehaviorSubject<String>();
  final _apellidoController = BehaviorSubject<String>();
  final _cedulaController = BehaviorSubject<String>();
  final _celularController = BehaviorSubject<String>();
  final _telefonoController = BehaviorSubject<String>();*/

  //RECUPERAR LOS DATOS DEL STREAM
  /**Stream<String> get nombreStream => _nombreController.stream;
  Stream<String> get apellidoStream => _apellidoController.stream;
  Stream<String> get cedulaStream => _cedulaController.stream;
  Stream<String> get celularStream => _celularController.stream;
  Stream<String> get telefonoStream => _telefonoController.stream;*/

  //Stream<bool> get formValidStream => Rx.combineLatest5(nombreStream, apellidoStream, cedulaStream, celularStream, telefonoStream, (n, a, c , m, t) => true);

  //INSERTAR VALORES AL STREAM
  /*Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeApellido => _apellidoController.sink.add;
  Function(String) get changeCedula => _cedulaController.sink.add;
  Function(String) get changeCelular => _celularController.sink.add;
  Function(String) get changeTelefono => _telefonoController.sink.add;*/

  //OBTENER LOS ULTIMOS VALORES INGRESADOS A LOS STREAMS
  /*String get nombre => _nombreController.value;
  String get apellido => _apellidoController.value;
  String get cedula => _cedulaController.value;
  String get celular => _celularController.value;
  String get telefono => _telefonoController.value;*/

  final _perfilUsuarioProvider = new UsuarioProvider();

  Future<Map<String, dynamic>> cargarUsuario() async {
    final usuario = await _perfilUsuarioProvider.obtenerUsuario();
    //print(usuario);
    if (usuario != null) {
      return usuario;
    } else {
      return {"ok": false, "data": "No hay datos del usuario"};
    }
    //_pefilController.sink.add(usuario);
  }


 Future<Map<String, dynamic>> cargarUsuarioEspecifico(String id) async {
    final usuario = await _perfilUsuarioProvider.obtenerUsuarioEspecifico(id);
    //print(usuario);
    if (usuario != null) {
      return usuario;
    } else {
      return {"ok": false, "usuario": "No hay datos del usuario"};
    }
    //_pefilController.sink.add(usuario);
  }





  Future<bool> editarDatosDelPerfilUsuario(UsuarioModel usuario) async {
    final respuesta =
        await _perfilUsuarioProvider.editarDatosDelPerfilUsuario(usuario);
    return respuesta;
  }

  
  Future<http.StreamedResponse> actualizarImagen(String filePath) async {
    final respuesta = await _perfilUsuarioProvider.actualizarImagen(filePath);
    return respuesta;
  }

  /*dispose() {
    _nombreController?.close();
    _apellidoController?.close();
    _cedulaController?.close();
    _celularController?.close();
    _telefonoController?.close();
  }*/
}
