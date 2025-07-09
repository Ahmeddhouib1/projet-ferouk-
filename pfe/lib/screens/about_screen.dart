import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCardContent(String text, {TextAlign align = TextAlign.justify}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        textAlign: align,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildSectionTitle("Fondateur : Mr. Ahmed TRIKI"),
          const Text(
            "« Un grand homme qui a dessiné l’avenir de la confiserie en Tunisie »",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _buildCardContent(
            "Feu Mr. Ahmed Triki était connu de tous par sa générosité, sa loyauté et sa bonté d’âme.\n\n"
            "Derrière ce personnage imposant rigueur et ponctualité, se cachait bonté et droiture d’un grand Homme d’affaires dont le souci premier était l’assurance du bien-être de ses employés.\n\n"
            "Feu Mr. Ahmed Triki s’est engagé dans plusieurs domaines avant de prendre le chemin de la confiserie pour y exceller.\n\n"
            "La notoriété du groupement TRIKI nous la devons à la grandeur de cet homme.",
          ),

          _buildSectionTitle("LA CONFISERIE TRIKI LE MOULIN"),
          _buildCardContent(
            "Fondée en 1948 par feu Ahmed Triki, LA CONFISERIE TRIKI LE MOULIN (CTM) a réussi à se positionner au premier rang des entreprises du secteur en Afrique du Nord et à introduire ses produits sur le marché du Moyen Orient, de l’Amérique, de l’Afrique et de l’Europe.\n\n"
            "Avec une technologie très avancée et une approche orientée marché, la société a été propulsée vers une croissance constante à deux chiffres.\n\n"
            "La philosophie axée sur la marque est la clé de notre entreprise. Nos marques Le Moulin (Halva), Florida (Chewing-gum) et Ballon (Bubble gum) sont leaders sur nos marchés nationaux : La Tunisie et les pays voisins d’Afrique du Nord.\n\n"
            "La Confiserie TRIKI est l’une des rares entreprises du monde de la confiserie à disposer de multi technologies avec une grande variété d’emballages. Le fait d’être née dans un petit pays comme la Tunisie, avec une faible population, oblige la CTM à avoir des produits différents et c’est son meilleur atout pour le marché international.\n\n"
            "Avec un lieu de travail épanouissant et une utilisation efficace de nos ressources, tout le personnel de Triki est très fier d’appartenir à l’entreprise et cela renforce son intégrité au travail.",
          ),

          _buildSectionTitle("Notre Mission"),
          _buildCardContent(
            "➤ Offrir à nos clients : des produits innovants et un service exceptionnel.\n"
            "➤ Offrir à nos employés : un milieu de travail agréable avec une ambiance saine et motivante.\n"
            "➤ Offrir à nos associés : un retour satisfaisant.",
            align: TextAlign.center,
          ),

          _buildSectionTitle("Notre Vision"),
          _buildCardContent(
            "Dans un contexte évolutif, nous voulons être leader en Tunisie et en Afrique et devenir une entreprise de référence internationale en confiserie.",
          ),

          _buildSectionTitle("Nos Valeurs"),
          _buildCardContent(
            "À l’externe comme à l’interne, par souci d’optimisation de nos ressources humaines et matérielles, nous basons nos relations sur :\n\n"
            "➤ La transparence.\n"
            "➤ La solidarité.\n"
            "➤ L’ouverture.\n"
            "➤ La confiance.",
            align: TextAlign.center,
          ),

          const SizedBox(height: 40),
          Image.asset(
            'assets/images/auth1.png', // à créer/importer dans assets
            height: 80,
          ),
          const SizedBox(height: 12),
          const Text(
            "© 2023 The Website - All Rights Reserved",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
