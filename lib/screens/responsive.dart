import 'dart:ui';

import 'package:flutter/material.dart';

class FractalResponsive extends StatelessWidget {
  final List<Widget> children;
  const FractalResponsive(this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w > 640 ? flex() : tabs();
  }

  flex() {
    return Flex(
      direction: Axis.horizontal,
      children: [...children],
    );
  }

  tabs() {
    return DefaultTabController(
      length: children.length,
      child: Stack(
        children: [
          TabBarView(
            children: [...children],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 6,
                  sigmaY: 6,
                ),
                child: Container(
                  color: Colors.grey.withAlpha(100),
                  child: TabBar(tabs: [
                    ...children.map(
                      (w) => const Tab(
                        icon: Icon(
                          Icons.donut_large_rounded,
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
