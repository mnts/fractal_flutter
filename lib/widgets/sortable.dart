import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/event.dart';
import 'package:signed_fractal/services/sorted.dart';

class FSortable<T extends EventFractal> extends StatelessWidget {
  final SortedFrac<T> sorted;
  final Widget Function(T) builder;
  final Function()? cb;

  final bool reverse;
  final bool horizontal;

  const FSortable({
    this.cb,
    this.reverse = true,
    this.horizontal = false,
    required this.sorted,
    required this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //context.read<SortedFrac>();

    Timer? timer;

    order(T f, int i) {
      timer?.cancel();
      timer = Timer(
        const Duration(milliseconds: 300),
        () {
          sorted.order(f, i);
          cb?.call();
        },
      );
    }

    return Listen(
      sorted,
      (context, child) => DragTarget<T>(
        onWillAccept: (f) {
          if (f == null) return false;
          if (sorted.length > 0) return true;
          order(f, 0);
          return true;
        },
        onLeave: (f) {
          if (f == null) return;
          sorted.remove(f);
          cb?.call();
        },
        onAccept: (ev) {
          cb?.call();
        },
        builder: (context, d, rejectedData) => sorted.length > 0
            ? ListView.builder(
                itemCount: sorted.value.length,
                reverse: reverse,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                //shrinkWrap: false,
                scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
                padding: const EdgeInsets.only(
                  //top: 56,
                  left: 1,
                ),
                itemBuilder: (context, i) => DragTarget<T>(
                  onWillAccept: (f) {
                    if (f == null) return false;
                    order(f, i);
                    return true;
                  },
                  onAccept: (ev) {},
                  onLeave: (ev) {
                    timer?.cancel();
                  },
                  builder: (
                    context,
                    d,
                    List<dynamic> rejectedData,
                  ) =>
                      builder(
                    sorted.value[i],
                  ),
                ),
              )
            : Container(
                height: 30,
              ),
      ),
    );
  }
}
