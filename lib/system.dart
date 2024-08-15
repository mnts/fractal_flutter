import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:fractal_base/fractals/device.dart';
import 'package:fractal_socket/client.dart';
import 'package:signed_fractal/models/network.dart';
import 'package:signed_fractal/sys.dart';

import 'fractal_flutter.dart';

class FractalSystem extends StatefulWidget {
  final Widget child;
  const FractalSystem({super.key, required this.child});

  @override
  State<FractalSystem> createState() => _FractalAppState();
}

class _FractalAppState extends State<FractalSystem> {
  @override
  void initState() {
    ClientFractal.main = ClientFractal(
      from: DeviceFractal.my,
      to: NetworkFractal.active,
    );

    //AppFractal.main.synch();
    FSys.setup();

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
      builder: (ctx, snap) => snap.data == null
          ? const CupertinoActivityIndicator()
          : Listen(
              ClientFractal.main!.active,
              (ctx, ch) => widget.child,
            ),
    );
  }
}
