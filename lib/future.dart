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

  Widget build(Fractal fractal) => builder(fractal as T);

  @override
  State<FractalFuture> createState() => _FractalFutureState();
}

class _FractalFutureState extends State<FractalFuture> {
  Fractal? fractal;

  @override
  void initState() {
    wait();
    super.initState();
  }

  complete(value) {
    setState(() {
      fractal = value;
    });
  }

  wait() async {
    final res = await widget.future;
    complete(res);
  }

  @override
  Widget build(context) {
    return fractal == null
        ? const CupertinoActivityIndicator()
        : widget.build(fractal!);
  }
}
