import 'package:flutter/material.dart';
import 'package:candleline/bloc/KlineBloc.dart';
import 'package:candleline/common/BlocProvider.dart';
import 'package:candleline/model/KlineModel.dart';
import 'package:candleline/view/KlineCandleView.dart';
import 'package:candleline/view/KlineColumnarView.dart';
import 'package:candleline/view/KlineSolideView.dart';
import 'package:candleline/view/KlineSeparateView.dart';
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


