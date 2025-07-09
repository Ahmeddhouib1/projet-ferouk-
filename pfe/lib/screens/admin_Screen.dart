import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../services/api_service.dart';
import 'login_screen.dart';
import 'admin_dashboard_screen.dart'; // ✅ Ajout import

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final stockCtrl = TextEditingController();
  String selectedCategory = 'Halwa';
  File? selectedImage;
  final _picker = ImagePicker();
  List<Product> products = [];
  int? editingId;
  bool showForm = false;

  final List<String> categories = [
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

  Future<void> _loadProducts() async {
    final list = await ApiService.getProducts();
    setState(() => products = list);
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  Future<void> _submitProduct() async {
    final uri = editingId == null
        ? Uri.parse('http://192.168.1.16:5263/api/product/upload')
        : Uri.parse('http://192.168.1.16:5263/api/product/$editingId');

    final request =
        http.MultipartRequest(editingId == null ? 'POST' : 'PUT', uri);

    request.fields['name'] = nameCtrl.text;
    request.fields['description'] = descCtrl.text;
    request.fields['price'] = priceCtrl.text;
    request.fields['category'] = selectedCategory;
    request.fields['stock'] = stockCtrl.text;

    if (selectedImage != null) {
      final stream = http.ByteStream(selectedImage!.openRead());
      final length = await selectedImage!.length();
      final fileName = basename(selectedImage!.path);
      request.files.add(
        http.MultipartFile('image', stream, length, filename: fileName),
      );
    }

    try {
      final response = await request.send();
      if (response.statusCode == 201 || response.statusCode == 204) {
        _clearForm();
        _loadProducts();
      }
    } catch (e) {
      debugPrint("Erreur réseau : $e");
    }
  }

  void _clearForm() {
    nameCtrl.clear();
    descCtrl.clear();
    priceCtrl.clear();
    stockCtrl.clear();
    selectedCategory = 'Halwa';
    selectedImage = null;
    editingId = null;
    setState(() => showForm = false);
  }

  void _editProduct(Product p) {
    setState(() {
      showForm = true;
      editingId = p.id;
      nameCtrl.text = p.name;
      descCtrl.text = p.description;
      priceCtrl.text = p.price.toString();
      stockCtrl.text = p.stock.toString();
      selectedCategory = p.category;
      selectedImage = null;
    });
  }

  Future<void> _deleteProduct(int id) async {
    await ApiService.deleteProduct(id);
    _loadProducts();
  }

  Widget _buildProductCard(Product p) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (p.imageUrl.isNotEmpty)
            Image.network(
              p.imageUrl.startsWith('http')
                  ? p.imageUrl
                  :'http://192.168.1.16:5263/${p.imageUrl}',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ListTile(
            title: Text(p.name),
            subtitle: Text("${p.price} DT – ${p.category}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editProduct(p),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteProduct(p.id),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Card(
      color: Colors.white.withOpacity(0.95),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nom')),
            TextFormField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
            TextFormField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Prix')),
            TextFormField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock')),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) => setState(() => selectedCategory = val!),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Choisir une image"),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: _submitProduct,
                child: Text(editingId == null ? "Ajouter" : "Modifier")),
            if (editingId != null)
              TextButton(onPressed: _clearForm, child: const Text("Annuler"))
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Produits"),
        actions: [
          IconButton(
            icon: const Icon(Icons.dashboard), // ✅ Bouton dashboard
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() => showForm = !showForm),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (showForm) _buildForm(),
            ...products.map(_buildProductCard).toList(),
          ],
        ),
      ),
    );
  }
}
