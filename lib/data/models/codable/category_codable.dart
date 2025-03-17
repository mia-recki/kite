import '../../../utils/result.dart';
import '../../exceptions.dart';
import '../category.dart';

/// Decodes the JSON response from `/kite.json`
class CategoryCodable {
  static Result<List<Category>> decode(Map<String, Object?> json) => switch (json['categories']) {
    final List<dynamic> categories => Success(
      categories
          .map((categoryJson) {
            if (categoryJson case {'name': final String name, 'file': final String file}) {
              return Category(name: name, file: file);
            }
          })
          .nonNulls
          .toList(),
    ),

    _ => Result.error(InvalidCategoryListException(invalidJson: json)),
  };
}
