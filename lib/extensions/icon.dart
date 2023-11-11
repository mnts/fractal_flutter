import 'package:flutter/material.dart';
import 'package:fractal/types/index.dart';
import 'package:signed_fractal/models/index.dart';

import '../widgets/icon.dart';

extension IconExt on IconF {
  Widget get widget => Icon(
        IconData(codePoint, fontFamily: fontFamily),
      );
}

extension IconFractalExt on EventFractal {
  Widget get icon => FIcon(this);
}
