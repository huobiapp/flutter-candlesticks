// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Market _$MarketFromJson(Map<String, dynamic> json) {
  return Market(
      (json['open'] as num)?.toDouble(),
      (json['high'] as num)?.toDouble(),
      (json['low'] as num)?.toDouble(),
      (json['close'] as num)?.toDouble(),
      (json['volumeto'] as num)?.toDouble());
}

Map<String, dynamic> _$MarketToJson(Market instance) => <String, dynamic>{
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volumeto': instance.volumeto
    };

MarketData _$MarketDataFromJson(Map<String, dynamic> json) {
  return MarketData((json['data'] as List)
      ?.map(
          (e) => e == null ? null : Market.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$MarketDataToJson(MarketData instance) =>
    <String, dynamic>{'data': instance.data};
