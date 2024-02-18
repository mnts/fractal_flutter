import 'package:flutter/material.dart';
import 'package:frac/index.dart';
import 'package:fractal/lib.dart';
import 'package:fractal_flutter/image.dart';
import 'package:signed_fractal/models/event.dart';

class FractalMovable extends StatefulWidget {
  final Widget child;
  final Fractal? event;
  final double maxWidth;
  final double maxHeight;
  final void Function()? onDragStart;
  final void Function()? onDragEnd;
  const FractalMovable({
    super.key,
    this.onDragStart,
    this.onDragEnd,
    this.maxWidth = 300,
    this.maxHeight = 300,
    required this.event,
    required this.child,
  });

  @override
  State<FractalMovable> createState() => _FractalMovableState();
}

class _FractalMovableState extends State<FractalMovable> {
  double hPad = 0;
  bool hide = false;
  bool get active => widget.event != null;

  checkState() {
    if (hPad < 32) {
      setState(() {
        hide = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<Fractal>(
      data: widget.event,
      affinity: Axis.horizontal,
      ignoringFeedbackSemantics: true,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: 0.8,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: widget.maxWidth,
              maxHeight: widget.maxHeight,
            ),
            child: child,
          ),
        ),
      ),
      child: widget.child,
      onDragStarted: () {
        widget.onDragStart?.call();
      },
      onDragUpdate: (d) {
        return;
        if (active) {
          setState(() {
            hPad += d.delta.dx;
            checkState();
          });
        }
      },
      onDraggableCanceled: (v, d) {
        //widget.onDragEnd?.call();
      },
      onDragEnd: (d) {
        widget.onDragEnd?.call();
      },
    );
  }

  Widget get child => Visibility(
        visible: !hide,
        child: widget.child,
      );
}
