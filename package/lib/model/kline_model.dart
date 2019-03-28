import 'package:flutter/material.dart';

class Market{
  Market(this.open, this.high, this.low, this.close, this.volumeto);
  double open;
  double high;
  double low;
  double close;
  double volumeto;

  //指标线数据
  double priceMa1;
  double priceMa2;
  double priceMa3;
  double volMa1;
  double volMa2;

}


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


