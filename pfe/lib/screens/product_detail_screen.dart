import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  final int userId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.userId,
  });

  Future<void> _addToCart(BuildContext context) async {
    try {
      await ApiService.addToCart(userId, product.id, 1);

      // ✅ Si succès, message de confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Produit ajouté au panier")),
      );
    } catch (e) {
      // ❌ Si erreur réelle, message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur ajout panier : $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Column(
        children: [
          Expanded(
            child: Image.network(
              product.imageUrl.startsWith('http')
                  ? product.imageUrl
                  : 'http://192.168.1.16:5263/${product.imageUrl}',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.broken_image, size: 100),
            ),
          ),
          const SizedBox(height: 12),
          Text("${product.price} DT", style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => _addToCart(context),
            child: const Text("Ajouter au panier"),
          ),
        ],
      ),
    );
  }
}
