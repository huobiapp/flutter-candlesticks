// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketModel _$MarketModelFromJson(Map<String, dynamic> json) {
  return MarketModel(
      (json['open'] as num)?.toDouble(),
      (json['high'] as num)?.toDouble(),
      (json['low'] as num)?.toDouble(),
      (json['close'] as num)?.toDouble(),
      (json['vol'] as num)?.toDouble())
    ..amount = (json['amount'] as num)?.toDouble()
    ..count = (json['count'] as num)?.toDouble()
    ..date = json['id'] as int;
}

Map<String, dynamic> _$MarketModelToJson(MarketModel instance) =>
    <String, dynamic>{
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'vol': instance.vol,
      'amount': instance.amount,
      'count': instance.count,
      'id': instance.date
    };

MarketData _$MarketDataFromJson(Map<String, dynamic> json) {
  return MarketData((json['data'] as List)
      ?.map((e) =>
          e == null ? null : MarketModel.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$MarketDataToJson(MarketData instance) =>
    <String, dynamic>{'data': instance.data};
