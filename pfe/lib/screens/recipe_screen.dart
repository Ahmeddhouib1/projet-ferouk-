import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Nos meilleures recettes à base de nos produits", style: TextStyle(fontSize: 18)),
    );
  }
}
