library serializers;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_model.dart';
import 'registration_model.dart';

part 'serializers.g.dart';

@SerializersFor([
  EventModel,
  RegistrationModel,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(const TimeOfDaySerializer())
      ..add(const FirestoreTimestampSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

class FirestoreTimestampSerializer implements PrimitiveSerializer<DateTime> {
  const FirestoreTimestampSerializer();

  @override
  DateTime deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) {
    if (serialized is Timestamp) {
      return serialized.toDate();
    }
    if (serialized is int) {
      return DateTime.fromMicrosecondsSinceEpoch(serialized);
    }
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
