import 'dart:async';

mixin ServiceStream<T> {
  // this getter is to be overidden, if the service supports stream such as in firestore
  Stream<T>? get stream => null;

  // to be overridden by concrete class
  // This method is meant for normalizing of user data, as each
  //  service has their own structure of user data.
  //
  //  Example:  in Firebase authentication, user data received in a form of FirebaseUser,
  //            use the method transformData to convert FirebaseUser type to you own User model class

  Future? transformData(T? data) async => data;

  // subscriber to subscribe this stream
  StreamSubscription<T>? listen({
    void Function(T)? onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    if (stream == null) return null;

    // in case the service also supports stream (like in firestore), create a listener to the stream
    return stream?.listen(
      (data) async {
        try {
          if (data != null) onData?.call(await transformData(data));
        } catch (e) {
          if (onError == null) rethrow;
          onError(e);
        }
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}
