import 'package:flutter/material.dart';
import 'package:candleline/bloc/KlineBloc.dart';
import 'package:candleline/common/BlocProvider.dart';
import 'package:candleline/model/model.dart';
import 'package:candleline/view/KlineSingleView.dart';
import 'package:rxdart/rxdart.dart';

class KlinePage extends StatefulWidget {
  KlinePage({Key key}) : super(key: key);

  @override
  _KlinePageState createState() => _KlinePageState();
}

class _KlinePageState extends State<KlinePage>
    with SingleTickerProviderStateMixin {
  KlineBloc klineBloc = KlineBloc();
  Offset lastPoint;
  int offset;
  double lastScale;
  int count;
  double currentRectWidth;
  bool isScale = false;

  // ==== 负责惯性滑动动画
  AnimationController controller;
  Animation<int> animation;
  Function listener;

  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                count =
                    (MediaQuery.of(context).size.width ~/ klineBloc.rectWidth)
                        .toInt();
              },
              //结束拖动
              onHorizontalDragUpdate: (details) {
                double offsetX = details.globalPosition.dx - lastPoint.dx;
                int num = (offsetX ~/
                        klineBloc.rectWidth)
                    .toInt();
//            print(details.globalPosition.dx - lastPoint.dx);
                if (isScale /*|| num == offset*/) {
                  return;
                }
                if (num == 0) {
                  return;
                }
           print(num);

                if (klineBloc.stringList.length > 1) {
                  int currentIndex = klineBloc.currentIndex - num;
                  if (currentIndex < 0) {
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
              onHorizontalDragEnd: (details) {
                // if(offset > 0) {
                //   _fling(4);
                // } else {
                //   _fling(-4);
                // }
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
                count =
                    (MediaQuery.of(context).size.width ~/ klineBloc.rectWidth)
                        .toInt();
                klineBloc.setRectWidth(rectWidth);
                klineBloc.getSubKlineList(
                    klineBloc.currentIndex, klineBloc.currentIndex + count);
              },
              onScaleEnd: (details) {
                isScale = false;
              },
              child: StreamBuilder(
                  stream: klineBloc.outklineList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Market>> snapshot) {
                    List<Market> data = snapshot.data;
                    if (data != null && klineBloc.klineList.length == 0) {
                      double width = MediaQuery.of(context).size.width;
                      klineBloc.setScreenWith(width);
                    }
                    return Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
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
                  }))),
    );
  }

  _fling(int countX) {
    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    animation = Tween<int>(begin: countX, end: 0).animate(curve);
    listener = () {
      if (animation.value == 0) return;
      int num = countX;
      if (isScale) {
        _resetFlingAnim();
        return;
      }
      if (klineBloc.stringList.length > 1) {
        int currentIndex = klineBloc.currentIndex - num;
        if (currentIndex < 0) {
          _resetFlingAnim();
          return;
        }
        if (currentIndex > klineBloc.stringList.length - count) {
          _resetFlingAnim();
          return;
        }
        klineBloc.getSubKlineList(currentIndex, currentIndex + count);
        klineBloc.currentIndex = currentIndex;
        offset = num;
      }
    };

    animation.addListener(listener);

    controller.forward(from: 0.0);
  }
  _resetFlingAnim() {
    animation?.removeListener(listener);
    controller?.reset();
  }
}
