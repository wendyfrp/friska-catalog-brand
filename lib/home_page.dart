import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detail_baju_page.dart';
import 'login_page.dart';
import 'models/baju_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _username;

  final List<BajuModel> menuBaju = [
    BajuModel(
      nama: "Kemeja",
      deskripsi: "Cocok untuk kerja dan formal",
      color: const Color(0xFF90CAF9),
      icon: Icons.checkroom,
      foto: "assets/kemeja.png",
    ),
    BajuModel(
      nama: "Kaos",
      deskripsi: "Santai dan nyaman",
      color: const Color(0xFFFFF59D),
      icon: Icons.emoji_people,
      foto: "assets/kaos.png",
    ),
    BajuModel(
      nama: "Celana Jeans",
      deskripsi: "Kasual dan tahan lama",
      color: const Color(0xFFA5D6A7),
      icon: Icons.shopping_bag,
      foto: "assets/jeans.png",
    ),
    BajuModel(
      nama: "Jaket",
      deskripsi: "Hangat dan stylish",
      color: const Color(0xFFFFAB91),
      icon: Icons.wb_cloudy,
      foto: "assets/jaket.png",
    ),
    BajuModel(
      nama: "Dress",
      deskripsi: "Untuk acara spesial",
      color: const Color(0xFFCE93D8),
      icon: Icons.style,
      foto: "assets/dress.png",
    ),
  ];

  // search controller & current query
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('email') ?? 'User';
    });
  }

  // helper to replace deprecated withOpacity
  Color _alpha(Color c, double opacity) =>
      c.withAlpha((opacity * 255).round());

  @override
  Widget build(BuildContext context) {
    // filtered list based on current search query
    final List<BajuModel> filteredMenu = _searchQuery.trim().isEmpty
        ? menuBaju
        : menuBaju.where((b) {
            final q = _searchQuery.toLowerCase();
            return b.nama.toLowerCase().contains(q) ||
                b.deskripsi.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      // transparent AppBar so gradient shows behind
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Friska Brand Catalog",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2E86FF),
              Color(0xFF42A5F5),
              Color(0xFF8E44AD),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // store dashboard
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B66C3),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _alpha(const Color(0xFF0B66C3), 0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.store, color: Colors.white, size: 40),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "Alamat Toko",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Jl. Mawar No. 123, Bandung",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            // optional: open map or edit
                          },
                          icon: const Icon(Icons.location_on_outlined, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                // greeting + avatar + search
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: const Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang, ${_username ?? ''}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "Pilih koleksi terbaik untukmu",
                              style: TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
                  child: Material(
                    color: Colors.white.withOpacity(0.15),
                    elevation: 0,
                    borderRadius: BorderRadius.circular(14),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Cari baju, contoh: kemeja",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white70),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ),

                // section header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Row(
                    children: const [
                      Text(
                        "Menu Pilihan Catalog Baju",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [Shadow(color: Colors.black26, blurRadius: 6)],
                        ),
                      ),
                      SizedBox(width: 8),
                      // small accent
                    ],
                  ),
                ),

                // list items
                ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredMenu.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = filteredMenu[index];
                    return Material(
                      color: Colors.white,
                      elevation: 6,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Anda memilih ${item.nama}'),
                              backgroundColor: item.color,
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: item.color,
                                radius: 30,
                                child: Icon(item.icon, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nama,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      item.deskripsi,
                                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.info_outline, color: item.color, size: 26),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailBajuPage(item: {
                                        "nama": item.nama,
                                        "deskripsi": item.deskripsi,
                                        "color": item.color,
                                        "icon": item.icon,
                                        "foto": item.foto,
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
