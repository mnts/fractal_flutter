import 'package:flutter/material.dart';
import 'package:fractal_flutter/data/icons.dart';
import 'package:fractal_flutter/index.dart';
import 'package:signed_fractal/models/index.dart';
import 'package:dartlin/control_flow.dart';

import '../image.dart';

class FIcon extends StatelessWidget {
  final EventFractal f;
  const FIcon(this.f, {super.key});

  @override
  Widget build(BuildContext context) {
    return switch (f) {
      NodeFractal node => Container(
          clipBehavior: Clip.hardEdge,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              this is UserFractal ? 80 : 8,
            ),
          ),
          child: node.image != null
              ? FractalImage(
                  key: Key(
                    '${node.image!.name}@icon',
                  ),
                  node.image!,
                  fit: BoxFit.cover,
                )
              : switch (node.m['icon']?.content) {
                  'check' => check(context),
                  String icnS => icnS.let((it) {
                      final color = node.m['color']?.content;
                      return Icon(
                        parse(icnS, f.ctrl.icon.codePoint),
                        color: color != null
                            ? Color(
                                int.tryParse(
                                      color,
                                    ) ??
                                    0,
                              )
                            : null,
                      );
                    }),
                  _ => f.ctrl.icon.widget,
                },
        ),
      _ => f.ctrl.icon.widget,
    };
  }

  static IconData parse(String icnS, int def) {
    final icn = int.tryParse(icnS);
    return icn != null
        ? IconData(
            icn,
            fontFamily: 'MaterialIcons',
          )
        : MaterialFIcons.mIcons[icnS] ??
            IconData(
              def,
              fontFamily: 'MaterialIcons',
            );
  }

  Widget check(BuildContext ctx) {
    final rew = ctx.read<Rewritable?>();
    if (rew == null) {
      return const Icon(
        Icons.check_box_outline_blank,
        //color: Colors.red,
      );
    }

    final node = f as NodeFractal;
    return Listen(rew.m, (ctx, child) {
      final cont = rew.m[node.name]?.content ?? '';
      final si = cont.isNotEmpty;

      return Checkbox(
        value: si,
        onChanged: (bool? v) {
          if (v == null) return;
          rew.write(node.name, si ? '' : ' ');
        },
      );
    });
  }
}
