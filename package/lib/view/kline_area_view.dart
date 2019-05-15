import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/kline_model.dart';
import 'package:flutter/foundation.dart';

class KlineAreaView extends StatelessWidget {
  KlineAreaView({Key key});
  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = BlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
        stream: klineBloc.outCurrentKlineList,
        builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0, 0)];
          return CustomPaint(
              size: Size.infinite,
              painter: _AreaViewPainter(
                data: tmpList,
                lineWidth: 2,
                max: klineBloc.priceMax,
                min: klineBloc.priceMin,
                rectWidth: klineBloc.rectWidth,
                lineColor: Colors.blue,
              ));
        });
  }
}

class _AreaViewPainter extends CustomPainter {
  _AreaViewPainter({
    Key key,
    @required this.data,
    @required this.max,
    @required this.min,
    this.lineWidth = 1.0,
    this.rectWidth = 7.0,
    this.lineColor = Colors.yellow,
  });

  final List<Market> data;
  final double lineWidth;
  final double rectWidth;
  Color lineColor;
  final double max;
  final double min;

  @override
  void paint(Canvas canvas, Size size) {
    if (min == null || max == null) {
      return;
    }
    double height = size.height - 20 - 20;

    final double heightNormalizer = height / (max - min);
    final Gradient gradient = new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.withAlpha(100),
            Colors.blue.withAlpha(20),
          ],
        );
    Rect screenRect = Rect.fromLTWH(0, 20, size.width, height);

    Paint fillPaint = new Paint()
      ..color = lineColor
      ..shader = gradient.createShader(screenRect)
      ..style = PaintingStyle.fill;
    Paint linePaint = new Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    double beginX = ((0.5) * rectWidth) - lineWidth / 2;
    double beginY = height + 20;

    Path path = new Path()..moveTo(beginX, beginY);
    Path linePath = new Path();

    for (int i = 0; i < data.length; i++) {
      double startX;
      double startY;
      double endX;
      double endY;
      if (i == data.length - 1) {
        startX = ((i + 0.5) * rectWidth) - lineWidth / 2;
        path.lineTo(startX, beginY);
        break;
      }
      startX = ((i + 0.5) * rectWidth) - lineWidth / 2;
      endX = ((i + 1 + 0.5) * rectWidth) - lineWidth / 2;

      startY = height - (data[i].close - min) * heightNormalizer + 20;
      endY = height - (data[i + 1].close - min) * heightNormalizer + 20;
      
      if (i == 0) {
        path.lineTo(startX, startY);
        linePath.moveTo(startX, startY);
      }
      path.lineTo(endX, endY);
      linePath.lineTo(endX, endY);

    }
    canvas.drawPath(path, fillPaint);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(_AreaViewPainter old) {
    return data != null;
  }
}
