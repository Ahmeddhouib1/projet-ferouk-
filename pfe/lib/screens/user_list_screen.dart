import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListScreen extends StatefulWidget {
  final String role;
  const UserListScreen({super.key, required this.role});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.1.16:5263/api/user/role/${widget.role}'));
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur chargement utilisateurs")),
      );
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('http://192.168.1.16:5263/api/user/$id'));
    if (response.statusCode == 204) {
      setState(() {
        users.removeWhere((u) => u['id'] == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur suppression utilisateur")),
      );
    }
  }

  void showEditDialog(Map user) {
    TextEditingController nameController = TextEditingController(text: user['username']);
    TextEditingController phoneController = TextEditingController(text: user['phone'] ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Modifier Utilisateur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: 'Nom')),
            TextField(controller: phoneController, decoration: InputDecoration(labelText: 'Téléphone')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedUser = {
                "id": user['id'],
                "username": nameController.text,
                "role": user['role'],
                "phone": phoneController.text
              };
              final response = await http.put(
                Uri.parse('http://192.168.1.16:5263/api/user/${user['id']}'),
                headers: {'Content-Type': 'application/json'},
                body: json.encode(updatedUser),
              );
              if (response.statusCode == 204) {
                Navigator.pop(context);
                fetchUsers();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Erreur modification utilisateur")),
                );
              }
            },
            child: Text("Enregistrer"),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Annuler")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des ${widget.role}s"),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user['username']),
                  subtitle: Text(user['phone'] ?? 'Aucun téléphone'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => showEditDialog(user),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteUser(user['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
