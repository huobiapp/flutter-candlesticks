import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:flutter/foundation.dart';

class KlineSolideView extends StatelessWidget {
  KlineSolideView({Key key, @required this.type});
  int type; //0 pricema1,1 pricema2,2 pricema3
  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = BlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
        stream: klineBloc.outCurrentKlineList,
        builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
          return CustomPaint(
              size: Size.infinite,
              painter: _SolideViewPainter(
                  data: tmpList,
                  lineWidth: 1,
                  rectWidth: klineBloc.rectWidth,
                  lineColor: Colors.yellow,
                  type: type));
        });
  }
}

class _SolideViewPainter extends CustomPainter {
  _SolideViewPainter(
      {Key key,
      @required this.data,
      this.lineWidth = 1.0,
      this.rectWidth = 7.0,
      this.lineColor = Colors.yellow,
      @required this.type});

  final int type;
  final List<Market> data;
  final double lineWidth;
  final double rectWidth;
  Color lineColor;
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

    for (int i = 0; i < data.length; i++) {
      if (i == data.length - 1) {
        break;
      }
      if ((data[i].priceMa1 == null && type == 0) ||
          (data[i].priceMa2 == null && type == 1) ||
          (data[i].priceMa3 == null && type == 2)) {
        continue;
      }
      double startX;
      double startY;
      double endX;
      double endY;
      startX = ((i + 0.5) * rectWidth) - lineWidth / 2;
      endX = ((i + 1 + 0.5) * rectWidth) - lineWidth / 2;

      switch (type) {
        case 0:
          {
            startY = height - (data[i].priceMa1 - _min) * heightNormalizer;
            endY = height - (data[i + 1].priceMa1 - _min) * heightNormalizer;
            break;
          }
        case 1:
          {
            startY = height - (data[i].priceMa2 - _min) * heightNormalizer;
            endY = height - (data[i + 1].priceMa2 - _min) * heightNormalizer;
            lineColor = Colors.blue;
            break;
          }
        case 2:
          {
            startY = height - (data[i].priceMa3 - _min) * heightNormalizer;
            endY = height - (data[i + 1].priceMa3 - _min) * heightNormalizer;
            lineColor = Colors.purple;
            break;
          }
        default:
          {
            break;
          }
      }
      Paint linePaint = new Paint()
        ..color = lineColor
        ..strokeWidth = lineWidth;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), linePaint);
    }
  }

  @override
  bool shouldRepaint(_SolideViewPainter old) {
    return true;
  }
}
