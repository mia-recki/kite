extension Split on String {
  /// Splits this string on the first occurrence of ': '.
  (String, String) get colonSplit => splitOnFirst(': ');

  /// Splits this string on the first occurrence of [pattern].
  (String, String) splitOnFirst(String pattern) => switch (indexOf(pattern)) {
    -1 => (this, ''),
    final int index => (substring(0, index), substring(index + pattern.length)),
  };
}
