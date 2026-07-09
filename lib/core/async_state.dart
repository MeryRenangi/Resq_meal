/// Standard loading / error / success wrapper for provider state.
class AsyncState<T> {
  const AsyncState({
    this.data,
    this.isLoading = false,
    this.error,
  });

  final T? data;
  final bool isLoading;
  final String? error;

  bool get hasError => error != null;
  bool get hasData => data != null;

  AsyncState<T> copyWith({
    T? data,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearData = false,
  }) {
    return AsyncState<T>(
      data: clearData ? null : (data ?? this.data),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }

  static AsyncState<T> loading<T>() => AsyncState<T>(isLoading: true);

  static AsyncState<T> success<T>(T data) => AsyncState<T>(data: data);

  static AsyncState<T> failure<T>(String message) => AsyncState<T>(error: message);
}
