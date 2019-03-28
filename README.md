# candleline
## 基于Flutter实现k线功能

### 目前为测试版本，功能还在完善中

### 版本号
v0.1.0

### 主要功能
* K线蜡烛图,交易量柱状图,MA5,MA10,MA30
* 可滑动，可缩放
* 基于rxDart,BLoC 状态管理,数据与视图分离

### 使用方法

#### 在pubspec.yaml ependencies:下添加package
```
dependencies:
  candleline:
    path: ../../package path为package实际路径
```

#### 引入candleline
```
import 'package:candleline/candleline.dart';

```

#### 初始化bloc


```
class KlinePageBloc extends KlineBloc {
  @override
  //重写init方法
  void initData() {
      //...获取数据
      //处理成 List<KlineData> 格式
      List<KlineData> list = List<KlineData>();
      //数据返回后调用 updateDataList(list)传递数据
      this.updateDataList(list);
    });
    super.initData();
  }
}
```
#### 初始化klineView
```
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
```
