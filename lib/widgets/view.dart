import 'package:flutter/material.dart';

class FractalView extends StatefulWidget {
  final bool reverse;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final List<Widget> children;

  static double gridWidth = 640;
  final double? width;

  const FractalView({
    super.key,
    this.width,
    this.reverse = false,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.scrollDirection = Axis.vertical,
    required this.children,
  });

  @override
  State<FractalView> createState() => _FractalViewState();
}

class _FractalViewState extends State<FractalView> {
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return LayoutBuilder(builder: (context, constraints) {
      maxWidth = constraints.maxWidth;
      return widget.width != null ||
              constraints.maxWidth > FractalView.gridWidth
          ? grid()
          : ListView(
              reverse: widget.reverse,
              shrinkWrap: widget.shrinkWrap,
              physics: widget.physics,
              scrollDirection: widget.scrollDirection,
              padding: widget.padding,
              children: [
                ...widget.children.map(
                  (c) => ConstrainedBox(
                    constraints: const BoxConstraints(
                        //maxHeight: 60,
                        ),
                    child: c,
                  ),
                ),
              ],
            );
    });
  }

  double maxWidth = 0;

  SliverGridDelegate get gridDelegate =>
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, //maxWidth ~/ FractalView.gridWidth ~/ 0.4,
        childAspectRatio: 1,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
      );

  Widget grid() {
    return SingleChildScrollView(
      child: GridView(
        gridDelegate: gridDelegate,
        primary: false,
        padding: widget.padding,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        scrollDirection: widget.scrollDirection,
        children: widget.children,
      ),
    );
  }
}
