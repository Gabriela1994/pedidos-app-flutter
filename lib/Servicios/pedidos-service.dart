import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pedidos_app/Models/Pedido.dart';

class PedidoService {
  final CollectionReference pedidosCollection = FirebaseFirestore.instance.collection('Pedidos');

  Future<void> guardarPedido(Pedido pedido) async {
    try {
      await pedidosCollection.doc(pedido.id).set(pedido.toMap());
      print("Pedido guardado con éxito");
    } catch (e) {
      print("Error al guardar el pedido: $e");
    }
  }


  Future<List<Pedido>> fetchPedidos() async {
    try {
      final querySnapshot = await pedidosCollection.get();
      return querySnapshot.docs.map((doc) {
        return Pedido.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error al obtener pedidos: $e");
      return [];
    }
  }

  Future<List<String>> obtenerIngredientes(List<DocumentReference> referencias) async {
    List<String> ingredientes = [];
    for (var ref in referencias) {
      DocumentSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        ingredientes.add(snapshot['nombre']);
      }
    }
    return ingredientes;
  }
}