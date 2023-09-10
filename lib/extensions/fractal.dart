import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';

extension FlutterExtFractal on Fractal {
  Key get widgetKey => Key("$id@$type");
}
