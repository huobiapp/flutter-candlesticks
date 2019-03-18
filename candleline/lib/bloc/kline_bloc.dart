import 'package:rxdart/rxdart.dart';
import 'package:candleline/common/bloc_provider.dart';
class KlineBloc extends BlocBase {

  BehaviorSubject<List<String>> _klineListController = BehaviorSubject<List<String>>();
  Sink<List<String>> get _inklineList => _klineListController.sink;
  Stream<List<String>> get outklineList => _klineListController.stream;
  List<String> stringList = List();
  KlineBloc() {
    //添加假数据
    addString();
  }
  @override
  void dispose() {
    _klineListController.close();
  }

  void addString() {
    stringList.add('ddd1');
    stringList.add('ddd2');
    stringList.add('ddd3');
    stringList.add('ddd4');
    stringList.add('ddd5');
    _inklineList.add(stringList);
  }
}