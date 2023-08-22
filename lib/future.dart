import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fractal/fractal.dart';

class FractalFuture<T extends Fractal> extends StatefulWidget {
  final Future<T> future;
  final Widget Function(T) builder;
  const FractalFuture(
    this.future,
    this.builder, {
    super.key,
  });

  @override
  State<FractalFuture> createState() => _FractalFutureState();
}

class _FractalFutureState extends State<FractalFuture> {
  Fractal? fractal;

  @override
  void initState() {
    widget.future.then((value) {
      setState(() {
        fractal = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(context) {
    return fractal == null
        ? CupertinoActivityIndicator()
        : widget.builder(fractal!);
  }
}
