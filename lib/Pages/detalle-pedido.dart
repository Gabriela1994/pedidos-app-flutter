import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/Models/Pedido.dart';
import 'package:pedidos_app/Pages/MainScreen.dart';
import 'package:pedidos_app/Pages/home.dart';
import 'package:pedidos_app/Servicios/pedidos-service.dart';

class DetallePedidoPage extends StatelessWidget {
  final Pedido pedido;
  final PedidoService pedidoService = PedidoService();

  DetallePedidoPage({required this.pedido});

  Future<List<String>> _obtenerIngredientesProducto(List<dynamic> referencias) async {
    return await pedidoService.obtenerIngredientes(referencias.cast<DocumentReference>());
  }

  Future<void> _guardarPedido() async {
    await pedidoService.guardarPedido(pedido);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Pedido")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: pedido.productos.length,
                itemBuilder: (context, index) {
                  final producto = pedido.productos[index];
                  final ingredientesRef = producto['ingredientes'] as List<dynamic>;

                  return FutureBuilder<List<String>>(
                    future: _obtenerIngredientesProducto(ingredientesRef),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text("Error al cargar ingredientes: ${snapshot.error}");
                      } else {
                        final ingredientes = snapshot.data ?? [];

return Card(
  margin: const EdgeInsets.symmetric(vertical: 8),
  child: ExpansionTile(
title: Row(
    children: [
      // Imagen del producto
      Image.network(
        producto['imagen'],
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      ),
      const SizedBox(width: 16),
      
      // Nombre del producto
      Expanded(
        child: Text(
          producto['nombre'],
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(158, 97, 36, 1),
          ),
        ),
      ),
    ],
  ),
    subtitle: Text('Cantidad: ${producto['cantidad']}'),
    trailing: Text(
      '\$${producto['precio'] * producto['cantidad']}',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(110, 68, 56,1),),
    ),
    children: [
      // Contenedor para los detalles del producto
      Container(
        color: const Color.fromRGBO(252, 231, 207,1), // Fondo gris claro para distinguir el contenido
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del producto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(110, 68, 56,1)),
            ),
            const SizedBox(height: 8),
            // Precio unitario
            Text(
              'Precio unitario: \$${producto['precio']}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            // Ingredientes
            const Text(
              'Ingredientes:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(110, 68, 56,1)),
            ),
            const SizedBox(height: 4),
            // Lista de ingredientes
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var ingrediente in ingredientes)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ingrediente,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ))]))]))]));
                      }
                    },
                  );
                },
              ),
            ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(110, 68, 56, 1),
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: \$${pedido.total}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 244, 243, 243)),
                  //shopping_cart
                ),
                ElevatedButton(
                  onPressed: () async {
                      if (pedido.productos.isEmpty) {
                        // Muestra un mensaje de error si no hay productos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se puede guardar el pedido. No hay productos en el pedido.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                  _guardarPedido();
                    
                    // muestro mensaje de confirmacion
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Pedido guardado con éxito',
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:(context) => MainScreen(),
                      ),
                    );
                      }
                  },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Realizar pedido',
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 192, 29, 29)),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_circle_right,
                        color: Color.fromARGB(255, 192, 29, 29),
                        size: 24,
                      ),
                    ],
                    
                  ),
                )
          ],
        ),
      ),
          ]))
    );
  }
}
