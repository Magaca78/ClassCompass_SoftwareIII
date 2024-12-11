import 'package:flutter/material.dart';

class InfoRect {
  final String info;
  final Rect rect;
  bool isHighlighted; // Nueva propiedad para destacar

  InfoRect({
    required this.info,
    required this.rect,
    this.isHighlighted = false, // Valor predeterminado
  });
}

