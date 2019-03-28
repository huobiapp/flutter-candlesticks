import 'package:flutter/material.dart';
import 'package:candleline/candleline.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:async' show Future;
import 'dart:convert';
import 'package:example/model/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candleline Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Candleline Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('json/market.json');
}

class KlinePageBloc extends KlineBloc {
  @override
  //重写init方法
  void initData() {
    Future<String> future = loadAsset();
    future.then((value) {
      final parseJson = json.decode(value);
      MarketData marketData = MarketData.fromJson(parseJson);
      List<KlineData> list = List<KlineData>();
      for (var item in marketData.data) {
        list.add(KlineData(
            open: item.open,
            close: item.close,
            high: item.high,
            low: item.low,
            vol: item.amount,
            date: item.date));
      }
      //数据返回后调用 updateDataList(list);
      this.updateDataList(list);
    });
    super.initData();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  void _pushToKline() {
    KlinePageBloc bloc = KlinePageBloc();
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(
            title: Text('klineDemo'),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: KlinePage(bloc: bloc))
          );
    }));
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushToKline,
        tooltip: 'kline',
        child: Icon(Icons.publish),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
