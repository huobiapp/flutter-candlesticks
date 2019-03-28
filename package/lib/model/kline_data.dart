import 'package:flutter/material.dart';
class KlineData {
  KlineData({Key key, this.open, this.high, this.low, this.close, this.vol, this.date});
  double open;
  double high;
  double low;
  double close;
  double vol;
  int date;
}