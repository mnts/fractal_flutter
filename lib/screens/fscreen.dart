import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FScreen extends StatefulWidget {
  Widget child;
  int alpha;
  FScreen(this.child, {Key? key, this.alpha = 0});

  @override
  _FScreenState createState() => _FScreenState();
}

class _FScreenState extends State<FScreen> {
  @override
  Widget build(BuildContext context) {
    /*
    final app = Provider.of<AppFractal>(context);
    final color = widget.alpha > 0
        ? app.skin.color.withAlpha(widget.alpha)
        : Colors.transparent;
    */
    const double toolbarHeight = 54;

    return SafeArea(
      child: Scaffold(
        appBar: widget.alpha > 0
            ? null
            : AppBar(
                //backgroundColor: Color.fromARGB(176, 15, 186, 209),
                flexibleSpace: ClipRect(
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                toolbarHeight: toolbarHeight,
                elevation: 0.0,
              ),
        extendBodyBehindAppBar: true,
        body: /*widget.alpha > 0
            ? Stack(children: [
                widget.child,
                if (widget.alpha > 0 && widget.alpha < 255)
                  Positioned(
                    left: 0,
                    right: 0,
                    height: toolbarHeight,
                    child: Container(
                      width: 70,
                      height: toolbarHeight,
                      color: color,
                    ),
                  ),
              ])
            : */
            Padding(
          padding: const EdgeInsets.fromLTRB(0, toolbarHeight, 0, 0),
          child: widget.child,
        ),
      ),
    );
  }
}
