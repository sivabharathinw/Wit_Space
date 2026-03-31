import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter/material.dart' hide Builder;
import 'serializers.dart';

part 'event_model.g.dart';

abstract class EventModel implements Built<EventModel, EventModelBuilder> {
  String get id;
  String get title;
  String get description;
  String get location;
  DateTime get date;
  TimeOfDay get time;
  String get imageUrl;
  String get createdBy;
  DateTime get createdAt;

  EventModel._();
  factory EventModel([void Function(EventModelBuilder) updates]) = _$EventModel;

  static Serializer<EventModel> get serializer => _$eventModelSerializer;


//here fromjson is a method that takes a map and returns an EventModel object.

  static EventModel? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(EventModel.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(EventModel.serializer, this) as Map<String, dynamic>;
  }
}
