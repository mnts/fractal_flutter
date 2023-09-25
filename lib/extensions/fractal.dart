import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';

extension FlutterExtFractal on Fractal {
  Key widgetKey(String w) => Key("$w.$id@$type");
}
