import 'package:json_annotation/json_annotation.dart';
part 'model.g.dart';

@JsonSerializable()
class Market{
  Market(this.open, this.high, this.low, this.close, this.volumeto);
  double open;
  double high;
  double low;
  double close;
  double volumeto;
  //不同的类使用不同的mixin即可
  factory Market.fromJson(Map<String, dynamic> json) => _$MarketFromJson(json);
  Map<String, dynamic> toJson() => _$MarketToJson(this);
}
@JsonSerializable()
class MarketData {
  MarketData(this.data);
  @JsonKey(name: 'data')
  List<Market> data;




  factory MarketData.fromJson(Map<String, dynamic> json) => _$MarketDataFromJson(json);
  Map<String, dynamic> toJson() => _$MarketDataToJson(this);
}




