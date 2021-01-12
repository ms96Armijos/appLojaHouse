import 'package:applojahouse/src/models/visita_model.dart';
import 'package:applojahouse/src/models/visitas.dart';
import 'package:applojahouse/src/providers/visita_provider.dart';
import 'package:rxdart/rxdart.dart';

class VisitaBloc {

  final _visitasController = new BehaviorSubject<VisitaModel>();
  final _getVisitasController = new BehaviorSubject<GetvisitaModel>();
  final _cargandoDatosController = new BehaviorSubject<bool>();


  final _visitaProvider = new VisitaProvider();


  Stream<VisitaModel> get visitasStream => _visitasController.stream;
  Stream<GetvisitaModel> get getvisitasStream => _getVisitasController.stream;
  Stream<bool> get cargando => _cargandoDatosController.stream;


  void cargarVisitas() async{
    final visitas = await _visitaProvider.obtenerVisitas();
    //print(visitas);
    _getVisitasController.sink.add(visitas);
  }


  void crearVisita(VisitaModel visita) async{
    _cargandoDatosController.sink.add(true);
    await _visitaProvider.crearVisita(visita);
    _cargandoDatosController.sink.add(false);
  }

  dispose(){
    _visitasController?.close();
    _cargandoDatosController?.close();
    _getVisitasController?.close();
  }
}