import 'package:flutter/material.dart';
import 'package:fractal/types/index.dart';

extension IconExt on IconF {
  Widget get widget => Icon(
        IconData(codePoint, fontFamily: fontFamily),
      );
}
