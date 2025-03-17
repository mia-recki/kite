/// Represents a news category, as fetched from `/kite.json`
class Category {
  final String name;
  final String file;

  const Category({required this.name, required this.file});

  @override
  bool operator ==(Object other) => other is Category && other.name == name && other.file == file;

  @override
  int get hashCode => Object.hash(name, file);

  @override
  String toString() => '$name($file)';
}
