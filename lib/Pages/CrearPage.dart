import 'package:flutter/material.dart';
import 'package:pedidos_app/Models/DetalleProducto.dart';
import 'package:pedidos_app/Models/Pedido.dart';
import 'package:pedidos_app/Models/productos.dart';
import 'package:pedidos_app/Pages/detalle-pedido.dart';
import 'package:pedidos_app/Servicios/lista-productos.dart';
import 'package:pedidos_app/Servicios/pedidos-service.dart';
import 'dart:math';

Random random = Random();

class Crearpage extends StatefulWidget {
  const Crearpage({super.key, required this.title});

  final String title;

  @override
  State<Crearpage> createState() => _CrearpageState();
}

class _CrearpageState extends State<Crearpage> {
  final ProductService _productService = ProductService();
  late Future<List<Producto>> _listaProductos;
  List<DetalleProducto> _detalleProductos = [];

  @override
  void initState() {
    super.initState();
    _listaProductos = _productService.fetchProducts().then((productos) {
      _detalleProductos = productos
          .map((producto) => DetalleProducto(producto: producto))
          .toList();
      return productos;
    });
  }

  // Función para incrementar la cantidad del producto
  void _incrementarCantidad(DetalleProducto detalle) {
    setState(() {
      detalle.cantidad++;
    });
  }

  // Función para disminuir la cantidad del producto
  void _bajarCantidad(DetalleProducto detalle) {
    setState(() {
      if (detalle.cantidad > 0) {
        detalle.cantidad--;
      }
    });
  }

  // Función para calcular el total
  double _calcularTotal() {
    double total = 0;
    for (var detalle in _detalleProductos) {
      total += detalle.cantidad * detalle.producto.precio;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea un pedido'),
      ),
      body: Column(
        children: [
          // Lista de productos
          Expanded(
            child: FutureBuilder<List<Producto>>(
              future: _listaProductos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("No hay productos disponibles"));
                } else {
                  return ListView.builder(
                    itemCount: _detalleProductos.length,
                    itemBuilder: (context, index) {
                      final detalle = _detalleProductos[index];
                      final product = detalle.producto;

                      return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                              onTap: () {

                                _muestraDetalleDeProducto(context, product);
                              },
                              child: Row(
                                children: [
                                  Image.network(
                                    product.imagen,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.nombre,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromRGBO(158, 97, 36, 1),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          product.descripcion,
                                          style: const TextStyle(
                                              color: Color.fromRGBO(
                                                  158, 97, 36, 1)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                            '\$${product.precio.toStringAsFixed(2)}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    110, 68, 56, 1))),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () =>
                                                  _bajarCantidad(detalle),
                                              icon: const Icon(Icons.delete,
                                                  color: Color.fromRGBO(
                                                      241, 100, 84, 1)),
                                            ),
                                            Text(
                                              detalle.cantidad.toString(),
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _incrementarCantidad(detalle),
                                              icon: const Icon(Icons.add_circle,
                                                  color: Color.fromRGBO(
                                                      149, 196, 75, 1)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                }
              },
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(110, 68, 56, 1),
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Mostrar el total
                Text(
                  '\$${_calcularTotal().toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 244, 243, 243)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Pedido pedido = Pedido(
                      id: random.nextInt(100).toString(),
                      cliente: "Cliente de prueba",
                      productos: _detalleProductos
                          .where((detalle) => detalle.cantidad > 0)
                          .map((detalle) => {
                                'nombre': detalle.producto.nombre,
                                'cantidad': detalle.cantidad,
                                'precio': detalle.producto.precio,
                                'ingredientes': detalle.producto.ingredientes,
                                'imagen': detalle.producto.imagen,
                              })
                          .toList(),
                      total: _calcularTotal(),
                      fecha: DateTime.now(),
                    );

                    if ((pedido.productos.isEmpty)) {
                        // Muestra un mensaje de error si no hay productos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Debes elegir al menos un producto.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      } else {

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetallePedidoPage(pedido: pedido),
                      ),
                    );
                    setState(() {
                      _detalleProductos
                          .forEach((detalle) => detalle.cantidad = 0);
                    });}
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
                        'Ver carrito',
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
        ],
      ),
    );
  }

  Future<void> _muestraDetalleDeProducto(BuildContext context, Producto product) async {
    PedidoService pedidoService = PedidoService();
    List<String> ingredientes =
        await pedidoService.obtenerIngredientes(product.ingredientes);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.nombre),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(product.descripcion),
              const SizedBox(height: 8),
              const Text('Ingredientes:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              // Mostrar la lista de ingredientes
              product.ingredientes.isEmpty
                  ? const Text('No tiene ingredientes disponibles.')
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredientes.map((ingrediente) {
                        return Text('- $ingrediente');
                      }).toList(),
                    ),
              const SizedBox(height: 8),
              Text('Precio: \$${product.precio.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
