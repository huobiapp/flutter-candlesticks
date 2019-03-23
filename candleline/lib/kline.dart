import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
import 'package:candleline/view/KlineSingleView.dart';
import 'package:rxdart/rxdart.dart';

class KlinePage extends StatefulWidget {
  KlinePage({Key key}) : super(key: key);
  @override
  _KlinePageState createState() => _KlinePageState();
}

class _KlinePageState extends State<KlinePage> {
  KlineBloc klineBloc = KlineBloc();
  Offset lastPoint;
  int offset;
  double lastScale;
  int count;
  double currentRectWidth;
  bool isScale = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kline'),
      ),
      body: BlocProvider<KlineBloc>(
          //key: PageStorageKey('market'),
          bloc: klineBloc,
          child: GestureDetector(
              //开始拖动
              onHorizontalDragStart: (details) {
                lastPoint = details.globalPosition;
              },
              //结束拖动
              onHorizontalDragUpdate: (details) {
                int num = ((details.globalPosition.dx - lastPoint.dx) /
                        klineBloc.rectWidth)
                    .toInt();
//            print(details.globalPosition.dx - lastPoint.dx);
                if (num == offset || isScale) {
                  return;
                }
//            print(num);

                if (klineBloc.stringList.length > 1) {
                  int currentIndex = klineBloc.currentIndex - num;
                  if (currentIndex <= 0) {
                    return;
                  }
                  if (currentIndex > klineBloc.stringList.length - count) {
                    return;
                  }
                  lastPoint = details.globalPosition;
                  klineBloc.getSubKlineList(currentIndex, currentIndex + count);
                  klineBloc.currentIndex = currentIndex;
                  offset = num;
                }
              },
              onScaleStart: (details) {
                currentRectWidth = klineBloc.rectWidth;
                isScale = true;
              },
              onScaleUpdate: (details) {
                double scale = details.scale;
                if (scale == 1.0) {
                  return;
                }
                print(details.scale);
                lastScale = details.scale;
                double rectWidth = scale * currentRectWidth;
                klineBloc.setRectWidth(rectWidth);
              },
              onScaleEnd: (details) {
                isScale = false;
              },
              child: StreamBuilder(
                  stream: klineBloc.outRectWidth,
                  builder:
                      (BuildContext context, AsyncSnapshot<double> snapshot) {
                    double rectWidth = snapshot.data ?? 7.0;
                    count = (MediaQuery.of(context).size.width /
                            klineBloc.rectWidth)
                        .toInt();
                    return Container(
                      margin: EdgeInsets.only(top: 10,bottom: 20),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.black,
                              child: KlineSingleView(type: 0),
                            ),
                            flex: 20,
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.black,
                              child: KlineSingleView(type: 1),
                            ),
                            flex: 4,
                          ),
                        ],
                      ),
                    );
                  }))),
    );
  }
}
