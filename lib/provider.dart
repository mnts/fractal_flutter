import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Exposes the [read] method.
extension ReadContext on BuildContext {
  /// Obtain a value from the nearest ancestor provider of type [T].
  ///
  /// This method is the opposite of [watch].\
  /// It will _not_ make widget rebuild when the value changes and cannot be
  /// called inside [StatelessWidget.build]/[State.build].\
  /// On the other hand, it can be freely called _outside_ of these methods.
  ///
  /// If that is incompatible with your criteria, consider using `Provider.of(context, listen: false)`.\
  /// It does the same thing, but without these added restrictions (but unsafe).
  ///
  /// **DON'T** call [read] inside build if the value is used only for events:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // counter is used only for the onPressed of RaisedButton
  ///   final counter = context.read<Counter>();
  ///
  ///   return RaisedButton(
  ///     onPressed: () => counter.increment(),
  ///   );
  /// }
  /// ```
  ///
  /// While this code is not bugged in itself, this is an anti-pattern.
  /// It could easily lead to bugs in the future after refactoring the widget
  /// to use `counter` for other things, but forget to change [read] into [watch].
  ///
  /// **CONSIDER** calling [read] inside event handlers:
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return RaisedButton(
  ///     onPressed: () {
  ///       // as performant as the previous solution, but resilient to refactoring
  ///       context.read<Counter>().increment(),
  ///     },
  ///   );
  /// }
  /// ```
  ///
  /// This has the same efficiency as the previous anti-pattern, but does not
  /// suffer from the drawback of being brittle.
  ///
  /// **DON'T** use [read] for creating widgets with a value that never changes
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // using read because we only use a value that never changes.
  ///   final model = context.read<Model>();
  ///
  ///   return Text('${model.valueThatNeverChanges}');
  /// }
  /// ```
  ///
  /// While the idea of not rebuilding the widget if something else changes is
  /// good, this should not be done with [read].
  /// Relying on [read] for optimisations is very brittle and dependent
  /// on an implementation detail.
  ///
  /// **CONSIDER** using [select] for filtering unwanted rebuilds
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   // Using select to listen only to the value that used
  ///   final valueThatNeverChanges = context.select((Model model) => model.valueThatNeverChanges);
  ///
  ///   return Text('$valueThatNeverChanges');
  /// }
  /// ```
  ///
  /// While more verbose than [read], using [select] is a lot safer.
  /// It does not rely on implementation details on `Model`, and it makes
  /// impossible to have a bug where our UI does not refresh.
  ///
  /// ## Using [read] to simplify objects depending on other objects
  ///
  /// This method can be freely passed to objects, so that they can read providers
  /// without having a reference on a [BuildContext].
  ///
  /// For example, instead of:
  ///
  /// ```dart
  /// class Model {
  ///   Model(this.context);
  ///
  ///   final BuildContext context;
  ///
  ///   void method() {
  ///     print(Provider.of<Whatever>(context));
  ///   }
  /// }
  ///
  /// // ...
  ///
  /// Provider(
  ///   create: (context) => Model(context),
  ///   child: ...,
  /// )
  /// ```
  ///
  /// we will prefer to write:
  ///
  /// ```dart
  /// class Model {
  ///   Model(this.read);
  ///
  ///   // `Locator` is a typedef that matches the type of `read`
  ///   final Locator read;
  ///
  ///   void method() {
  ///     print(read<Whatever>());
  ///   }
  /// }
  ///
  /// // ...
  ///
  /// Provider(
  ///   create: (context) => Model(context.read),
  ///   child: ...,
  /// )
  /// ```
  ///
  /// Both snippets behaves the same. But in the second snippet, `Model` has no dependency
  /// on Flutter/[BuildContext]/provider.
  ///
  /// See also:
  ///
  /// - [WatchContext] and its `watch` method, similar to [read], but
  ///   will make the widget tree rebuild when the obtained value changes.
  /// - [Locator], a typedef to make it easier to pass [read] to objects.
  T read<T>() {
    return Provider.of<T>(this, listen: false);
  }
}

/// Exposes the [watch] method.
extension WatchContext on BuildContext {
  /// Obtain a value from the nearest ancestor provider of type [T] or [T?], and subscribe
  /// to the provider.
  ///
  /// If [T] is nullable and no matching providers are found, [watch] will
  /// return `null`. Otherwise if [T] is non-nullable, will throw [ProviderNotFoundException].
  /// If [T] is non-nullable and the provider obtained returned `null`, will
  /// throw [ProviderNullException].
  ///
  /// This allows widgets to optionally depend on a provider:
  ///
  /// ```dart
  /// runApp(
  ///   Builder(builder: (context) {
  ///     final value = context.watch<Movie?>();
  ///
  ///     if (value == null) Text('no Movie found');
  ///     return Text(movie.title);
  ///   }),
  /// );
  /// ```
  ///
  /// Calling this method is equivalent to calling:
  ///
  /// ```dart
  /// Provider.of<T>(context)
  /// ```
  ///
  /// This method is accessible only inside [StatelessWidget.build] and
  /// [State.build].\
  /// If you need to use it outside of these methods, consider using [Provider.of]
  /// instead, which doesn't have this restriction.\
  /// The only exception to this rule is Providers's `update` method.
  ///
  /// See also:
  ///
  /// - [ReadContext] and its `read` method, similar to [watch], but doesn't make
  ///   widgets rebuild if the value obtained changes.
  T watch<T>() {
    return Provider.of<T>(this);
  }
}
