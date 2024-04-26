import 'package:app_fractal/index.dart';
import 'package:flutter/material.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_socket/index.dart';
import 'package:signed_fractal/signed_fractal.dart';

class FractalApp extends StatefulWidget {
  final Widget child;
  const FractalApp({super.key, required this.child});

  @override
  State<FractalApp> createState() => _FractalAppState();
}

class _FractalAppState extends State<FractalApp> {
  @override
  void initState() {
    ClientFractal.main = ClientFractal(
      from: DeviceFractal.my,
      to: NetworkFractal.active,
    );
    AppFractal.main.synch();
    AppFractal.active.events?.synch();

    /*
    ClientFractal.main!.establish().then((a) async {
      AppFractal.main.synch();
      AppFractal.active.events?.synch();
    });
    */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
