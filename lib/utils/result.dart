sealed class Result<T> {
  const Result();

  factory Result.success(T value) => Success(value);
  factory Result.error(Object error) => Failure(error);

  T? get value => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };

  Object? get error => switch (this) {
    Success() => null,
    Failure(:final error) => error,
  };
}

class Success<T> extends Result<T> {
  @override
  final T value;

  const Success(this.value);
}

class Failure<T> extends Result<T> {
  @override
  final Object error;

  const Failure(this.error);
}
