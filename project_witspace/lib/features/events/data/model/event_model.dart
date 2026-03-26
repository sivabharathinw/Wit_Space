library event_model;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' hide Builder;

part 'event_model.g.dart';

abstract class EventModel implements Built<EventModel, EventModelBuilder> {
  String get id;
  String get title;
  String get description;
  String get location;
  DateTime get date;
  TimeOfDay get time;
  String get imageUrl;
  String get createdByUserId;
  DateTime get createdAt;

  EventModel._();
  factory EventModel([void Function(EventModelBuilder) updates]) = _$EventModel;

  static Serializer<EventModel> get serializer => _$eventModelSerializer;
}
