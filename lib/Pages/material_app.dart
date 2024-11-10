import 'package:flutter/material.dart';
import 'package:pedidos_app/Pages/MainScreen.dart';
import 'package:pedidos_app/Pages/home.dart';

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Pedidos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
    ),
    home: MainScreen()
    );
  }
}