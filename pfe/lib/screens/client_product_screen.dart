import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import 'product_detail_screen.dart';

class ClientProductScreen extends StatefulWidget {
  const ClientProductScreen({super.key});

  @override
  State<ClientProductScreen> createState() => _ClientProductScreenState();
}

class _ClientProductScreenState extends State<ClientProductScreen> {
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  String selectedCategory = 'Tous';
  String searchTerm = '';

  final List<String> categories = [
    'Tous',
    'Halwa',
    'Chewing-gum',
    'Bonbons',
    'Bubble gum',
    'Pâte à mâcher',
    'Bonbons durs',
    'Bonbons sucettes',
    'Bonbons compressés',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final list = await ApiService.getProducts();
    setState(() {
      allProducts = list;
      _filterProducts();
    });
  }

  void _filterProducts() {
    setState(() {
      filteredProducts = allProducts.where((p) {
        final matchCategory =
            selectedCategory == 'Tous' || p.category == selectedCategory;
        final matchSearch =
            p.name.toLowerCase().contains(searchTerm.toLowerCase());
        return matchCategory && matchSearch;
      }).toList();
    });
  }

  Future<int> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Rechercher...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (val) {
                    setState(() {
                      searchTerm = val;
                      _filterProducts();
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedCategory = val!;
                    _filterProducts();
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final p = filteredProducts[index];
              return GestureDetector(
                onTap: () async {
                  final userId = await _getUserId();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailScreen(
                        product: p,
                        userId: userId,
                      ),
                    ),
                  );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        p.imageUrl.startsWith('http')
                            ? p.imageUrl
                            : 'http://192.168.1.16:5263/${p.imageUrl}',
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image),
                      ),
                      ListTile(
                        title: Text(p.name),
                        subtitle: Text("${p.price} DT – ${p.category}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
