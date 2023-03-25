/// A class that provides a stream of ticks.
class SlideShowTicker {
  /// Returns a stream of ticks.
  /// [interval] is the time between ticks in seconds.
  static Stream<int> tick({int interval = 1}) {
    return Stream.periodic(Duration(seconds: interval), (x) => x);
  }
}
