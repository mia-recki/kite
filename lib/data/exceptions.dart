import 'package:collection/collection.dart';

sealed class DataParsingException {
  const DataParsingException();
}

class InvalidCategoryListException extends DataParsingException {
  final Map<String, Object?> invalidJson;

  const InvalidCategoryListException({required this.invalidJson});

  @override
  bool operator ==(Object other) =>
      other is InvalidCategoryListException && const DeepCollectionEquality().equals(other.invalidJson, invalidJson);

  @override
  int get hashCode => Object.hash(runtimeType, invalidJson);
}

class InvalidClusterListException extends DataParsingException {
  final Map<String, Object?> invalidJson;

  const InvalidClusterListException({required this.invalidJson});

  @override
  bool operator ==(Object other) =>
      other is InvalidClusterListException && const DeepCollectionEquality().equals(other.invalidJson, invalidJson);

  @override
  int get hashCode => Object.hash(runtimeType, invalidJson);

  @override
  String toString() => 'InvalidClusterListException(invalidJson: $invalidJson)';
}
