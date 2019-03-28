import 'package:flutter/material.dart';
import 'package:candleline/bloc/KlineBloc.dart';
import 'package:candleline/common/BlocProvider.dart';
import 'package:candleline/model/KlineModel.dart';
import 'package:candleline/view/KlineSingleView.dart';

class KlinePage extends StatelessWidget {
  KlinePage({Key key, @required this.bloc}) : super(key: key);
  final KlineBloc bloc;
  @override
  Widget build(BuildContext context) {
    Offset lastPoint;
    int offset;
    double lastScale;
    int count;
    double currentRectWidth;
    bool isScale = false;

    return BlocProvider<KlineBloc>(
        //key: PageStorageKey('market'),
        bloc: bloc,
        child: GestureDetector(
            //开始拖动
            onHorizontalDragStart: (details) {
              lastPoint = details.globalPosition;
              count =
                  (MediaQuery.of(context).size.width ~/ bloc.rectWidth).toInt();
            },
            //结束拖动
            onHorizontalDragUpdate: (details) {
              double offsetX = details.globalPosition.dx - lastPoint.dx;
              int num = (offsetX ~/ bloc.rectWidth).toInt();
//            print(details.globalPosition.dx - lastPoint.dx);
              if (isScale /*|| num == offset*/) {
                return;
              }
              if (num == 0) {
                return;
              }
              print(num);

              if (bloc.stringList.length > 1) {
                int currentIndex = bloc.currentIndex - num;
                if (currentIndex < 0) {
                  return;
                }
                if (currentIndex > bloc.stringList.length - count) {
                  return;
                }
                lastPoint = details.globalPosition;
                bloc.getSubKlineList(currentIndex, currentIndex + count);
                bloc.currentIndex = currentIndex;
                offset = num;
              }
            },
            onHorizontalDragEnd: (details) {
              // if(offset > 0) {
              //   _fling(4);
              // } else {
              //   _fling(-4);
              // }
            },
            onScaleStart: (details) {
              currentRectWidth = bloc.rectWidth;
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
              count =
                  (MediaQuery.of(context).size.width ~/ bloc.rectWidth).toInt();
              bloc.setRectWidth(rectWidth);
              bloc.getSubKlineList(
                  bloc.currentIndex, bloc.currentIndex + count);
            },
            onScaleEnd: (details) {
              isScale = false;
            },
            child: StreamBuilder(
                stream: bloc.outklineList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Market>> snapshot) {
                  List<Market> data = snapshot.data;
                  if (data != null) {
                    double width = MediaQuery.of(context).size.width;
                    bloc.setScreenWith(width);
                  }
                  return Container(
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
                          ),
                          flex: 1,
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
                })));
  }
}
