

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'event_model.dart';
import 'notification_model.dart';

part 'event_state.g.dart';

abstract class EventState implements Built<EventState, EventStateBuilder> {
  BuiltList<EventModel> get events;
  
  BuiltList<NotificationModel> get notifications;

  bool get isLoading;

  String? get error;

  String? get registrationId;
  
  bool get isRegistered;

  int get unreadNotificationsCount => notifications.where((n) => !n.hasSeen).length;

  EventState._();

  factory EventState([void Function(EventStateBuilder) updates]) = _$EventState;

  static Serializer<EventState> get serializer => _$eventStateSerializer;

  factory EventState.initial() =>
      EventState((b) =>
      b
        ..events = ListBuilder<EventModel>()
        ..notifications = ListBuilder<NotificationModel>()
        ..isLoading = false
        ..error = null
        ..registrationId = null
        ..isRegistered = false
      );
}
