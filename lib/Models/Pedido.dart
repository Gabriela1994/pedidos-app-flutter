import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  
  String id;
  String cliente;
  List<Map<String, dynamic>> productos;
  double total;
  DateTime fecha;

  Pedido({
    required this.id,
    required this.cliente,
    required this.productos,
    required this.total,
    required this.fecha,
  });
    
  // Convertir el pedido a un mapa para Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente': cliente,
      'productos': productos,
      'total': total,
      'fecha': fecha,
    };
    }

    factory Pedido.fromFirestore(Map<String, dynamic> data) {
    return Pedido(
      id: data['id'] ?? '',
      cliente: data['cliente'] ?? '',
      total: data['total'] ?? 0,
      fecha: (data['fecha'] as Timestamp).toDate(),
    productos: (data['productos'] as List<dynamic>? ?? [])
        .map((item) => item as Map<String, dynamic>)
        .toList(),
    );
}
}