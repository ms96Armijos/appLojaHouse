import 'package:applojahouse/src/models/inmueble_model.dart';
import 'package:applojahouse/src/providers/inmueble_provider.dart';
import 'package:rxdart/rxdart.dart';

class InmuebleBloc {
  final _inmuebleController = new BehaviorSubject<InmuebleModel>();

  final _inmuebleProvider = new InmuebleProvider();

  Stream<InmuebleModel> get inmueblesStream => _inmuebleController.stream;

  void cargarInmuebles() async {
      final inmuebles = await _inmuebleProvider.obtenerInmuebles();
        _inmuebleController.sink.add(inmuebles);
  }

  dispose() {
    _inmuebleController?.close();
  }
}
