library serializers;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_model.dart';
import 'registration_model.dart';
import 'event_state.dart';

part 'serializers.g.dart';

@SerializersFor([
  EventModel,
  RegistrationModel,
  EventState,
])
final Serializers serializers = (_$serializers.toBuilder()
//custom serializer for timestap from firebase
      ..add(const TimeOfDaySerializer())
      ..add(const FirestoreTimestampSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

class FirestoreTimestampSerializer implements PrimitiveSerializer<DateTime> {
  const FirestoreTimestampSerializer();

  @override
  //DateTime have date and time together
  DateTime deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) {
    //if the incoming date is timestamp then convert it to date time
    if (serialized is Timestamp) {
      return serialized.toDate();
    }
    //if the incoming data is int then convert it to date time
    if (serialized is int) {
      return DateTime.fromMicrosecondsSinceEpoch(serialized);
    }
    //otherwise return the incoming date time
    return DateTime.parse(serialized as String);
  }

  @override
  Object serialize(Serializers serializers, DateTime object, {FullType specifiedType = FullType.unspecified}) {
    return Timestamp.fromDate(object);
  }

  @override
  String get wireName => 'DateTime';

  @override
  Iterable<Type> get types => [DateTime];
}
//primitiveSerilizer a a serilizer of single date time type
class TimeOfDaySerializer implements PrimitiveSerializer<TimeOfDay> {
  const TimeOfDaySerializer();

  @override
  TimeOfDay deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) {
    final str = serialized as String;
    final parts = str.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  @override
  Object serialize(Serializers serializers, TimeOfDay object, {FullType specifiedType = FullType.unspecified}) {
    return '${object.hour}:${object.minute}';
  }

  @override
  String get wireName => 'TimeOfDay';

  @override
  Iterable<Type> get types => [TimeOfDay];
}
