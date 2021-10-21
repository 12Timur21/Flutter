import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ru'),
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'ru':
        return 'Русьня';
      case 'en':
      default:
        return 'English';
    }
  }
}
