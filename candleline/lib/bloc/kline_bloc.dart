import 'package:rxdart/rxdart.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import 'package:candleline/model/model.dart';
import 'package:flutter/material.dart';

class KlineBloc extends BlocBase {
  BehaviorSubject<List<Market>> _klineListController =
      BehaviorSubject<List<Market>>();
  BehaviorSubject<List<Market>> _klineCurrentListController =
      BehaviorSubject<List<Market>>();
  BehaviorSubject<double> _klineRectWidthController =
  BehaviorSubject<double>();


  Sink<List<Market>> get _inklineList => _klineListController.sink;
  Stream<List<Market>> get outklineList => _klineListController.stream;

  Sink<List<Market>> get _inCurrentKlineList =>
      _klineCurrentListController.sink;
  Stream<List<Market>> get outCurrentKlineList =>
      _klineCurrentListController.stream;

  Sink<double> get _inRectWidth =>
      _klineRectWidthController.sink;
  Stream<double> get outRectWidth =>
      _klineRectWidthController.stream;


  List<Market> klineList = List();
  List<Market> stringList = List();

  //当前k线滑到的位置
  int currentIndex = 0;
  //当前线宽
  double rectWidth = 7.0;

  KlineBloc() {
    //添加假数据
    addString();
  }
  @override
  void dispose() {
    _klineListController.close();
  }

  void addString() {
    // String data = loadAsset();
    Future<String> future = loadAsset();
    future.then((value) {
      final parseJson = json.decode(value);
      MarketData marketData = MarketData.fromJson(parseJson);
      stringList.addAll(marketData.data);
      _inklineList.add(stringList);
    });
  }

  void getSubKlineList(int from, int to) {
    klineList.clear();
    int i = from;
    if (i < 0) {
      i = 0;
    }
    List<Market> list = this.stringList;
    for (i; i <= to && i < list.length; i++) {
      Market data = list[i];
      klineList.add(data);
    }
    _inCurrentKlineList.add(klineList);
  }
  void setRectWidth(double width) {
    if (width > 16.0 || width < 1.0) {
      return;
    }
    rectWidth = width;
    _inCurrentKlineList.add(klineList);
    _inRectWidth.add(rectWidth);
  }
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('json/market.json');
}
