// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationModel> _$notificationModelSerializer =
    _$NotificationModelSerializer();

class _$NotificationModelSerializer
    implements StructuredSerializer<NotificationModel> {
  @override
  final Iterable<Type> types = const [NotificationModel, _$NotificationModel];
  @override
  final String wireName = 'NotificationModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    NotificationModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'senderId',
      serializers.serialize(
        object.senderId,
        specifiedType: const FullType(String),
      ),
      'receiverId',
      serializers.serialize(
        object.receiverId,
        specifiedType: const FullType(String),
      ),
      'hasSeen',
      serializers.serialize(
        object.hasSeen,
        specifiedType: const FullType(bool),
      ),
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
      'message',
      serializers.serialize(
        object.message,
        specifiedType: const FullType(String),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      ),
    ];

    return result;
  }

  @override
  NotificationModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'senderId':
          result.senderId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'receiverId':
          result.receiverId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'hasSeen':
          result.hasSeen =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'message':
          result.message =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationModel extends NotificationModel {
  @override
  final String id;
  @override
  final String senderId;
  @override
  final String receiverId;
  @override
  final bool hasSeen;
  @override
  final String title;
  @override
  final String message;
  @override
  final DateTime createdAt;

  factory _$NotificationModel([
    void Function(NotificationModelBuilder)? updates,
  ]) => (NotificationModelBuilder()..update(updates))._build();

  _$NotificationModel._({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.hasSeen,
    required this.title,
    required this.message,
    required this.createdAt,
  }) : super._();
  @override
  NotificationModel rebuild(void Function(NotificationModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationModelBuilder toBuilder() =>
      NotificationModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationModel &&
        id == other.id &&
        senderId == other.senderId &&
        receiverId == other.receiverId &&
        hasSeen == other.hasSeen &&
        title == other.title &&
        message == other.message &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, senderId.hashCode);
    _$hash = $jc(_$hash, receiverId.hashCode);
    _$hash = $jc(_$hash, hasSeen.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationModel')
          ..add('id', id)
          ..add('senderId', senderId)
          ..add('receiverId', receiverId)
          ..add('hasSeen', hasSeen)
          ..add('title', title)
          ..add('message', message)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class NotificationModelBuilder
    implements Builder<NotificationModel, NotificationModelBuilder> {
  _$NotificationModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  String? _receiverId;
  String? get receiverId => _$this._receiverId;
  set receiverId(String? receiverId) => _$this._receiverId = receiverId;

  bool? _hasSeen;
  bool? get hasSeen => _$this._hasSeen;
  set hasSeen(bool? hasSeen) => _$this._hasSeen = hasSeen;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  NotificationModelBuilder();

  NotificationModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _senderId = $v.senderId;
      _receiverId = $v.receiverId;
      _hasSeen = $v.hasSeen;
      _title = $v.title;
      _message = $v.message;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationModel other) {
    _$v = other as _$NotificationModel;
  }

  @override
  void update(void Function(NotificationModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationModel build() => _build();

  _$NotificationModel _build() {
    final _$result =
        _$v ??
        _$NotificationModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'NotificationModel',
            'id',
          ),
          senderId: BuiltValueNullFieldError.checkNotNull(
            senderId,
            r'NotificationModel',
            'senderId',
          ),
          receiverId: BuiltValueNullFieldError.checkNotNull(
            receiverId,
            r'NotificationModel',
            'receiverId',
          ),
          hasSeen: BuiltValueNullFieldError.checkNotNull(
            hasSeen,
            r'NotificationModel',
            'hasSeen',
          ),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'NotificationModel',
            'title',
          ),
          message: BuiltValueNullFieldError.checkNotNull(
            message,
            r'NotificationModel',
            'message',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'NotificationModel',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
