/*
 helper for image upload
 */
import 'package:flutter/widgets.dart';


class ImageUploadProvider with ChangeNotifier {
  String _viewState = "IDLE";
   get getViewState => _viewState;

  void setToLoading() {
    _viewState = "LOADING";
    notifyListeners();
  }

  void setToIdle() {
    _viewState = "IDLE";
    notifyListeners();
  }
}
