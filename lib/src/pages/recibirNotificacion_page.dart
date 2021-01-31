import 'package:flutter/material.dart';

class RecibirNotificacionPage extends StatelessWidget {
  const RecibirNotificacionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final data = ModalRoute.of(context).settings.arguments; 

    return Scaffold(
      appBar: AppBar(
        title: Text('Message Page'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}