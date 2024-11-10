import 'package:flutter/material.dart';
import 'package:pedidos_app/Pages/CrearPage.dart';
import 'package:pedidos_app/Pages/historial-pedidos.dart';
import 'package:pedidos_app/Pages/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

void _navigateToScreen(int index) {
    Widget screen;

    switch (index) {
      case 0:
        screen = const MainScreen();
        break;
      case 1:
        screen = const Crearpage(title: 'Crear',);
        break;
      case 2:
        screen = ListaPedidosPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }


@override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Bienvenido"),
    ),
    body: Container(
      width: double.infinity, // Ancho completo
      height: double.infinity, // Alto completo
      decoration: const BoxDecoration(
        image: DecorationImage(
          image:
            AssetImage('assets/bienvenida.png'), // URL de tu imagen o usa AssetImage('assets/tu-imagen.jpg') para imágenes locales
          
          fit: BoxFit.cover, // La imagen cubre toda la pantalla
        ),
      ),
child: Column(
          children: [
            const Spacer(), // Empuja el contenido hacia abajo
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Crearpage(title: 'Crear',)),
              );
            },
            icon:const Icon(Icons.add_shopping_cart), // Icono del botón
            label: const Text('Crear Pedido'), // Texto del botón
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Color de fondo del botón
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),
          ],
        ),
    ),
    bottomNavigationBar: BottomNavigationBar(
      onTap: _navigateToScreen,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle),
          label: 'Crear pedido',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.manage_search),
          label: 'Historial',
        ),
      ],
    ),
  );
}
}