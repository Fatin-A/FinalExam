// Author: jumail@utm.my.
// Date: Dec 2021

import 'package:flutter/foundation.dart';
import 'failure.dart';

class Viewmodel with ChangeNotifier {
  bool _busy = false;
  Failure? _failure;

  bool _initialized = false;
  bool get initialized => _initialized;
  void markInitialized() => _initialized = true;

  /// if true it means, the error is handled by re-building the views.
  /// If false it means, the error is handled during the call (e.g., with show snackbar)
  bool _notifyListenersOnFailure = true;
  bool get notifyListenersOnFailure => _notifyListenersOnFailure;
  set notifyListenersOnFailure(value) => _notifyListenersOnFailure = value;

  bool get isBusy => _busy;
  bool get isFree => !_busy;
  void _setBusy([bool value = true]) {
    _busy = value;
    notifyListeners();
  }

  Failure? get failure => _failure;
  void catchError(Failure? value) {
    _failure = value;
    notifyListeners();
  }

  bool get hasFailure => _failure != null;

  void stateBusy() => _setBusy();
  void stateFree() => _setBusy(false);

  /// A convenient method, to implicitly write the setToBusy()... setToFree()
  Future<void> update(AsyncCallback? callback) async {
    // set directly to attribute instead of catchError(), to avoid redudant notifyListeners() calls        catchError(e);
    _failure = null;

    stateBusy();
    if (callback != null) {
      try {
        await callback();
        stateFree();
      } on Failure catch (e) {
        // Two types of handling errors: rebuild the widget or not (for example, just show Snackbar without rebuilding widget)

        if (_notifyListenersOnFailure) {
          // set directly to attribute instead of _setBusy(), to avoid redudant notifyListeners() calls        catchError(e);
          _busy = false;
          catchError(e);
        } else {
          stateFree(); // to unshow the progress indicator
          rethrow;
        }
      } catch (e) {
        // handle other errors
        handleOtherException(e);
      }
    }
  }

  /// To be overridden by the child class if it needs to
  /// do something once the viewmodel has been created
  void init() {
    markInitialized();
    notifyListenersOnFailure = true;
  }

  /// To be overridden by the child to handle other errors
  void handleOtherException(e) {
    // default handling: print out the error to the console
    print('Other failure: ${e.toString()}');
  }

  /// Override the dispose method for the case (for example) you use stream in
  /// your viewmodels
  ///
  /// @override
  /// void dispose()
  ///
}
