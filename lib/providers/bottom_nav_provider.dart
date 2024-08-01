import 'package:flutter/material.dart';
import 'package:gchat/pages/pages.dart';

class BottomNavModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final List<Widget> _children = [
    const HomePage(),
    const ProfileSettingsPage(),
  ];

  List<Widget> get children => _children;

  updateIndex(int index, context) {
    _currentIndex = index;
    notifyListeners();
  }
}
