import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'user_list_screen.dart'; // Assure-toi d'avoir bien importé ce fichier

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int totalClients = 0;
  int totalGrossistes = 0;
  List<dynamic> stockParCategorie = [];
  List<dynamic> ventesParCategorie = [];

  @override
  void initState() {
    super.initState();
    _chargerStatistiques();
  }

  Future<void> _chargerStatistiques() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.16:5263/api/dashboard/stats'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          totalClients = data['totalClients'];
          totalGrossistes = data['totalWholesalers'];
          stockParCategorie = data['stockParCategorie'];
          ventesParCategorie = data['ventesParCategorie'];
        });
      } else {
        _showError("Erreur chargement statistiques");
      }
    } catch (e) {
      _showError("Erreur : ${e.toString()}");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tableau de bord"),
        backgroundColor: Colors.deepPurple,
      ),
      body: RefreshIndicator(
        onRefresh: _chargerStatistiques,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(child: _buildCard("👥 Clients", "$totalClients", Colors.green, () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const UserListScreen(role: "client"),
                  ));
                })),
                const SizedBox(width: 10),
                Expanded(child: _buildCard("🏬 Grossistes", "$totalGrossistes", Colors.orange, () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => const UserListScreen(role: "grossiste"),
                  ));
                })),
              ],
            ),
            const SizedBox(height: 20),
            _buildVentesPieChart(),
            const SizedBox(height: 20),
            const Text(
              "Stock par produit (par catégorie)",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...stockParCategorie.map((cat) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cat['category'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  const SizedBox(height: 4),
                  ...((cat['products'] ?? []) as List).map<Widget>((prod) {
                    double stockPercent = 0;
                    if (prod['initialStock'] > 0) {
                      stockPercent = ((prod['stockDisponible'] ?? 0) / prod['initialStock']) * 100;
                    }
                    return ListTile(
                      title: Text(prod['name']),
                      subtitle: Text(
                          "Initial: ${prod['initialStock']}, En Panier: ${prod['stockInCart']}, Disponible: ${prod['stockDisponible']}"),
                      trailing: Text("${stockPercent.toStringAsFixed(1)}%",
                          style: TextStyle(
                            color: stockPercent < 20 ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          )),
                    );
                  }).toList(),
                  const Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: color.withOpacity(0.1),
        child: ListTile(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(value, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildVentesPieChart() {
    if (ventesParCategorie.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ventes par catégorie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        AspectRatio(
          aspectRatio: 1.4,
          child: PieChart(
            PieChartData(
              sections: ventesParCategorie.map<PieChartSectionData>((cat) {
                final double value = (cat['totalVentes'] as num).toDouble();
                return PieChartSectionData(
                  value: value,
                  title: "${cat['category']}\n${value.toInt()}",
                  radius: 60,
                );
              }).toList(),
              sectionsSpace: 4,
              centerSpaceRadius: 30,
            ),
          ),
        ),
      ],
    );
  }
}
