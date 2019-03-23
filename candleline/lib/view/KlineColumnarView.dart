import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:flutter/foundation.dart';

class KlineColumnarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = BlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
        stream: klineBloc.outCurrentKlineList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
          return CustomPaint(
              size: Size.infinite,
              painter: _ColumnarViewPainter(
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

class _ColumnarViewPainter extends CustomPainter {
  _ColumnarViewPainter({
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
  double _max;

  update() {
    _max = -double.infinity;
    for (var i in data) {
      if (i.volumeto > _max) {
        _max = i.volumeto;
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_max == null) {
      update();
    }

    double height = size.height;

    final double heightNormalizer = height / (_max);

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
      rectTop = height - (data[i].volumeto) * heightNormalizer;
      rectBottom = height;
      Rect ocRect =
      new Rect.fromLTRB(rectLeft, rectTop, rectRight, rectBottom);
      canvas.drawRect(ocRect, rectPaint);

    }
  }

  @override
  bool shouldRepaint(_ColumnarViewPainter old) {
    return true;
  }

}