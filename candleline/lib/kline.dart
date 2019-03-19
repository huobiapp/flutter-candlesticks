import 'package:flutter/material.dart';
import 'package:candleline/bloc/kline_bloc.dart';
import 'package:candleline/common/bloc_provider.dart';
import 'package:candleline/model/model.dart';
class KlinePage extends StatefulWidget {
  KlinePage({Key key}) : super(key: key);
  @override
  _KlinePageState createState() => _KlinePageState();
}

class _KlinePageState extends State<KlinePage> {
  KlineBloc klineBloc = KlineBloc();

  @override
  Widget build(BuildContext context) {
    // klineBloc = BlocProvider.of<KlineBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('kline'),
      ),
      body: BlocProvider<KlineBloc>(
        //key: PageStorageKey('market'),
        bloc: klineBloc,
        child: StreamBuilder(
            stream: klineBloc.outklineList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Market>> snapshot) {
              List<Market> tmpList = snapshot.data ?? [Market(0, 0, 0, 0, 0)];
              String listString = '';
              for (Market market in tmpList) {
                listString = listString + market.open.toString();
              }
              return Center(
                child: 
                Text('数据:' + listString)
                );
            }),
      ),
      
    );
  }
}
