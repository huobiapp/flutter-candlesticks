import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/kline_model.dart';
import 'package:candleline/view/kline_single_view.dart';

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
    ScrollController _controller = ScrollController(initialScrollOffset: bloc.rectWidth * bloc.stringList.length-bloc.screenWidth); 
    _controller.addListener(() {
      print(_controller.offset); //打印滚动位置
      int currentIndex = (_controller.offset ~/ bloc.rectWidth).toInt();
      if (currentIndex < 0) {
        return;
      } else if (currentIndex > bloc.stringList.length - count) {
        return;
      }
      bloc.currentIndex = currentIndex;
      bloc.getSubKlineList(currentIndex, currentIndex + count);
    });

    return BlocProvider<KlineBloc>(
        //key: PageStorageKey('market'),
        bloc: bloc,
        child: GestureDetector(
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
                    count = (width ~/ bloc.rectWidth).toInt();
                    bloc.setScreenWith(width);
                    // _controller = ScrollController(initialScrollOffset: bloc.rectWidth * bloc.stringList.length-bloc.screenWidth);
                  }
                  return Container(
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.expand,
                      children: <Widget>[
                        Column(
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
                        Scrollbar(
                            child: SingleChildScrollView(
                                child: Container(
                                  width: bloc.rectWidth * data.length,
                                ),
                                controller: _controller,
                                scrollDirection: Axis.horizontal,
                                )),
                      ],
                    ),
                  );
                })));
  }
}
