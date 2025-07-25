import 'package:flutter/material.dart';

class Calc_Provider extends ChangeNotifier{
  int num1=0;
  int num2=0;
  int res=0;

  void setAdd(int val,int val1){
    num1=val;
    num2=val1;
    res=num1+num2;
    notifyListeners();
  }
  void setSub(int val,int val1){
    num1=val;
    num2=val1;
    res=num1-num2;
    notifyListeners();
  }
  void setMul(int val,int val1){
    num1=val;
    num2=val1;
    res=num1*num2;
    notifyListeners();
  }
  void setDiv(int val,int val1){
    num1=val;
    num2=val1;
    res=num1~/num2;
    notifyListeners();
  }
  void setMod(int val,int val1){
    num1=val;
    num2=val1;
    res=num1%num2;
    notifyListeners();
  }
  void setClear(){
    num1=0;
    num2=0;
    res=0;
    notifyListeners();
  }
}