class Product {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final int stock; // ✅ Champ stock ajouté

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.stock, // ✅ Ajouté ici aussi
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'],
      stock: json['stock'] ?? 0, // ✅ Initialisation avec fallback
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'category': category,
        'stock': stock, // ✅ Inclus dans le JSON
      };
}
