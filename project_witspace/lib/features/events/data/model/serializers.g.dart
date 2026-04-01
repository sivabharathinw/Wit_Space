// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers =
    (Serializers().toBuilder()
          ..add(EventModel.serializer)
          ..add(EventState.serializer)
          ..add(NotificationModel.serializer)
          ..add(RegistrationModel.serializer)
          ..addBuilderFactory(
            const FullType(BuiltList, const [const FullType(EventModel)]),
            () => ListBuilder<EventModel>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, const [
              const FullType(NotificationModel),
            ]),
            () => ListBuilder<NotificationModel>(),
          ))
        .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
