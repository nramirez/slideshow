/// Ticker which uses periodic stream to tick every second
class SlideShowTicker {
  static Stream<int> tick({int interval = 1}) {
    return Stream.periodic(Duration(seconds: interval), (x) => x);
  }
}
