// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemData _$OrderItemDataFromJson(Map<String, dynamic> json) =>
    OrderItemData(
      amount: (json['amount'] as num).toDouble(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      products: (json['products'] as List<dynamic>)
          .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OrderItemDataToJson(OrderItemData instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'dateTime': instance.dateTime.toIso8601String(),
    };
