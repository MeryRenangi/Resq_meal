import 'package:flutter/foundation.dart';

/// Tracks bottom navigation index for UI that is not driven solely by [GoRouter].
class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }
}
