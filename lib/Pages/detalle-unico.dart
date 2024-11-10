import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pedidos_app/Models/Pedido.dart';
import 'package:pedidos_app/Servicios/pedidos-service.dart';
import 'package:intl/intl.dart';

class DetalleUnicoPage extends StatelessWidget {
  final Pedido pedido;
  final PedidoService pedidoService = PedidoService();

  DetalleUnicoPage({super.key, required this.pedido});

  Future<List<String>> _obtenerIngredientesProducto(List<dynamic> referencias) async {
    try {
      return await pedidoService.obtenerIngredientes(referencias.cast<DocumentReference>());
    } catch (e) {
      print('Error al obtener ingredientes: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {

//configuracion de la fecha y la hora
    String pedidoFecha = '';
    String pedidoHora = '';

      DateTime fechaPedido = pedido.fecha;
      pedidoFecha = DateFormat('dd/MM/yyyy').format(fechaPedido); 
      pedidoHora = DateFormat('HH:mm').format(fechaPedido);

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
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(110, 68, 56, 1),
                              ),
                            ),
                            children: [
                              // Contenedor para los detalles del producto
                              //me sacó dolores de cabeza.
                              Container(
                                color: const Color.fromRGBO(252, 231, 207, 1),
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Detalles del producto',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(110, 68, 56, 1)),
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
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromRGBO(110, 68, 56, 1)),
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
                                      child: ingredientes.isEmpty
                                          ? const Text('No hay ingredientes disponibles')
                                          : Column(
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
                                                    ),
                                                  )
                                              ],
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
            
            // Contenedor en la parte inferior
            Container(
              width: double.infinity, // Ocupará todo el ancho
              color: const Color.fromRGBO(252, 231, 207, 1), // Color de fondo
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  Text(
                    'Fecha: $pedidoFecha',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(110, 68, 56, 1),
                    ),
                  ),
                  Text(
                    'Hora: $pedidoHora',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(110, 68, 56, 1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total: ${pedido.total}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(110, 68, 56, 1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
