import 'package:flutter/material.dart';

import 'about_screen.dart';
import 'cart_screen.dart';
import 'client_product_screen.dart';
import 'career_screen.dart';
import 'login_screen.dart';
import 'media_screen.dart';
import 'private_brand_screen.dart';
import 'recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool openClientTab;
  const HomeScreen({super.key, this.openClientTab = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Tab> tabs = const [
    Tab(text: "Accueil"),
    Tab(text: "A propos"),
    Tab(text: "Produits"),
    Tab(text: "Marque privée"),
    Tab(text: "Média"),
    Tab(text: "Recettes"),
    Tab(text: "Carrière"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
    if (widget.openClientTab) {
      _tabController.index = 2;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[800],
          elevation: 6,
          title: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 36,
              ),
              const SizedBox(width: 10),
              const Text(
                "",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.login),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            labelColor: Colors.blue[800],
            unselectedLabelColor: Colors.white,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _BannerPage(),
            AboutScreen(),
            ClientProductScreen(),
            PrivateBrandScreen(),
            MediaScreen(),
            RecipeScreen(),
            CareerScreen(),
          ],
        ),
      ),
    );
  }
}

class _BannerPage extends StatefulWidget {
  const _BannerPage();

  @override
  State<_BannerPage> createState() => _BannerPageState();
}

class _BannerPageState extends State<_BannerPage> {
  final PageController _controller = PageController();
  final List<String> imagePaths = [
    "assets/images/moulin.png",
    "assets/images/ballon.png",
    "assets/images/reflexx.png",
    "assets/images/florida.png",
  ];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoSlide();
  }

  void _autoSlide() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        currentIndex = (currentIndex + 1) % imagePaths.length;
      });
      _controller.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _autoSlide();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _controller,
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            );
          },
        ),
        Positioned(
          bottom: 40,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(0.5),
            child: const Text(
              "Bienvenue chez Triki – Découvrez nos produits vedettes",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}