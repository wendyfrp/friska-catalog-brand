import 'package:flutter/material.dart';

/// Abstract base class (inheritance) that defines common product behavior.
abstract class ProductModel {
  String get nama;
  String get deskripsi;
  Color get color;
  IconData get icon;
  String get foto;

  /// Return a map representation (polymorphic serialization).
  Map<String, dynamic> toMap();

  /// Human readable description (polymorphism: subclasses can override).
  String describe();
}

/// Concrete model for "Baju" that encapsulates fields (private) and exposes
/// only getters and helpers.
class BajuModel extends ProductModel {
  final String _nama;
  final String _deskripsi;
  final Color _color;
  final IconData _icon;
  final String _foto;

  BajuModel({
    required String nama,
    required String deskripsi,
    required Color color,
    required IconData icon,
    required String foto,
  })  : _nama = nama,
        _deskripsi = deskripsi,
        _color = color,
        _icon = icon,
        _foto = foto;

  // Encapsulation: expose read-only properties via getters
  @override
  String get nama => _nama;

  @override
  String get deskripsi => _deskripsi;

  @override
  Color get color => _color;

  @override
  IconData get icon => _icon;

  @override
  String get foto => _foto;

  // Polymorphic serialization: convert to a Map (color -> int, icon -> codePoint)
  @override
  Map<String, dynamic> toMap() => {
        'nama': _nama,
        'deskripsi': _deskripsi,
        'color': _color.value,
        'icon_codePoint': _icon.codePoint,
        'icon_fontFamily': _icon.fontFamily,
        'foto': _foto,
      };

  // Factory to create BajuModel from Map (handles color int and IconData)
  factory BajuModel.fromMap(Map<String, dynamic> map) {
    final colorValue = map['color'];
    final iconCode = map['icon_codePoint'];
    final iconFont = map['icon_fontFamily'] as String?;
    return BajuModel(
      nama: map['nama'] as String? ?? '',
      deskripsi: map['deskripsi'] as String? ?? '',
      color: colorValue is int ? Color(colorValue) : Colors.blue,
      icon: iconCode is int ? IconData(iconCode, fontFamily: iconFont) : Icons.help,
      foto: map['foto'] as String? ?? '',
    );
  }

  // Polymorphism: concrete description override
  @override
  String describe() => '$nama — $deskripsi';

  @override
  String toString() =>
      'BajuModel(nama: $_nama, deskripsi: $_deskripsi, color: ${_color.value}, icon: ${_icon.codePoint}, foto: $_foto)';

  // Simple equality based on fields
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is BajuModel &&
            other._nama == _nama &&
            other._deskripsi == _deskripsi &&
            other._color.value == _color.value &&
            other._icon.codePoint == _icon.codePoint &&
            other._foto == _foto);
  }

  @override
  int get hashCode =>
      _nama.hashCode ^ _deskripsi.hashCode ^ _color.value.hashCode ^ _icon.codePoint.hashCode ^ _foto.hashCode;
}