extension RefreshTime on DateTime {
  /// Returns [DateTime] of the next data refresh
  DateTime get refreshTime {
    final noonUtc = _noonUTC;
    return noonUtc.isBefore(this) ? noonUtc.add(const Duration(days: 1)) : noonUtc;
  }

  /// Returns a [DateTime] matching noon UTC on the same day as this [DateTime]
  DateTime get _noonUTC => toUtc().copyWith(hour: 12, minute: 0, second: 0, millisecond: 0, microsecond: 0);
}
