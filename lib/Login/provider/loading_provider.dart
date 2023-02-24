import 'package:flutter/foundation.dart';

class LoadingProvider extends ChangeNotifier{
  bool isLoading=false;

  void startLoading(){
    isLoading=true;
    notifyListeners();
  }
  void stopLoading(){
    isLoading=false;
    notifyListeners();
  }
}