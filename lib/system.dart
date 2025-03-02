import 'package:app_fractal/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fractal_socket/client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' show Platform;
import 'fractal_flutter.dart';

class FractalSystem extends StatefulWidget {
  final Widget child;
  const FractalSystem({super.key, required this.child});

  static Future initUI({required String host}) async {
    FileF.isWeb = kIsWeb;
    WidgetsFlutterBinding.ensureInitialized();
    if ((Platform.isAndroid || Platform.isIOS) && !kIsWeb) {
      FileF.path = (await getApplicationDocumentsDirectory()).path;
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(0, 0, 0, 0),
      ),
    );

    FileF.isSecure = true;
    //const domain = 'ryde.quest';
    FileF.host = ((kIsWeb && Uri.base.host != 'localhost')
            ? Uri.base.host
            //   : 'localhost:2415'
            : host)
        .replaceFirst('.beta', '');

    final d = [...FileF.host.split('.').reversed];
    FileF.main = d.length == 1 ? d[0] : '${d[1]}.${d[0]}';
  }

  @override
  State<FractalSystem> createState() => FractalSystemState();
}

class FractalSystemState extends State<FractalSystem> {
  FractalSystemState? active;

  late final clientFu = ClientFractal.controller.put({
    'from': DeviceFractal.my,
    'to': NetworkFractal.active!,
    'kind': FKind.eternal.index,
  });

  @override
  void initState() {
    active = this;
    if (NetworkFractal.active != null) {
      clientFu.then((c) async {
        await c.synch();
        NetworkFractal.out = c;
        c.establish();
        //c.synch();
      });
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
    if (NetworkFractal.active == null) return widget.child;
    return FractalFuture(clientFu, (f) {
      return Listen(
        f.active,
        (ctx, ch) => widget.child,
      );
    });
  }
}
