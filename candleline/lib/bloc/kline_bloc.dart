import 'package:rxdart/rxdart.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import 'package:candleline/model/model.dart';
class KlineBloc extends BlocBase {

  BehaviorSubject<List<Market>> _klineListController = BehaviorSubject<List<Market>>();
  Sink<List<Market>> get _inklineList => _klineListController.sink;
  Stream<List<Market>> get outklineList => _klineListController.stream;
  List<Market> stringList = List();
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
    Future<String> future =loadAsset();
    future.then((value) {
      print(value);
      final parseJson = json.decode(value);
       MarketData marketData = MarketData.fromJson(parseJson);
       stringList.addAll(marketData.data);

    });
    _inklineList.add(stringList);
  }
  Future<String> loadAsset() async {
  return await rootBundle.loadString('json/market.json');
}
}