enum AsyncValueState { none, loading, error, success, empty }

class AsyncValue<T> {
   T? data;
  final Object? error;
  final AsyncValueState state;

  AsyncValue._({this.data, this.error, required this.state});

  factory AsyncValue.none() => AsyncValue._(state: AsyncValueState.none);

  factory AsyncValue.loading() => AsyncValue._(state: AsyncValueState.loading);

  factory AsyncValue.success(T data) =>
      AsyncValue._(data: data, state: AsyncValueState.success);

  factory AsyncValue.error(Object error) =>
      AsyncValue._(error: error, state: AsyncValueState.error);

  factory AsyncValue.empty() => AsyncValue._(state: AsyncValueState.empty);
}
