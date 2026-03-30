// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<EventState> _$eventStateSerializer = _$EventStateSerializer();

class _$EventStateSerializer implements StructuredSerializer<EventState> {
  @override
  final Iterable<Type> types = const [EventState, _$EventState];
  @override
  final String wireName = 'EventState';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    EventState object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'events',
      serializers.serialize(
        object.events,
        specifiedType: const FullType(BuiltList, const [
          const FullType(EventModel),
        ]),
      ),
      'notifications',
      serializers.serialize(
        object.notifications,
        specifiedType: const FullType(BuiltList, const [
          const FullType(NotificationModel),
        ]),
      ),
      'isLoading',
      serializers.serialize(
        object.isLoading,
        specifiedType: const FullType(bool),
      ),
    ];
    Object? value;
    value = object.error;
    if (value != null) {
      result
        ..add('error')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.registrationId;
    if (value != null) {
      result
        ..add('registrationId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  EventState deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EventStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'events':
          result.events.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(EventModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'notifications':
          result.notifications.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(NotificationModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'isLoading':
          result.isLoading =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'error':
          result.error =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'registrationId':
          result.registrationId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$EventState extends EventState {
  @override
  final BuiltList<EventModel> events;
  @override
  final BuiltList<NotificationModel> notifications;
  @override
  final bool isLoading;
  @override
  final String? error;
  @override
  final String? registrationId;

  factory _$EventState([void Function(EventStateBuilder)? updates]) =>
      (EventStateBuilder()..update(updates))._build();

  _$EventState._({
    required this.events,
    required this.notifications,
    required this.isLoading,
    this.error,
    this.registrationId,
  }) : super._();
  @override
  EventState rebuild(void Function(EventStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventStateBuilder toBuilder() => EventStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventState &&
        events == other.events &&
        notifications == other.notifications &&
        isLoading == other.isLoading &&
        error == other.error &&
        registrationId == other.registrationId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, events.hashCode);
    _$hash = $jc(_$hash, notifications.hashCode);
    _$hash = $jc(_$hash, isLoading.hashCode);
    _$hash = $jc(_$hash, error.hashCode);
    _$hash = $jc(_$hash, registrationId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EventState')
          ..add('events', events)
          ..add('notifications', notifications)
          ..add('isLoading', isLoading)
          ..add('error', error)
          ..add('registrationId', registrationId))
        .toString();
  }
}

class EventStateBuilder implements Builder<EventState, EventStateBuilder> {
  _$EventState? _$v;

  ListBuilder<EventModel>? _events;
  ListBuilder<EventModel> get events =>
      _$this._events ??= ListBuilder<EventModel>();
  set events(ListBuilder<EventModel>? events) => _$this._events = events;

  ListBuilder<NotificationModel>? _notifications;
  ListBuilder<NotificationModel> get notifications =>
      _$this._notifications ??= ListBuilder<NotificationModel>();
  set notifications(ListBuilder<NotificationModel>? notifications) =>
      _$this._notifications = notifications;

  bool? _isLoading;
  bool? get isLoading => _$this._isLoading;
  set isLoading(bool? isLoading) => _$this._isLoading = isLoading;

  String? _error;
  String? get error => _$this._error;
  set error(String? error) => _$this._error = error;

  String? _registrationId;
  String? get registrationId => _$this._registrationId;
  set registrationId(String? registrationId) =>
      _$this._registrationId = registrationId;

  EventStateBuilder();

  EventStateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _events = $v.events.toBuilder();
      _notifications = $v.notifications.toBuilder();
      _isLoading = $v.isLoading;
      _error = $v.error;
      _registrationId = $v.registrationId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventState other) {
    _$v = other as _$EventState;
  }

  @override
  void update(void Function(EventStateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventState build() => _build();

  _$EventState _build() {
    _$EventState _$result;
    try {
      _$result =
          _$v ??
          _$EventState._(
            events: events.build(),
            notifications: notifications.build(),
            isLoading: BuiltValueNullFieldError.checkNotNull(
              isLoading,
              r'EventState',
              'isLoading',
            ),
            error: error,
            registrationId: registrationId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'events';
        events.build();
        _$failedField = 'notifications';
        notifications.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EventState',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
