import 'package:flutter/material.dart';

class AppointmentProvider extends ChangeNotifier{

  DateTime bookDate = DateTime.now();
  String timeSetAdd = "";
  bool twoPmTime = false,threePmTime = false,fourPmTime = false;
  bool fivePmTime = false,sixPmTime = false,sevenPMTime = false;
  bool eightAmTime = false,eightPmTime = false,nineAmTime = false;
  bool tenAmTime = false,elevenAmTime = false,twelvePmTime = false;

  getDate() {
    notifyListeners();
    return bookDate;
  }

  get getEightAmTime {
    if(eightAmTime == false){
      eightAmTime = true;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getEightPmTime {
    if(eightPmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = true;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getNineAmTime {
    if(nineAmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = true;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getTenAmTime {
    if(tenAmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = true;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getElevenAmTime {
    if(elevenAmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = true;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getTwelvePmTime {
    if(twelvePmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = true;
      notifyListeners();
    }
  }

  get getTwoPmTime {
    if(twoPmTime == false){
      eightAmTime = false;
      twoPmTime = true;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getThreePmTime {
    if(threePmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = true;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getFourPmTime {
    if(fourPmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = true;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getFivePmTime {
    if(fivePmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = true;
      sixPmTime = false;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getSixPmTime {
    if(sixPmTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = true;
      sevenPMTime = false;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

  get getSevenPmTime {
    if(sevenPMTime == false){
      eightAmTime = false;
      twoPmTime = false;
      threePmTime = false;
      fourPmTime = false;
      fivePmTime = false;
      sixPmTime = false;
      sevenPMTime = true;
      eightPmTime = false;
      nineAmTime = false;
      tenAmTime = false;
      elevenAmTime = false;
      twelvePmTime = false;
      notifyListeners();
    }
  }

   onWillPop(context){
    bookDate = DateTime.now();
    timeSetAdd = "";
    eightAmTime = false;
    twoPmTime = false;
    threePmTime = false;
    fourPmTime = false;
    fivePmTime = false;
    sixPmTime = false;
    sevenPMTime = false;
    eightPmTime = false;
    nineAmTime = false;
    tenAmTime = false;
    elevenAmTime = false;
    twelvePmTime = false;
    notifyListeners();
  }
}