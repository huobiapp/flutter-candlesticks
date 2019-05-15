import 'package:flutter/material.dart';
import 'package:candleline/view/kline_candle_view.dart';
import 'package:candleline/view/kline_columnar_view.dart';
import 'package:candleline/view/kline_solide_view.dart';
import 'package:candleline/view/kline_separate_view.dart';
import 'package:candleline/view/kline_area_view.dart';
class KlineSingleView extends StatelessWidget {
  KlineSingleView({
    Key key,
    @required this.type,
  });
  final int type;

  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            KlineSeparateView(type: 0),
            KlineCandleView(),
            KlineSolideView(type: 0),
            KlineSolideView(type: 1),
            KlineSolideView(type: 2)
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: <Widget>[
            KlineSeparateView(type: 1),
            KlineColumnarView(),
//                  KlineSolideView(),
          ],
        ),
      );
    }
  }
}


