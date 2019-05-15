import 'package:flutter/material.dart';
import 'package:candleline/view/kline_candle_view.dart';
import 'package:candleline/view/kline_columnar_view.dart';
import 'package:candleline/view/kline_solide_view.dart';
import 'package:candleline/view/kline_separate_view.dart';
import 'package:candleline/view/kline_area_view.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';

class KlineSingleView extends StatelessWidget {
  KlineSingleView({
    Key key,
    @required this.type,
  });
  final int type;

  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = BlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
        stream: klineBloc.outRealTimeOpen,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool isOpenRealTime = false;
          if (snapshot.data != null) {
            isOpenRealTime = snapshot.data;
          }
          if (type == 0) {
            List<Widget> widgetList = List<Widget>();
            if (isOpenRealTime == true) {
              widgetList = [KlineSeparateView(type: 0), KlineAreaView()];
            } else {
              widgetList = [
                KlineSeparateView(type: 0),
                KlineCandleView(),
                KlineSolideView(type: 0),
                KlineSolideView(type: 1),
                KlineSolideView(type: 2)
              ];
            }
            return Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: widgetList,
              ),
            );
          } else {
            List<Widget> widgetList = List<Widget>();
            if (isOpenRealTime == true) {
              widgetList = [
                KlineSeparateView(type: 1),
                KlineColumnarView(type: 1),
              ];
            } else {
              widgetList = [
                KlineSeparateView(type: 1),
                KlineColumnarView(type: 0),
              ];
            }
            return Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: widgetList,
              ),
            );
          }});
  }
}
