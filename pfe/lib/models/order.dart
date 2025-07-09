class OrderItem {
  final String productName;
  final String imageUrl;
  final int quantity;
  final double price;

  OrderItem({
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
    );
  }
}

class Order {
  final int id;
  final List<OrderItem> items;

  Order({required this.id, required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }
}
