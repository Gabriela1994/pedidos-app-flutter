import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_app/Models/ingrediente.dart';

class Producto{

  String nombre;
  int precio;
  String imagen;
  String descripcion;
  bool disponible;
  final List<DocumentReference> ingredientes;
  int cantidad;

  Producto({

    required this.nombre,
    required this.precio,
    required this.imagen,
    required this.descripcion,
    required this.disponible,
    required this.ingredientes,
    this.cantidad = 0
    }
  );
  
    factory Producto.fromFirestore(Map<String, dynamic> data) {
    return Producto(
      nombre: data['nombre'] ?? '',
      precio: data['precio'] ?? 0,
      imagen: data['imagen'] ?? '',
      descripcion: data['descripcion'] ?? '',
      disponible: data['disponible'] ?? true,
      ingredientes: List<DocumentReference>.from(data['Ingredientes']),
      
    );
  }

}