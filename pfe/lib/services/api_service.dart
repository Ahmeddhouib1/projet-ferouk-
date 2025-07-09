import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pfe/models/order.dart';
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.1.16:5263/api';


static Future<List<Product>> getProducts() async {
  final response = await http.get(Uri.parse('$baseUrl/product'));
  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');
  
  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => Product.fromJson(e)).toList();
  } else {
    throw Exception('Erreur chargement produits: ${response.statusCode}');
  }
}

static Future<void> deleteProduct(int id) async {
  final response = await http.delete(Uri.parse('$baseUrl/product/$id'));

  print('=== SUPPRESSION PRODUIT ===');
  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');

  if (response.statusCode != 204) {
    // Vérifie si le backend a retourné un message d’erreur
    final errorMessage = response.body.contains('utilisé')
        ? "Impossible de supprimer : le produit est utilisé dans une commande ou un panier."
        : "Erreur suppression produit";
    throw Exception(errorMessage);
  }
}



static Future<List<Order>> getOrders(int userId) async {
  final response = await http.get(Uri.parse('$baseUrl/orders/user/$userId'));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    return data.map((e) => Order.fromJson(e)).toList();
  } else {
    throw Exception('Erreur lors du chargement des commandes');
  }
}

  static Future<void> addToCart(int userId, int productId, int quantity) async {
  final response = await http.post(
    Uri.parse('$baseUrl/cart'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
    }),
  );

  print('=== Ajout au Panier ===');
  print('Status code: ${response.statusCode}');
  print('Body: ${response.body}');

  // ✅ Accepter 200, 201 ou 204 comme succès
  if (response.statusCode != 200 &&
      response.statusCode != 201 &&
      response.statusCode != 204) {
    throw Exception('Erreur ajout panier : ${response.body}');
  }
}

}
