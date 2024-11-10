import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_app/Models/productos.dart';

class ProductService {
  final CollectionReference _productCollection =
      FirebaseFirestore.instance.collection('Productos');


  Future<List<Producto>> fetchProducts() async {
    try {
      final querySnapshot = await _productCollection.get();
      return querySnapshot.docs.map((doc) {
        return Producto.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error al obtener productos: $e");
      return [];
    }
  }

 Future<Producto> fetchProduct(String productId) async {
    final doc = await _productCollection.doc(productId).get();
    return Producto.fromFirestore(doc.data() as Map<String, dynamic>);
  }

}