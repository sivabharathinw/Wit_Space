

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';

part 'notification_model.g.dart';

abstract class NotificationModel implements Built<NotificationModel, NotificationModelBuilder> {
  String get id;
  String get senderId;
  String get receiverId;
  bool get hasSeen;
  String get title;
  String get message;
  DateTime get createdAt;

  NotificationModel._();
  factory NotificationModel([void Function(NotificationModelBuilder) updates]) = _$NotificationModel;

  static Serializer<NotificationModel> get serializer => _$notificationModelSerializer;

  static NotificationModel? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(NotificationModel.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(NotificationModel.serializer, this) as Map<String, dynamic>;
  }
}
