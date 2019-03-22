import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class KlineModel {
  Color lineColor;

}

class KlineCandleModel extends KlineModel {
  KlineCandleModel(
      this.hPrice,
      this.lPrice,
      this.openPrice,
      this.closePrice,
      this.time,
      this.change,
      this.volume,
      this.business,
      this.changePrice
      );
  double hPrice;
  double lPrice;
  double openPrice;
  double closePrice;
  int time;
  double change;
  double volume;
  double business;
  double changePrice;

}

class KlineColumnarPriceData extends KlineModel {
  KlineColumnarPriceData(
      this.hPrice,
      this.lPrice
      );
  double hPrice;
  double lPrice;
}

class KlineCandleData {
  Offset hPoint;
  Offset lPoint;
  Offset openPoint;
  Offset closePoint;
  double hPrice;
  double lPrice;
  int nDataIndex;

}


