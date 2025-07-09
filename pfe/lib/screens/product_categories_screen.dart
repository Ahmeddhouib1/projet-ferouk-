import 'package:flutter/material.dart';

class ProductCategoriesScreen extends StatelessWidget {
  const ProductCategoriesScreen({super.key});

  final List<String> categories = const [
    "Halwa",
    "Chewing-gum",
    "Bubble gum",
    "Pâte à mâcher",
    "Bonbons sucettes",
    "Bonbons Durs",
    "Bonbons compressés",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nos Produits")),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(categories[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Plus tard : Naviguer vers la page spécifique de la catégorie
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Ouverture de ${categories[index]}")),
              );
            },
          );
        },
      ),
    );
  }
}
