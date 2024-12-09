import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_socket/client.dart';
import 'package:signed_fractal/models/network.dart';
import 'package:signed_fractal/sys.dart';

import 'fractal_flutter.dart';

class FractalSystem extends StatefulWidget {
  final Widget child;
  const FractalSystem({super.key, required this.child});

  @override
  State<FractalSystem> createState() => FractalSystemState();
}

class FractalSystemState extends State<FractalSystem> {
  FractalSystemState? active;

  final client = ClientFractal(
    from: DeviceFractal.my,
    to: NetworkFractal.active!,
  );

  @override
  void initState() {
    active = this;
    if (NetworkFractal.active != null) {
      NetworkFractal.out = client;
      client.establish();
    }

    //AppFractal.main.synch();

    super.initState();

    //WidgetsBinding.instance.addPostFrameCallback((_) => prepare());
  }

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
    //return widget.child;

    return (NetworkFractal.active != null)
        ? Listen(
            client.active,
            (ctx, ch) => widget.child,
          )
        : widget.child;
  }
}
