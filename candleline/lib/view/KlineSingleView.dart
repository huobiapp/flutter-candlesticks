import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:candleline/view/KlineCandleView.dart';
import 'package:candleline/view/KlineColumnarView.dart';
import 'package:candleline/view/KlineSolideView.dart';

class KlineSingleView extends StatelessWidget {
  KlineSingleView({
    Key key,
    @required this.type,
  });
  int type = 0;

  @override
  Widget build(BuildContext context) {
    KlineBloc klineBloc = BlocProvider.of<KlineBloc>(context);
    return StreamBuilder(
        stream: klineBloc.outklineList,
        builder: (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
          if (tmpList.length > 1) {
            double count =
                MediaQuery.of(context).size.width / klineBloc.rectWidth;
            int num = count.toInt();
            klineBloc.getSubKlineList(0, num);
          }
          if (type == 0) {
            return Container(
              color: Colors.black,
              child: Stack(
                alignment: Alignment.center,
                fit: StackFit.expand,
                children: <Widget>[
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
                  KlineColumnarView(),
//                  KlineSolideView(),
                ],
              ),
            );
          }
        });
  }
}
