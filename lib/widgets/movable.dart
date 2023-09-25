import 'package:flutter/material.dart';
import 'package:fractal_flutter/image.dart';
import 'package:signed_fractal/models/event.dart';

class FractalMovable extends StatefulWidget {
  final Widget child;
  final EventFractal? event;
  final double maxWidth;
  final double maxHeight;
  const FractalMovable({
    super.key,
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
    return Draggable<EventFractal>(
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
      onDragUpdate: (d) {
        return;
        if (active) {
          setState(() {
            hPad += d.delta.dx;
            checkState();
          });
        }
      },
      onDragEnd: (d) {
        setState(() {
          hPad = 0;
        });
      },
    );
  }

  Widget get child => Visibility(
        visible: !hide,
        child: Container(
          padding: EdgeInsets.only(
            left: hPad > 0 ? hPad : 0,
            right: hPad < 0 ? -hPad : 0,
            top: 4,
            bottom: 4,
          ),
          child: widget.child,
        ),
      );
}
