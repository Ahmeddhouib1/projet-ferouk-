import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final List<Map<String, dynamic>> brandLinks = const [
    {
      'brand': 'Reflexx',
      'facebook': 'https://www.facebook.com/profile.php?id=100075902679138',
      'instagram': 'https://www.instagram.com/reflexx_tn/?hl=fr',
      'logo': 'assets/images/reflexx.png',
    },
    {
      'brand': 'Le Moulin',
      'facebook': 'https://www.facebook.com/chamialemoulin',
      'instagram': 'https://www.instagram.com/chamia_lemoulin/',
      'logo': 'assets/images/moulin.png',
    },
    {
      'brand': 'Florida',
      'facebook': 'https://www.facebook.com/profile.php?id=100063752253628#',
      'instagram': 'https://www.instagram.com/floridatunisie/?hl=fr',
      'logo': 'assets/images/florida.png',
    },
    {
      'brand': 'Ballon',
      'facebook': 'https://www.facebook.com/bonbonsballon/',
      'instagram': 'https://www.instagram.com/ballontunisie/?hl=fr',
      'logo': 'assets/images/ballon.png',
    },
  ];

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final messageCtrl = TextEditingController();

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Impossible d’ouvrir le lien $url';
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 10),
            Text("Message envoyé"),
          ],
        ),
        content: const Text("Merci pour votre message ! Nous vous répondrons très vite."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.16:5263:5263/api/email'), // ✅ API .NET
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': nameCtrl.text,
        'email': emailCtrl.text,
        'message': messageCtrl.text,
      }),
    );

    if (response.statusCode == 200) {
      await _showSuccessDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message envoyé avec succès')),
      );
      nameCtrl.clear();
      emailCtrl.clear();
      messageCtrl.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'envoi : ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Réseaux sociaux par marque",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...brandLinks.map((brand) => Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.symmetric(vertical: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Image.asset(brand['logo'], height: 50),
                        const SizedBox(width: 16),
                        Text(
                          brand['brand'],
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.facebook, color: Colors.blue, size: 30),
                          onPressed: () => _launchUrl(brand['facebook']),
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.purple, size: 30),
                          onPressed: () => _launchUrl(brand['instagram']),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),

        const Divider(thickness: 1.5, height: 40),
        const Text(
          "Contactez-nous",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF9F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildField("Nom et Prénom", nameCtrl),
              const SizedBox(height: 16),
              _buildField("Email", emailCtrl),
              const SizedBox(height: 16),
              _buildField("Message", messageCtrl, maxLines: 5),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _sendMessage,
                child: const Text("Valider", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
