// Author: jumail@utm.my.
// Date: Dec 2021

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'service_locator.dart';
import 'viewmodel.dart';

//----------------------------------------------------------------------------
// Default View is with Consumer and ChangeNotifierProvier
//----------------------------------------------------------------------------

typedef ViewmodelWidgetBuilder<V> = Widget Function(BuildContext, V);
typedef ViewmodelSelector<V, S> = S Function(BuildContext, V);
typedef ViewmodelSelectorWidgetBuilder<V, S> = Widget Function(
    BuildContext, V, S);
typedef AsyncViewmodelCallback<V> = Future<void> Function(V);
typedef ViewmodelCallback<V> = void Function(V);
typedef SelectorShouldRebuildBuilder<T1, T2> = bool Function(T1, T2);

// The abstract class is meant for reducing code duplication
abstract class _AbstractView<V extends Viewmodel> extends StatelessWidget {
  final ViewmodelWidgetBuilder<V> _builder;
  final ViewmodelWidgetBuilder<V> _progressBuilder;
  final bool _showProgressIndicator;
  final V _viewmodel = _viewmodelBuilder();
  V get viewmodel => _viewmodel;

//----------------------------------------------------------------------------
// Helper methods
//----------------------------------------------------------------------------
  static V _viewmodelBuilder<V extends Viewmodel>() {
    final viewmodel = ServiceLocator.locator<V>();
    if (!viewmodel.initialized) {
      viewmodel.markInitialized();
      viewmodel.init();
    }
    return viewmodel;
  }

  static Widget _defaultProgressBuilder(_, __) => CircularProgressIndicator();
  static Widget _defaultBuilder(_, __) => Container();
//----------------------------------------------------------------------------

  _AbstractView(
      {ViewmodelWidgetBuilder<V>? builder,
      ViewmodelWidgetBuilder<V>? progressBuilder,
      bool? showProgressIndicator})
      : _builder = builder ?? _defaultBuilder,
        _progressBuilder = progressBuilder ?? _defaultProgressBuilder,
        _showProgressIndicator = showProgressIndicator ?? true;

  Widget _baseBuilder(BuildContext context, V viewmodel) {
    if (viewmodel.isBusy || !viewmodel.initialized) {
      if (_showProgressIndicator) {
        return _progressBuilder.call(context, viewmodel);
      }
    }
    return _builder.call(context, viewmodel);
  }
}

/// `View` is the default class to a create view (based on MVVM architechture).
/// Each view will be associated with a viewmodel.
///
/// The `View` class is using `Consumer` widget from `Provider` for dependency injection
/// When a view is created, a viewmodel will also be created and associated
/// to it automatically.
///
/// You need to tell, which viewmodel to be used by specifying the
/// the class of the viewmodel when creating a view. See the example code below.
/// Also, you will need to register the viewmodel as a singleton in the service locator beforehand.
/// (see the file app/service_locator.dart)
///
/// *Example*:
///
///```dart
/// View<HomeViewmodel>(
///   showProgressIndicator: false,
///   progressIndicatorBuilder: (_,__)=>LineProgressIndicator(),
///   builder: (_, vm, ___) => Text('${vm.counter?.value}',
///       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
/// ),
/// ```
///
/// **properties:**
///
/// `progressBuilder` : a callback to build progress indicator. The default
/// progress indicator is `CircularProgressIndicator()`. If you want to
/// override the default progress indicator, set a new callback.
///
/// *Example*:
///
///```dart
///   progressIndicatorBuilder: (_,__)=>Text('Wait!. In progress...', style:TextStyle(color:Colors.red) ),
/// ```
///
/// `builder` : a callback to build the actual widget or content.
///
/// *Example*:
///
///```dart
///   builder: (context, viewmodel, child) => Text('${viewmodel.counter?.value}',
///       style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
/// ```
///
/// `showProgressIndicator` : a bool value, to show or not to show progress indicator when
/// the viewmodel is busy. If the `progressBuilder` is specified, `showProgressIndicator` is
/// overriden.
///
/// `shouldRebuid` : a bool value, to allow or not the widget gets rebuild. An example
/// use case is that when you want a widget to rebuild other widgets but not itself.
/// For example, in a counter app, you can set `shouldRebuild` to `false` for the button widget.
///

class View<V extends Viewmodel> extends _AbstractView<V> {
  final bool _shouldRebuild;

