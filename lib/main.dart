import 'package:flutter/material.dart';
import 'package:pedidos_app/Models/context.dart';
import 'package:pedidos_app/Pages/material_app.dart';

Future<void> main() async {
Context context = Context();

  // Llamamos al método conectarConFirebase
  await context.conectarConFirebase();
  runApp(const MyApp());
}