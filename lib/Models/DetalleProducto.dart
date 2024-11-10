import 'package:pedidos_app/Models/productos.dart';

class DetalleProducto {
  final Producto producto;
  int cantidad;

  DetalleProducto({required this.producto, this.cantidad = 0});
}