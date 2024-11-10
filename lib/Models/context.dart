import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Context {
//Aca usé el patron de diseño singleton para tener solo una instancia de esta clase.
  static final Context _instance = Context._internal();

  String appId = "1:832193871385:android:c3592a1e36a36453dfb488";
  String apiKey = "AIzaSyDhHxVWfeCYBpPa_JBLR7Hdu9dKq8RLPJ4";
  String projectId = "proyecto-pedidos-637d7";
  String messagingSenderId = "832193871385";

   Context._internal();

  factory Context() {
    return _instance;
  }

  Future<void> conectarConFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();

    print('Obteniendo datos...');

    await Firebase.initializeApp(
      options: FirebaseOptions(
        appId: appId,
        apiKey: apiKey,
        projectId: projectId,
        messagingSenderId: messagingSenderId,
      ),
    );

    print('Conectado a Firebase');
  }
}
