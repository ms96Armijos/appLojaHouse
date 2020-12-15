import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity/connectivity.dart';

class ConnectionStatusSingleton {
    //Esto crea la instancia única llamando al constructor ``_internal`` especificado abajo
    static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
    ConnectionStatusSingleton._internal();

    //Esto es lo que se utiliza para recuperar la instancia a través de la aplicación
    static ConnectionStatusSingleton getInstance() => _singleton;

    //Esto rastrea el estado actual de la conexión
    bool hasConnection = false;

    //Así es como permitiremos suscribirse a los cambios de conexión
    StreamController connectionChangeController = new StreamController.broadcast();

    //flutter_connectivity
    final Connectivity _connectivity = Connectivity();

    //Engancharse a la corriente de flutter_connectivity para escuchar los cambios
    //Y comprueba el estado de la conexión fuera de la puerta
    void initialize() {
        _connectivity.onConnectivityChanged.listen(_connectionChange);
        checkConnection();
    }

    Stream get connectionChange => connectionChangeController.stream;

    //Un método de limpieza para cerrar nuestro StreamController
    //Debido a que esto está destinado a existir a lo largo de todo el ciclo de vida de la aplicación
    void dispose() {
        connectionChangeController.close();
    }

    //El oyente de flutter_connectivity
    void _connectionChange(ConnectivityResult result) {
        checkConnection();
    }

    //La prueba para ver realmente si hay una conexión
    Future<bool> checkConnection() async {
        bool previousConnection = hasConnection;

        try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                hasConnection = true;
            } else {
                hasConnection = false;
            }
        } on SocketException catch(_) {
            hasConnection = false;
        }

        //El estado de la conexión cambió enviar una actualización a todos los oyentes
        if (previousConnection != hasConnection) {
            connectionChangeController.add(hasConnection);
        }

        return hasConnection;
    }
}