  View(
      {bool shouldRebuild = true,
      bool showProgressIndicator = true,
      ViewmodelWidgetBuilder<V>? builder,
      ViewmodelWidgetBuilder<V>? progressBuilder,
      Widget? child})
      : _shouldRebuild = shouldRebuild,
        super(
            builder: builder,
            progressBuilder: progressBuilder,
            showProgressIndicator: showProgressIndicator);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewmodel,
        child: _shouldRebuild
            ? Consumer<V>(
                builder: (context, viewmodel, _) =>
                    _baseBuilder(context, viewmodel))
            : _builder(context, viewmodel));
  }
}

/// `SelectorView` is another class of view, but `Selector` widget.
/// It allows to rebuild selectively.
///
/// The `SelectorView` class is using `Selector` widget from `Provider` for dependency injection
/// When a view is created, a viewmodel will also be created and associated
/// to it automatically.
///
/// You need to tell, which viewmodel to be used by specifying the
/// the class of the viewmodel when creating a view. See the example code below.
/// Also, you will need to register the viewmodel as a singleton in the service locator beforehand.
/// (see the file app/service_locator.dart)
///
/// *Example*:
///
///```dart
/// SelectorView<HomeViewmodel, int>(
///     showProgressIndicator: false,
///     selector: (_, vm) => vm.counter?.value,
///     builder: (_, __, value, ___) {
///             return Text('${value ?? ""}',
///                         style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold));
///             },
///  )
/// ```
///
/// **properties:**
///
/// `progressBuilder` : a callback to build progress indicator. The default
/// progress indicator is `CircularProgressIndicator()`. If you want to
/// override the default progress indicator, set a new callback.
///
/// *Example*:
///
///```dart
///   progressIndicatorBuilder: (_,__)=>Text('Wait!. In progress...', style:TextStyle(color:Colors.red) ),
/// ```
///
/// `builder` : a callback to build the actual widget or content.
///
/// *Example*:
///
///```dart
///     builder: (context, viewmodel, selectorValue, child) {
///             return Text('${selectorValue ?? ""}',
///                         style: TextStyle( fontSize: 30, fontWeight: FontWeight.bold));
///             },
/// ```
///
/// `selector` : a callback to decide whether to re-build or not the widget.
/// The callback will return a value. It use this value to decide whether to rebuild
/// by comparing the current value with the previous one (i.e., from the last rebuilt)
/// Widget will get rebuilt if the values are different.
///
/// A use case for this property, for example, in a todo list app, you only want
/// to rebuild the entire list if the size of the list gets changed, due to for example
/// deletion or insertion of new todos.  However, if the case that only update
/// an existing item, the list should not be re-build, but only that one item.
///
/// However, the `selector` will not take an effect if `showProgressIndicator` is `true`.
/// This makes sense because, showing progress indicator will rebuild the widget.
/// Therefore, if it is necessary to have selective build, you should set `showProgressIndicator` to `false`.
///
/// In the following example, the widget will get rebuilt only if the counter value gets changed
///
/// *Example*:
///
///```dart
/// selector: (context, viewmodel) => viewmodel.counter?.value.
/// ```
///
/// `showProgressIndicator` : a bool value, to show or not to show progress indicator when
/// the viewmodel is busy. If the `progressBuilder` is specified, `showProgressIndicator` is
/// overriden.
///

class SelectorView<V extends Viewmodel, S> extends _AbstractView<V> {
  final ViewmodelSelector<V, S> _selector;

// helper methods
  SelectorShouldRebuildBuilder _buildShouldRebuildCallback() {
    if (!viewmodel.isBusy || !_showProgressIndicator) return (_, __) => false;
    return (_, __) => true;
  }

  SelectorView(
      {bool showProgressIndicator = true,
      required ViewmodelSelectorWidgetBuilder<V, S> builder,
      required ViewmodelSelector<V, S> selector,
      ViewmodelWidgetBuilder<V>? progressBuilder})
      : _selector = selector,
        super(
            builder: (context, viewmodel) =>
                builder(context, viewmodel, selector(context, viewmodel)),
            progressBuilder: progressBuilder,
            showProgressIndicator: showProgressIndicator);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _viewmodel,
        child: Selector<V, Tuple2<V, S>>(
          shouldRebuild: _buildShouldRebuildCallback(),
          selector: (context, viewmodel) =>
              Tuple2(viewmodel, _selector(context, viewmodel)),
          builder: (context, data, _) => _baseBuilder(context, data.item1),
        ));
  }
}
