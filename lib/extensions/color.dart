import 'package:flutter/material.dart' as material;
import 'package:color/color.dart';

extension ColorExt on Color {
  material.Color get toMaterial => material.Color(hashCode);
}

extension ColorMExt on material.Color {
  Color get fromMaterial => Color.hex(hashCode.toString());
}
