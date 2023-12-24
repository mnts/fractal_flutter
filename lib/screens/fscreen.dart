import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FScreen extends StatefulWidget {
  Widget child;
  int alpha;
  FScreen(this.child, {Key? key, this.alpha = 255});

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
    const double toolbarHeight = 56;

    final scheme = Theme.of(context).colorScheme;

    var color = scheme.primary;
    if (widget.alpha < 255) {
      color = color.withAlpha(widget.alpha);
    }
    return Column(
      children: [
        Hero(
          tag: 'fScreen',
          child: Container(
            //color: (widget.alpha == 0) ? null : color,
            height: toolbarHeight,
          ),
        ),
        Expanded(
          child: widget.child,
        ),
      ],
    );
  }
}
