// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<EventModel> _$eventModelSerializer = _$EventModelSerializer();

class _$EventModelSerializer implements StructuredSerializer<EventModel> {
  @override
  final Iterable<Type> types = const [EventModel, _$EventModel];
  @override
  final String wireName = 'EventModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    EventModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
      'description',
      serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      ),
      'location',
      serializers.serialize(
        object.location,
        specifiedType: const FullType(String),
      ),
      'date',
      serializers.serialize(
        object.date,
        specifiedType: const FullType(DateTime),
      ),
      'time',
      serializers.serialize(
        object.time,
        specifiedType: const FullType(TimeOfDay),
      ),
      'imageUrl',
      serializers.serialize(
        object.imageUrl,
        specifiedType: const FullType(String),
      ),
      'createdBy',
      serializers.serialize(
        object.createdBy,
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
  EventModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EventModelBuilder();

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
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'location':
          result.location =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'date':
          result.date =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'time':
          result.time =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(TimeOfDay),
                  )!
                  as TimeOfDay;
          break;
        case 'imageUrl':
          result.imageUrl =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'createdBy':
          result.createdBy =
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

class _$EventModel extends EventModel {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String location;
  @override
  final DateTime date;
  @override
  final TimeOfDay time;
  @override
  final String imageUrl;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  factory _$EventModel([void Function(EventModelBuilder)? updates]) =>
      (EventModelBuilder()..update(updates))._build();

  _$EventModel._({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.date,
    required this.time,
    required this.imageUrl,
    required this.createdBy,
    required this.createdAt,
  }) : super._();
  @override
  EventModel rebuild(void Function(EventModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EventModelBuilder toBuilder() => EventModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EventModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        location == other.location &&
        date == other.date &&
        time == other.time &&
        imageUrl == other.imageUrl &&
        createdBy == other.createdBy &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, time.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EventModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('location', location)
          ..add('date', date)
          ..add('time', time)
          ..add('imageUrl', imageUrl)
          ..add('createdBy', createdBy)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class EventModelBuilder implements Builder<EventModel, EventModelBuilder> {
  _$EventModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _location;
  String? get location => _$this._location;
  set location(String? location) => _$this._location = location;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  TimeOfDay? _time;
  TimeOfDay? get time => _$this._time;
  set time(TimeOfDay? time) => _$this._time = time;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  EventModelBuilder();

  EventModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _location = $v.location;
      _date = $v.date;
      _time = $v.time;
      _imageUrl = $v.imageUrl;
      _createdBy = $v.createdBy;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EventModel other) {
    _$v = other as _$EventModel;
  }

  @override
  void update(void Function(EventModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EventModel build() => _build();

  _$EventModel _build() {
    final _$result =
        _$v ??
        _$EventModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'EventModel', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'EventModel',
            'title',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'EventModel',
            'description',
          ),
          location: BuiltValueNullFieldError.checkNotNull(
            location,
            r'EventModel',
            'location',
          ),
          date: BuiltValueNullFieldError.checkNotNull(
            date,
            r'EventModel',
            'date',
          ),
          time: BuiltValueNullFieldError.checkNotNull(
            time,
            r'EventModel',
            'time',
          ),
          imageUrl: BuiltValueNullFieldError.checkNotNull(
            imageUrl,
            r'EventModel',
            'imageUrl',
          ),
          createdBy: BuiltValueNullFieldError.checkNotNull(
            createdBy,
            r'EventModel',
            'createdBy',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'EventModel',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
