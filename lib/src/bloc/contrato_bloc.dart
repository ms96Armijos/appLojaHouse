import 'package:applojahouse/src/models/contrato_model.dart';
import 'package:applojahouse/src/providers/contrato_provider.dart';
import 'package:rxdart/rxdart.dart';

class ContratoBloc {

  final _contratoController = new BehaviorSubject<ContratoModel>();


  final _contratoProvider = new ContratoProvider();


  //Recuperar datos del stream
  Stream<ContratoModel> get contratosStream => _contratoController.stream;


  void obtenerContratos(int cantidad) async{
    final contratos = await _contratoProvider.obtenerContratos(cantidad);
    print("Obntenidos: ${contratos.total}");
   if(!_contratoController.isClosed){
     //inserto el resultado al stream
      _contratoController.sink.add(contratos);
   }
  }

   Future<ContratoModel> obtenerContratoEspecifico(String id) async {
    final contrato = await _contratoProvider.obtenerContratoEspecifico(id);
    //print(usuario);
    if (contrato != null) {
      return contrato;
    } else {
      return null;
    }
    //_pefilController.sink.add(usuario);
  }

 Future<Map<String, dynamic>> aceptarContrato(String id, String acuerdo, String estado) async {
    final respuesta = await _contratoProvider.aceptarContrato(id, acuerdo, estado);
    return respuesta;
  }

  dispose(){
    _contratoController?.close();
  }
}