// lib/main_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

// Ganti dengan path file yang sesuai di proyek Anda
import 'login_page.dart';
import 'models/product_model.dart';
import 'providers/cart_provider.dart';
import 'voucher_page.dart';
import 'wallet_page.dart';
import 'profile_page.dart';
import 'cart_page.dart';
import 'product_detail_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _bottomNavIndex = 0;

  final List<Widget> _pages = [
    const HomePageContent(),
    const VoucherPage(),
    const WalletPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _pages[_bottomNavIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: SizedBox(
        height: 40,
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Cari produk...',
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: [
        Consumer<CartProvider>(
          builder: (context, cart, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartPage()),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black54),
                ),
                if (cart.itemCount > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        cart.itemCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined, color: Colors.black54)),
        IconButton(onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.black54), tooltip: 'Logout'),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _bottomNavIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.teal,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), activeIcon: Icon(Icons.confirmation_number), label: 'Voucher'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), activeIcon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  String _selectedCategory = "All";
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..loadRequest(Uri.parse('https://www.adidas.co.id'));
    }
  }

  final List<Product> _allProducts = [
    Product(
      imageUrl: 'assets/kemeja.png',
      category: 'Shirt',
      title: "Kemeja Lengan Panjang",
      rating: 4.9,
      reviews: "2.3k",
      price: 22.50,
      description: 'Kemeja flanel lengan panjang dengan bahan katun premium yang lembut dan nyaman. Desain kotak-kotak klasik yang cocok untuk gaya kasual maupun semi-formal. Tersedia dalam ukuran S, M, L, XL.',
    ),
    Product(
      imageUrl: 'assets/kaos.png',
      category: 'T-Shirt',
      title: "Kaos Polos Katun",
      rating: 4.8,
      reviews: "1.8k",
      price: 9.50,
      isFavorited: true,
      description: 'Kaos polos basic dengan bahan 100% cotton combed 30s yang adem dan menyerap keringat. Jahitan rapi dan kuat, cocok untuk dipakai sehari-hari atau sebagai dalaman.',
    ),
    Product(
      imageUrl: 'assets/jaket.png',
      category: 'Jacket',
      title: "Jaket Windbreaker",
      rating: 4.7,
      reviews: "1.1k",
      price: 35.00,
      description: 'Jaket windbreaker anti-angin dan anti-air (water-repellent) yang ringan. Dilengkapi hoodie dan saku ritsleting untuk fungsionalitas maksimal saat beraktivitas di luar ruangan.',
    ),
    Product(
      imageUrl: 'assets/dress.png',
      category: 'Dress',
      title: "Summer Midi Dress",
      rating: 4.9,
      reviews: "3.1k",
      price: 42.00,
      description: 'Dress midi berbahan rayon ringan dengan motif bunga yang cerah. Potongan A-line yang flowy memberikan kenyamanan saat cuaca panas. Sempurna untuk liburan atau acara santai.',
    ),
    Product(
      imageUrl: 'assets/jeans.png',
      category: 'Pants',
      title: "Celana Jeans Slim-Fit",
      rating: 5.0,
      reviews: "4.2k",
      price: 38.00,
      description: 'Celana jeans pria dengan potongan slim-fit modern. Terbuat dari bahan denim stretch berkualitas tinggi yang memberikan fleksibilitas dan kenyamanan bergerak sepanjang hari.',
    ),
    Product(
      imageUrl: 'assets/kaos1.png',
      category: 'T-Shirt',
      title: "Kaos Sablon Grafis",
      rating: 4.6,
      reviews: "950",
      price: 15.00,
      description: 'Tampil beda dengan kaos sablon grafis eksklusif. Menggunakan tinta plastisol berkualitas yang tahan lama dan tidak mudah pecah. Bahan katun yang sejuk dan nyaman.',
    ),
  ];

  List<String> get _categories => ["All", ..._allProducts.map((p) => p.category).toSet().toList()];
  List<Product> get _filteredProducts => _selectedCategory == "All" ? _allProducts : _allProducts.where((p) => p.category == _selectedCategory).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPromoBanner(),
          const SizedBox(height: 24),
          _buildSectionHeader("Kategori", () {}),
          const SizedBox(height: 12),
          _buildCategoryFilters(),
          const SizedBox(height: 24),
          _buildSectionHeader("Produk Terlaris", () {}),
          const SizedBox(height: 16),
          _buildProductGrid(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.asset(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey)),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => setState(() => product.isFavorited = !product.isFavorited),
                  child: Icon(product.isFavorited ? Icons.favorite : Icons.favorite_border, color: product.isFavorited ? Colors.red : Colors.grey.shade700),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(product.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text('${product.rating} | ${product.reviews}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Rp ${product.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal)),
              GestureDetector(
                onTap: () {
                  cart.add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product.title} ditambahkan!'),
                      duration: const Duration(seconds: 1),
                      backgroundColor: Colors.teal,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    final Uri promoUri = Uri.parse('https://www.adidas.co.id');

    if (kIsWeb) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: SizedBox(
          height: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: GestureDetector(
              onTap: () async {
                if (!await launchUrl(promoUri, mode: LaunchMode.externalApplication)) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tidak bisa membuka link promo')));
                }
              },
              child: Image.asset(
                'assets/promo.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.campaign_outlined, size: 36, color: Colors.black38),
                      SizedBox(height: 8),
                      Text('Promo', style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SizedBox(
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: _controller == null
              ? Container(color: Colors.grey.shade200)
              : WebViewWidget(controller: _controller!),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeMore) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(onPressed: onSeeMore, child: const Text('Lihat semua', style: TextStyle(color: Colors.teal))),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) setState(() => _selectedCategory = category);
            },
            backgroundColor: Colors.grey[200],
            selectedColor: Colors.teal,
            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.teal : Colors.grey.shade300)),
            showCheckmark: false,
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: _filteredProducts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.60,
      ),
      itemBuilder: (context, index) => _buildProductCard(_filteredProducts[index]),
    );
  }
}