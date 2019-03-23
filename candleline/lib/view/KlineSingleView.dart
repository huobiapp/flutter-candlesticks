import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:candleline/view/KlineCandleView.dart';
import 'package:candleline/view/KlineColumnarView.dart';
class KlineSingleView extends StatefulWidget {

  @override
  KlineSingleViewState createState() => KlineSingleViewState();
}

class KlineSingleViewState extends State<KlineSingleView> {
  KlineBloc klineBloc;
  @override
  void initState() {
    klineBloc = BlocProvider.of<KlineBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: klineBloc.outklineList,
        builder:
            (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
          List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
          if (tmpList.length > 1) {
            double count = MediaQuery.of(context).size.width / klineBloc.rectWidth;
            int num = count.toInt();
            klineBloc.getSubKlineList(0, num);
          }
          return Container(
            margin: EdgeInsets.only(top: 50),
            height: 600,
            color: Colors.black,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: KlineCandleView(),
                  ),
                  flex: 20,
                ),
                Expanded(
                  child: Container(
                    color: Colors.grey,
//                    child: KlineCandleView(),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    color: Colors.black,
                    child: KlineColumnarView(),
                  ),
                  flex: 4,
                ),
              ],
            ),
          );
        });
  }
}
