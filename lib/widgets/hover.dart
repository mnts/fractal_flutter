import 'package:flutter/material.dart';

class HoverOver extends StatefulWidget {
  final int? animationDurationInMilliseconds;
  final double? translateXAxis;
  final double? translateYAxis;
  final Widget Function(bool isHovered) builder;

  /// Creates a hover effect on the widget. The [animationDurationInMilliseconds] is the duration of the animation.
  /// The [translateXAxis] and [translateYAxis] are the values to translate the widget on the X and Y axis respectively.
  /// The [builder] is the widget that will be built when the hover effect is active.
  /// The [isHovered] is a boolean that indicates if the hover effect is active or not.
  const HoverOver(
      {Key? key,
      this.animationDurationInMilliseconds,
      this.translateXAxis,
      this.translateYAxis,
      required this.builder})
      : super(key: key);

  @override
  _HoverOverState createState() => _HoverOverState();
}

class _HoverOverState extends State<HoverOver> {
  bool isHovered = false;
  @override
  Widget build(BuildContext context) {
    ///on hover translate the widget
    return MouseRegion(
      onEnter: (_) => onEntered(true),
      onExit: (_) => onEntered(false),

      /// on hover animate the widget
      child: widget.builder(isHovered),
    );
  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}
