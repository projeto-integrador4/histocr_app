import 'package:flutter/material.dart';

class BaseProvider with ChangeNotifier {
  bool loading = false;
  bool success = true;

  void setLoading(bool status) {
    loading = status;
    notifyListeners();
  }
}