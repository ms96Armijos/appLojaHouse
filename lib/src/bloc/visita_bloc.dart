import 'package:applojahouse/src/models/visita_model.dart';
import 'package:applojahouse/src/models/visitas.dart';
import 'package:applojahouse/src/providers/visita_provider.dart';
import 'package:rxdart/rxdart.dart';

class VisitaBloc {

  final _visitasController = new BehaviorSubject<VisitaModel>();
  final _getVisitasController = new BehaviorSubject<GetvisitaModel>();
  final _cargandoDatosController = new BehaviorSubject<bool>();

  //final _visitasContadorController = new BehaviorSubject<int>();


  final _visitaProvider = new VisitaProvider();


  Stream<VisitaModel> get visitasStream => _visitasController.stream;
  Stream<GetvisitaModel> get getvisitasStream => _getVisitasController.stream;
  Stream<bool> get cargando => _cargandoDatosController.stream;

  //Stream<int> get visitasContador => _visitasContadorController.stream;


  void cargarVisitas() async{
    final visitas = await _visitaProvider.obtenerVisitas();
    //print(visitas);
    _getVisitasController.sink.add(visitas);
  }

  /*void contarVisitas() async{
    final visitas = await _visitaProvider.obtenerVisitas();
    _visitasContadorController.sink.add(visitas.total);
  }*/


  void crearVisita(VisitaModel visita) async{
    _cargandoDatosController.sink.add(true);
    await _visitaProvider.crearVisita(visita);
    _cargandoDatosController.sink.add(false);
  }

   Future<Map<String, dynamic>> eliminarVisita(String id, String estado) async {
    final respuesta = await _visitaProvider.eliminarVisita(id, estado);
    return respuesta;
  }



  dispose(){
    _visitasController?.close();
    _cargandoDatosController?.close();
    _getVisitasController?.close();
    //_visitasContadorController?.close();
  }
}