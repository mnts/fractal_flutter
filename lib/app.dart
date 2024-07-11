import 'package:app_fractal/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_socket/client.dart';
import 'package:signed_fractal/models/network.dart';

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

    //AppFractal.main.synch();

    super.initState();

    //WidgetsBinding.instance.addPostFrameCallback((_) => prepare());
  }

  late final connecting = ClientFractal.main!.establish();

  /*
  prepare() {
    .then((a) async {
      AppFractal.active.events?.synch();
    });
    AppFractal.active.preload();
  }
  */

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: connecting,
      builder: (ctx, snap) =>
          snap.data == null ? const CupertinoActivityIndicator() : widget.child,
    );
  }
}
