// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<RegistrationModel> _$registrationModelSerializer =
    _$RegistrationModelSerializer();

class _$RegistrationModelSerializer
    implements StructuredSerializer<RegistrationModel> {
  @override
  final Iterable<Type> types = const [RegistrationModel, _$RegistrationModel];
  @override
  final String wireName = 'RegistrationModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    RegistrationModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'eventId',
      serializers.serialize(
        object.eventId,
        specifiedType: const FullType(String),
      ),
      'userId',
      serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      ),
      'fullName',
      serializers.serialize(
        object.fullName,
        specifiedType: const FullType(String),
      ),
      'email',
      serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      ),
      'phone',
      serializers.serialize(
        object.phone,
        specifiedType: const FullType(String),
      ),
      'company',
      serializers.serialize(
        object.company,
        specifiedType: const FullType(String),
      ),
      'designation',
      serializers.serialize(
        object.designation,
        specifiedType: const FullType(String),
      ),
      'registeredAt',
      serializers.serialize(
        object.registeredAt,
        specifiedType: const FullType(DateTime),
      ),
    ];

    return result;
  }

  @override
  RegistrationModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrationModelBuilder();

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
        case 'eventId':
          result.eventId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'userId':
          result.userId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'fullName':
          result.fullName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'email':
          result.email =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'phone':
          result.phone =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'company':
          result.company =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'designation':
          result.designation =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'registeredAt':
          result.registeredAt =
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

class _$RegistrationModel extends RegistrationModel {
  @override
  final String id;
  @override
  final String eventId;
  @override
  final String userId;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String company;
  @override
  final String designation;
  @override
  final DateTime registeredAt;

  factory _$RegistrationModel([
    void Function(RegistrationModelBuilder)? updates,
  ]) => (RegistrationModelBuilder()..update(updates))._build();

  _$RegistrationModel._({
    required this.id,
    required this.eventId,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.company,
    required this.designation,
    required this.registeredAt,
  }) : super._();
  @override
  RegistrationModel rebuild(void Function(RegistrationModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegistrationModelBuilder toBuilder() =>
      RegistrationModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrationModel &&
        id == other.id &&
        eventId == other.eventId &&
        userId == other.userId &&
        fullName == other.fullName &&
        email == other.email &&
        phone == other.phone &&
        company == other.company &&
        designation == other.designation &&
        registeredAt == other.registeredAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, eventId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, company.hashCode);
    _$hash = $jc(_$hash, designation.hashCode);
    _$hash = $jc(_$hash, registeredAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegistrationModel')
          ..add('id', id)
          ..add('eventId', eventId)
          ..add('userId', userId)
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('phone', phone)
          ..add('company', company)
          ..add('designation', designation)
          ..add('registeredAt', registeredAt))
        .toString();
  }
}

class RegistrationModelBuilder
    implements Builder<RegistrationModel, RegistrationModelBuilder> {
  _$RegistrationModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _eventId;
  String? get eventId => _$this._eventId;
  set eventId(String? eventId) => _$this._eventId = eventId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _company;
  String? get company => _$this._company;
  set company(String? company) => _$this._company = company;

  String? _designation;
  String? get designation => _$this._designation;
  set designation(String? designation) => _$this._designation = designation;

  DateTime? _registeredAt;
  DateTime? get registeredAt => _$this._registeredAt;
  set registeredAt(DateTime? registeredAt) =>
      _$this._registeredAt = registeredAt;

  RegistrationModelBuilder();

  RegistrationModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _eventId = $v.eventId;
      _userId = $v.userId;
      _fullName = $v.fullName;
      _email = $v.email;
      _phone = $v.phone;
      _company = $v.company;
      _designation = $v.designation;
      _registeredAt = $v.registeredAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrationModel other) {
    _$v = other as _$RegistrationModel;
  }

  @override
  void update(void Function(RegistrationModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegistrationModel build() => _build();

  _$RegistrationModel _build() {
    final _$result =
        _$v ??
        _$RegistrationModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'RegistrationModel',
            'id',
          ),
          eventId: BuiltValueNullFieldError.checkNotNull(
            eventId,
            r'RegistrationModel',
            'eventId',
          ),
          userId: BuiltValueNullFieldError.checkNotNull(
            userId,
            r'RegistrationModel',
            'userId',
          ),
          fullName: BuiltValueNullFieldError.checkNotNull(
            fullName,
            r'RegistrationModel',
            'fullName',
          ),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'RegistrationModel',
            'email',
          ),
          phone: BuiltValueNullFieldError.checkNotNull(
            phone,
            r'RegistrationModel',
            'phone',
          ),
          company: BuiltValueNullFieldError.checkNotNull(
            company,
            r'RegistrationModel',
            'company',
          ),
          designation: BuiltValueNullFieldError.checkNotNull(
            designation,
            r'RegistrationModel',
            'designation',
          ),
          registeredAt: BuiltValueNullFieldError.checkNotNull(
            registeredAt,
            r'RegistrationModel',
            'registeredAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
