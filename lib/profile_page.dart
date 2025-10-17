import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _fullName = 'User';
  String _username = '';
  String _phone = '';
  String _instagram = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    // keys: adjust if your login stores under different keys
    final fullName = prefs.getString('fullName') ?? prefs.getString('name') ?? prefs.getString('email') ?? 'User';
    final username = prefs.getString('username') ?? prefs.getString('email') ?? '';
    final phone = prefs.getString('phone') ?? '';
    final instagram = prefs.getString('instagram') ?? '';
    final email = prefs.getString('email') ?? '';

    if (mounted) {
      setState(() {
        _fullName = fullName;
        _username = username;
        _phone = phone;
        _instagram = instagram;
        _email = email;
      });
    }
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle.isNotEmpty ? subtitle : 'Belum diisi'),
        trailing: onTap != null ? IconButton(icon: const Icon(Icons.edit, color: Colors.purple), onPressed: onTap) : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // background yang putih bersih seperti contoh
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black87),
        title: const Text('Profil', style: TextStyle(color: Colors.black87)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header gradient + avatar
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF8A3FFC), Color(0xFF6A1BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.purple.shade100,
                          child: const Icon(Icons.person, size: 44, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _fullName,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _username.isNotEmpty ? _username : '',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 86), // ruang agar tidak menutupi avatar

            // info list
            _buildInfoTile(Icons.person_outline, 'Akun', _username.isNotEmpty ? _username : 'Tidak ada', onTap: () {
              // edit akun
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit akun belum diimplementasi')));
            }),
            _buildInfoTile(Icons.cake_outlined, 'Birthday', 'Belum diisi', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit birthday belum diimplementasi')));
            }),
            _buildInfoTile(Icons.smartphone_outlined, 'Telepon', _phone.isNotEmpty ? _phone : 'Belum diisi', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit telepon belum diimplementasi')));
            }),
            _buildInfoTile(Icons.camera_alt_outlined, 'Instagram', _instagram.isNotEmpty ? _instagram : 'Belum diisi', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit Instagram belum diimplementasi')));
            }),
            _buildInfoTile(Icons.email_outlined, 'Email', _email.isNotEmpty ? _email : 'Belum diisi', onTap: null),
            _buildInfoTile(Icons.remove_red_eye_outlined, 'Password', 'Ganti password', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ganti password belum diimplementasi')));
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}