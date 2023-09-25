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

    return Listen(
      sorted,
      (context, child) => DragTarget<T>(
        onWillAccept: (ev) {
          if (ev == null) return false;
          if (sorted.length > 0) return true;
          sorted.order(ev, 0);
          return true;
        },
        onAccept: (ev) {
          cb?.call();
        },
        builder: (context, d, rejectedData) => sorted.length > 0
            ? ListView.builder(
                itemCount: sorted.value.length,
                reverse: reverse,
                //shrinkWrap: false,
                scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
                padding: const EdgeInsets.only(
                  bottom: 50,
                  left: 1,
                ),
                itemBuilder: (context, i) => DragTarget<T>(
                  onWillAccept: (ev) {
                    if (ev == null) return false;
                    sorted.order(ev, i);

                    return true;
                  },
                  onAccept: (ev) {
                    cb?.call();
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
            : Container(),
      ),
    );
  }
}
