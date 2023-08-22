import 'package:flutter/material.dart';
import 'package:nested/nested.dart';

class FMultiProvider extends Nested {
  /// Build a tree of providers from a list of [SingleChildWidget].
  ///
  /// The parameter `builder` is syntactic sugar for obtaining a [BuildContext] that can
  /// read the providers created.
  ///
  /// This code:
  ///
  /// ```dart
  /// MultiProvider(
  ///   providers: [
  ///     Provider<Something>(create: (_) => Something()),
  ///     Provider<SomethingElse>(create: (_) => SomethingElse()),
  ///     Provider<AnotherThing>(create: (_) => AnotherThing()),
  ///   ],
  ///   builder: (context, child) {
  ///     final something = context.watch<Something>();
  ///     return Text('$something');
  ///   },
  /// )
  /// ```
  ///
  /// is strictly equivalent to:
  ///
  /// ```dart
  /// MultiProvider(
  ///   providers: [
  ///     Provider<Something>(create: (_) => Something()),
  ///     Provider<SomethingElse>(create: (_) => SomethingElse()),
  ///     Provider<AnotherThing>(create: (_) => AnotherThing()),
  ///   ],
  ///   child: Builder(
  ///     builder: (context) {
  ///       final something = context.watch<Something>();
  ///       return Text('$something');
  ///     },
  ///   ),
  /// )
  /// ```
  ///
  /// If the some provider in `providers` has a child, this will be ignored.
  ///
  /// This code:
  /// ```dart
  /// MultiProvider(
  ///   providers: [
  ///     Provider<Something>(create: (_) => Something(), child: SomeWidget()),
  ///   ],
  ///   child: Text('Something'),
  /// )
  /// ```
  /// is equivalent to:
  ///
  /// ```dart
  /// MultiProvider(
  ///   providers: [
  ///     Provider<Something>(create: (_) => Something()),
  ///   ],
  ///   child: Text('Something'),
  /// )
  /// ```
  ///
  /// For an explanation on the `child` parameter that `builder` receives,
  /// see the "Performance optimizations" section of [AnimatedBuilder].
  FMultiProvider({
    Key? key,
    required List<SingleChildWidget> providers,
    Widget? child,
    TransitionBuilder? builder,
  }) : super(
          key: key,
          children: providers,
          child: builder != null
              ? Builder(
                  builder: (context) => builder(context, child),
                )
              : child,
        );
}
