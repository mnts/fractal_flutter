// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:frac/frac.dart';
import 'package:fractal/lib.dart';
import 'package:fractal/types/file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:universal_io/io.dart';
export 'providers/multi.dart';

class FractalFlutter {
  static Future<bool> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid || Platform.isIOS) {
      FileF.path = (await getApplicationDocumentsDirectory()).path;
    }
    return true;
  }
}

//import 'package:provider/provider.dart';

/// Builds a [Widget] when given a concrete value of a [ValueListenable<T>].
///
/// If the `child` parameter provided to the [ValueListenableBuilder] is not
/// null, the same `child` widget is passed back to this [ValueWidgetBuilder]
/// and should typically be incorporated in the returned widget tree.
///
/// See also:
///
///  * [ValueListenableBuilder], a widget which invokes this builder each time
///    a [ValueListenable] changes value.
typedef ValueWidgetBuilder = Widget Function(
    BuildContext context, Widget? child);

/// A widget whose content stays synced with a [ValueListenable].
///
/// Given a [ValueListenable<T>] and a [builder] which builds widgets from
/// concrete values of `T`, this class will automatically register itself as a
/// listener of the [ValueListenable] and call the [builder] with updated values
/// when the value changes.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=s-ZG-jS5QHQ}
///
/// ## Performance optimizations
///
/// If your [builder] function contains a subtree that does not depend on the
/// value of the [ValueListenable], it's more efficient to build that subtree
/// once instead of rebuilding it on every animation tick.
///
/// If you pass the pre-built subtree as the [child] parameter, the
/// [ValueListenableBuilder] will pass it back to your [builder] function so
/// that you can incorporate it into your build.
///
/// Using this pre-built child is entirely optional, but can improve
/// performance significantly in some cases and is therefore a good practice.
///
/// {@tool snippet}
///
/// This sample shows how you could use a [ValueListenableBuilder] instead of
/// setting state on the whole [Scaffold] in the default `flutter create` app.
///
/// ```dart
/// class MyHomePage extends StatefulWidget {
///   const MyHomePage({Key? key, required this.title});
///   final String title;
///
///   @override
///   State<MyHomePage> createState() => _MyHomePageState();
/// }
///
/// class _MyHomePageState extends State<MyHomePage> {
///   final ValueNotifier<int> _counter = ValueNotifier<int>(0);
///   final Widget goodJob = const Text('Good job!');
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(
///         title: Text(widget.title)
///       ),
///       body: Center(
///         child: Column(
///           mainAxisAlignment: MainAxisAlignment.center,
///           children: <Widget>[
///             const Text('You have pushed the button this many times:'),
///             ValueListenableBuilder<int>(
///               builder: (BuildContext context, int value, Widget? child) {
///                 // This builder will only get called when the _counter
///                 // is updated.
///                 return Row(
///                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
///                   children: <Widget>[
///                     Text('$value'),
///                     child!,
///                   ],
///                 );
///               },
///               valueListenable: _counter,
///               // The child parameter is most helpful if the child is
///               // expensive to build and does not depend on the value from
///               // the notifier.
///               child: goodJob,
///             )
///           ],
///         ),
///       ),
///       floatingActionButton: FloatingActionButton(
///         child: const Icon(Icons.plus_one),
///         onPressed: () => _counter.value += 1,
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [AnimatedBuilder], which also triggers rebuilds from a Listenable
///    without passing back a specific value from a [ValueListenable].
///  * [NotificationListener], which lets you rebuild based on [Notification]
///    coming from its descendant widgets rather than a [ValueListenable] that
///    you have a direct reference to.
///  * [StreamBuilder], where a builder can depend on a [Stream] rather than
///    a [ValueListenable] for more advanced use cases.
class Listen<T> extends StatefulWidget {
  const Listen(
    this.valueListenable,
    this.builder, {
    Key? key,
    this.child,
  }) : super(key: key);

  final FChangeNotifier valueListenable;
  final ValueWidgetBuilder builder;
  final Widget? child;

  @override
  State<StatefulWidget> createState() => _ValueListenableBuilderState<T>();
}

class Watch<T extends FChangeNotifier?> extends FListenableProvider<T> {
  Watch(
    T frac,
    TransitionBuilder builder, {
    super.key,
    Widget? child,
  }) : super.value(
          builder: builder,
          value: frac,
          child: child,
        );

  static void _dispose(BuildContext context, FChangeNotifier? notifier) {
    notifier?.dispose();
  }
}

class _ValueListenableBuilderState<T> extends State<Listen<T>> {
  //late T value;

  @override
  void initState() {
    super.initState();
    //value = widget.valueListenable.value;
    widget.valueListenable.addListener(_valueChanged);
  }

  @override
  void didUpdateWidget(Listen<T> oldWidget) {
    if (oldWidget.valueListenable != widget.valueListenable) {
      oldWidget.valueListenable.removeListener(_valueChanged);
      //value = widget.valueListenable.value;
      widget.valueListenable.addListener(_valueChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.valueListenable.removeListener(_valueChanged);
    super.dispose();
  }

  void _valueChanged() {
    setState(() {
      //value = widget.valueListenable.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}

class FChangeNotifierProvider<T extends FChangeNotifier?>
    extends FListenableProvider<T> {
  /// Creates a [ChangeNotifier] using `create` and automatically
  /// disposes it when [ChangeNotifierProvider] is removed from the widget tree.
  ///
  /// `create` must not be `null`.
  FChangeNotifierProvider({
    Key? key,
    required Create<T> create,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          dispose: _dispose,
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// Provides an existing [ChangeNotifier].
  FChangeNotifierProvider.value({
    Key? key,
    required T value,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          key: key,
          builder: builder,
          value: value,
          child: child,
        );

  static void _dispose(BuildContext context, FChangeNotifier? notifier) {
    notifier?.dispose();
  }
}

class Provide extends StatelessWidget {
  final TransitionBuilder builder;
  final FChangeNotifier value;
  final Widget? child;
  const Provide(
    this.value,
    this.builder, {
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FChangeNotifierProvider.value(
      value: value,
      builder: builder,
    );
  }
}

class FListenableProvider<T extends FListenable?> extends InheritedProvider<T> {
  /// Creates a [Listenable] using [create] and subscribes to it.
  ///
  /// [dispose] can optionally passed to free resources
  /// when [ListenableProvider] is removed from the tree.
  ///
  /// [create] must not be `null`.
  FListenableProvider({
    Key? key,
    required Create<T> create,
    Dispose<T>? dispose,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          startListening: _startListening,
          create: create,
          dispose: dispose,
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// Provides an existing [Listenable].
  FListenableProvider.value({
    Key? key,
    required T value,
    UpdateShouldNotify<T>? updateShouldNotify,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          key: key,
          builder: builder,
          value: value,
          updateShouldNotify: updateShouldNotify,
          startListening: _startListening,
          child: child,
        );

  static VoidCallback _startListening(
    InheritedContext e,
    FListenable? value,
  ) {
    value?.addListener(e.markNeedsNotifyDependents);
    return () => value?.removeListener(e.markNeedsNotifyDependents);
  }
}
