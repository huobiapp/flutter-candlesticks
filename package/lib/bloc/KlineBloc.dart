import 'package:rxdart/rxdart.dart';
import 'package:candleline/common/BlocProvider.dart';
import 'package:candleline/model/KlineModel.dart';
import 'package:candleline/manager/KlineDataCalculateManager.dart';
import 'dart:math';
import 'package:candleline/model/KlineData.dart';
class KlineBloc extends BlocBase {
  BehaviorSubject<List<Market>> _klineListController =
      BehaviorSubject<List<Market>>();
  PublishSubject<List<Market>> _klineCurrentListController =
      PublishSubject<List<Market>>();

  Sink<List<Market>> get _inklineList => _klineListController.sink;
  Stream<List<Market>> get outklineList => _klineListController.stream;

  Sink<List<Market>> get _inCurrentKlineList =>
      _klineCurrentListController.sink;
  Stream<List<Market>> get outCurrentKlineList =>
      _klineCurrentListController.stream;

  List<Market> klineList = List();
  List<Market> stringList = List();

  //当前k线滑到的位置
  int currentIndex = 0;
  //当前线宽
  double rectWidth = 7.0;
  double screenWidth = 375;

    //当前显示的最大最小值数据
  double priceMax;
  double priceMin;
  double volumeMax;

  KlineBloc() {
    initData();
  }

  void initData() {

  }
  @override
  void dispose() {
    _klineListController.close();
  }

  void updateDataList(List<KlineData> dataList) {
    if (dataList != null && dataList.length > 0) {
      stringList.clear();
      for (var item in dataList) {
        Market data = Market(item.open, item.high, item.low, item.close, item.vol);
        stringList.add(data);
      }
      //计算Ma均线
      stringList = KlineDataCalculateManager.calculateKlineData(ChartType.MA, stringList);
      _inklineList.add(stringList);
    }
  }

  void setScreenWith(double width) {
    screenWidth = width;
    double count = screenWidth / rectWidth;
    int num = count.toInt();
    getSubKlineList(0, num);
  }

  void getSubKlineList(int from, int to) {
    List<Market> list = this.stringList;
    klineList = list.sublist(from,to);
    calculateLimit();
    _inCurrentKlineList.add(klineList);
  }

  void setRectWidth(double width) {
    if (width > 25.0 || width < 2.0) {
      return;
    }
    rectWidth = width;
  }
  //计算最大最小值
  void calculateLimit() {
    double _priceMax = -double.infinity;
    double _priceMin = double.infinity;
    double _volumeMax = -double.infinity;
    for (var i in klineList) {
      _volumeMax = max(i.volumeto, _volumeMax);

      _priceMax = max(_priceMax, i.high);
      _priceMin = min(_priceMin, i.low);

      if (i.priceMa1 != null) {
        _priceMax = max(_priceMax, i.priceMa1);
        _priceMin = min(_priceMin, i.priceMa1);
      }
      if (i.priceMa2 != null) {
        _priceMax = max(_priceMax, i.priceMa2);
        _priceMin = min(_priceMin, i.priceMa2);
      }
      if (i.priceMa3 != null) {
        _priceMax = max(_priceMax, i.priceMa3);
        _priceMin = min(_priceMin, i.priceMa3);
      }

    }
    priceMax = _priceMax;
    priceMin = _priceMin;
    volumeMax = _volumeMax;
  }      
}
