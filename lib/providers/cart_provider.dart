import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

/// Provider sederhana untuk mengelola keranjang belanja.
class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  /// Kembalian daftar item (read-only)
  List<Product> get items => List.unmodifiable(_items);

  /// Jumlah item di keranjang
  int get itemCount => _items.length;

  /// Total harga semua item di keranjang
  /// NOTE: pastikan Product.price bertipe `double` (non-nullable).
  double get totalPrice => _items.fold(0.0, (sum, p) => sum + p.price);

  /// Tambah produk ke keranjang
  void add(Product p) {
    _items.add(p);
    notifyListeners();
  }

  /// alias untuk kompatibilitas (addItem vs add)
  void addItem(Product p) => add(p);

  /// Hapus produk dari keranjang (menghapus instance pertama yang cocok)
  void remove(Product p) {
    _items.remove(p);
    notifyListeners();
  }

  /// Hapus item berdasarkan index
  void removeAt(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// Bersihkan seluruh keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// Cek apakah produk ada di keranjang
  bool contains(Product p) => _items.contains(p);

  /// Tambah beberapa produk sekaligus
  void addAll(List<Product> products) {
    _items.addAll(products);
    notifyListeners();
  }
}
