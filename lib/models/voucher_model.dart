import 'package:flutter/material.dart';

/// Class ini berfungsi sebagai cetak biru (blueprint) untuk data sebuah voucher.
/// Ini bukan halaman atau tampilan, hanya struktur data.
class Voucher {
  final String title;
  final String subtitle;
  final String code;
  final Color startColor;
  final Color endColor;

  Voucher({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.startColor,
    required this.endColor,
  });
}

