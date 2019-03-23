import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:flutter/foundation.dart';

class KlineSolideView extends StatelessWidget {
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
              painter: _SolideViewPainter(
                data:tmpList,
                lineWidth: 1,
                rectWidth: klineBloc.rectWidth,
                lineColor: Colors.yellow,
              )
          );
        });
  }
}

class _SolideViewPainter extends CustomPainter {
  _SolideViewPainter({
    Key key,
    @required this.data,
    this.lineWidth = 1.0,
    this.rectWidth = 7.0,
    this.lineColor = Colors.yellow,
  });

  final List<Market> data;
  final double lineWidth;
  final double rectWidth;
  final Color lineColor;
  double _max;
  double _min;

  update() {
    _max = -double.infinity;
    _min = double.infinity;
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
    if (_max == null || _min == null) {
      update();
    }

    double height = size.height;

    final double heightNormalizer = height / (_max - _min);

    Paint linePaint = new Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    for (int i = 0; i < data.length; i++) {
      if (i == data.length -1) {
        break;
      }
      double startX;
      double startY;
      double endX;
      double endY;
      startX = ((i + 0.5) * rectWidth) - lineWidth / 2;
      endX = ((i+1 + 0.5) * rectWidth) - lineWidth / 2;

      startY = height - (data[i].close - _min) * heightNormalizer;
      endY = height - (data[i+1].close - _min) * heightNormalizer;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);
    }
  }

  @override
  bool shouldRepaint(_SolideViewPainter old) {
    return true;
  }

}