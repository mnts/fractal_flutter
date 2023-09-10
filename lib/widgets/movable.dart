import 'package:flutter/material.dart';
import 'package:fractal_flutter/image.dart';
import 'package:signed_fractal/models/event.dart';

class FractalMovable extends StatefulWidget {
  final Widget child;
  final EventFractal? event;
  const FractalMovable({
    super.key,
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
        child: feedback,
      ),
      child: child,
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

  Widget get feedback => Container(
        width: 300,
        child: Visibility(
          visible: true, //hPad > 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.event?.content ?? '',
                //style: TextStyle(color: Colors.red),
              ),
              if (widget.event?.file != null)
                FractalMovable(
                  event: widget.event,
                  child: FractalImage(
                    widget.event!.file!,
                  ),
                ),
            ],
          ),
        ),
      );
}
