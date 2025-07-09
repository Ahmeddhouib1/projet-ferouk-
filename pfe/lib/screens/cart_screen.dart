import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    final response = await http.get(Uri.parse('http://192.168.1.16:5263/api/cart/$userId'));

    if (response.statusCode == 200) {
      setState(() {
        cartItems = jsonDecode(response.body);
      });
    }
  }

  Future<void> _removeItem(int itemId) async {
    await http.delete(Uri.parse('http://192.168.1.16:5263/api/cart/$itemId'));
    _loadCart();
  }

  Future<void> _clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId') ?? 0;

    await http.delete(Uri.parse('http://192.168.1.16:5263/api/cart/clear/$userId'));
    _loadCart();
  }

  double _calculateTotal() {
    return cartItems.fold(0.0, (sum, item) {
      final price = (item['price'] ?? 0).toDouble();
      final quantity = (item['quantity'] ?? 0).toDouble();
      return sum + price * quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Panier"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearCart,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Image.network(
                      item['productImageUrl'],
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
                    title: Text(item['productName']),
                    subtitle: Text("Quantité : ${item['quantity']} — ${item['price']} DT"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeItem(item['id']),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Total : ${_calculateTotal().toStringAsFixed(2)} DT",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
