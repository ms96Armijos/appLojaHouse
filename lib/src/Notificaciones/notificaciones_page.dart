import 'package:applojahouse/src/models/message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificacionPage extends StatefulWidget {
  NotificacionPage({Key key}) : super(key: key);

  @override
  _NotificacionPageState createState() => _NotificacionPageState();
}

class _NotificacionPageState extends State<NotificacionPage> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final List<Message> messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async{
        print('onMessage: $message');

        final notification = message['notification'];
        setState(() {
          messages.add(
            Message(
            body: notification['body'], 
            title: notification['title']
            ));
        });
      },
      onLaunch: (Map<String, dynamic> message) async{
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async{
        print('onResume: $message');
      }
    );

    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       child: ListView(
         children: 
           messages.map(construirMensaje).toList())
    );
  }

  construirMensaje(Message message){
    return ListTile(
      title: Text(message.title),
      subtitle: Text(message.body),
    );
  }
}
