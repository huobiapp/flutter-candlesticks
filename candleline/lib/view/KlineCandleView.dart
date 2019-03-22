import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:flutter/foundation.dart';

class KlineCandleView extends StatefulWidget {

  @override
  KlineCandleViewState createState() => KlineCandleViewState();
}

class KlineCandleViewState extends State<KlineCandleView> {
  KlineBloc klineBloc;
  @override
  void initState() {
    klineBloc = BlocProvider.of<KlineBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: klineBloc.outCurrentKlineList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
          String listString = '';
          for (Market market in tmpList) {
            listString = listString + market.open.toString();
          }
          return CustomPaint(
            size: Size.infinite,
            painter: _CandleViewPainter(
              data:tmpList,
              lineWidth: 1,
              rectWidth: klineBloc.rectWidth,
              increaseColor: Colors.red,
              decreaseColor: Colors.green
            )
          );
        });
  }
}

class _CandleViewPainter extends CustomPainter {
  _CandleViewPainter({
    Key key,
    @required this.data,
    this.lineWidth = 1.0,
    this.rectWidth = 7.0,
    this.increaseColor = Colors.red,
    this.decreaseColor = Colors.green
  });

  final List<Market> data;
  final double lineWidth;
  final double rectWidth;
  final Color increaseColor;
  final Color decreaseColor;
  double _min;
  double _max;

  update() {
    _min = double.infinity;
    _max = -double.infinity;
    for (var i in data) {
      if (i.high > _max) {
        _max = i.high;
      }
      if (i.low < _min) {
        _min = i.low;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_min == null || _max == null) {
      update();
    }

    double width = size.width;
    double height = size.height;

    final double heightNormalizer = height / (_max - _min);

    double rectLeft;
    double rectTop;
    double rectRight;
    double rectBottom;

    Paint rectPaint;

    for (int i = 0; i < data.length; i++) {
      rectLeft = (i * rectWidth) + lineWidth / 2;
      rectRight = ((i + 1) * rectWidth) - lineWidth / 2;

      if (data[i].open > data[i].close) {
        rectPaint = new Paint()
          ..color = decreaseColor
          ..strokeWidth = lineWidth;
      } else {
        rectPaint = new Paint()
          ..color = increaseColor
          ..strokeWidth = lineWidth;
      }

      // Draw candlestick if decrease
      rectTop = height - (data[i].open - _min) * heightNormalizer;
      rectBottom = height - (data[i].close - _min) * heightNormalizer;
      Rect ocRect =
      new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
      canvas.drawRect(ocRect, rectPaint);

      // Draw low/high candlestick wicks
      double low = height - (data[i].low - _min) * heightNormalizer;
      double high = height - (data[i].high - _min) * heightNormalizer;
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectBottom),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, low),
          rectPaint);
      canvas.drawLine(
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, rectTop),
          new Offset(rectLeft + rectWidth / 2 - lineWidth / 2, high),
          rectPaint);
    }
  }

  @override
  bool shouldRepaint(_CandleViewPainter old) {
    return true;
  }

}