import 'package:flutter/material.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final List<Map<String, String>> _cards = [
    {'brand': 'Mastercard', 'last4': '1211'},
    {'brand': 'Visa', 'last4': '0772'},
    {'brand': 'Mastercard', 'last4': '8899'},
  ];

  Future<void> _showAddCardDialog() async {
    final brandCtrl = TextEditingController();
    final last4Ctrl = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Card'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: brandCtrl, decoration: const InputDecoration(labelText: 'Brand (e.g. Visa)')),
            TextField(
              controller: last4Ctrl,
              decoration: const InputDecoration(labelText: 'Last 4 digits'),
              keyboardType: TextInputType.number,
              maxLength: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final brand = brandCtrl.text.trim();
              final last4 = last4Ctrl.text.trim();
              if (brand.isEmpty || last4.length != 4) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Isi brand dan 4 digit terakhir')));
                return;
              }
              setState(() => _cards.insert(0, {'brand': brand, 'last4': last4}));
              Navigator.pop(ctx, true);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card added')));
    }
  }

  void _showCardOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove card'),
              onTap: () {
                setState(() => _cards.removeAt(index));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Card removed')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top header with balance
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 46, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A2342), Color(0xFF072C5B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: const AssetImage('assets/avatar.png'),
                        backgroundColor: Colors.grey,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('MY WALLET', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  const Text('Rp 7,136', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Current Balance', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ),

          // White rounded sheet with cards
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('My Cards', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: _cards.length + 1,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // Add New Card
                          return InkWell(
                            onTap: _showAddCardDialog,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade300),
                                    ),
                                    child: const Icon(Icons.add, color: Colors.black54),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(child: Text('Add New Card', style: TextStyle(fontWeight: FontWeight.w600))),
                                  IconButton(onPressed: _showAddCardDialog, icon: const Icon(Icons.chevron_right)),
                                ],
                              ),
                            ),
                          );
                        }

                        final card = _cards[index - 1];
                        final String brand = card['brand'] ?? '';
                        final String last4 = card['last4'] ?? '';

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 4))],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    brand.isNotEmpty ? brand[0].toUpperCase() : '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(brand, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text('••••  $last4', style: TextStyle(color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                              IconButton(onPressed: () => _showCardOptions(index - 1), icon: const Icon(Icons.more_vert)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCardDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}