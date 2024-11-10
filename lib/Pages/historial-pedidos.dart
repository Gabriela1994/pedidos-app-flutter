import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pedidos_app/Models/Pedido.dart';
import 'package:pedidos_app/Pages/detalle-unico.dart';
import 'package:pedidos_app/Servicios/pedidos-service.dart';

class ListaPedidosPage extends StatelessWidget {
  // Servicio de Firebase que obtiene la lista de pedidos
  PedidoService pedidoService = PedidoService();

  ListaPedidosPage({super.key});

  String _formateoFecha(DateTime fecha){
    //configuracion de la fecha y la hora
    String pedidoFecha = '';
      return pedidoFecha = DateFormat('dd/MM/yyyy').format(fecha);
  }

  @override
  Widget build(BuildContext context) {
    // Obtener la fecha de hoy
    String todayDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial de Pedidos"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contenedor con el título y la fecha de hoy
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity, // Esto asegura que el contenedor ocupe el 100% del ancho
            color: const Color.fromARGB(255, 96, 2, 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Historial de pedidos",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Fecha: $todayDate",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16), // Espacio entre el contenedor y la lista
          
          // FutureBuilder para cargar los pedidos
          Expanded(
            child: FutureBuilder<List<Pedido>>(
              future: pedidoService.fetchPedidos(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error al cargar pedidos: ${snapshot.error}"),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No hay pedidos disponibles."),
                  );
                } else {
                  final pedidos = snapshot.data!;
                  return ListView.builder(
                    itemCount: pedidos.length,
                    itemBuilder: (context, index) {
                      final pedido = pedidos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cliente: ${pedido.cliente}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Fecha: ${_formateoFecha(pedido.fecha)}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Total: \$${pedido.total.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  // Navegar a una página de detalles del pedido
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetalleUnicoPage(pedido: pedido),
                                    ),
                                  );
                                },
                                child: const Text("Ver Detalles"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}