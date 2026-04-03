

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';

part 'registration_model.g.dart';

abstract class RegistrationModel implements Built<RegistrationModel, RegistrationModelBuilder> {
  String get id;
  String get eventId;
  String get userId;
  String get fullName;
  String get email;
  String get phone;
  String get company;
  String get designation;
  DateTime get registeredAt;

  RegistrationModel._();
  factory RegistrationModel([void Function(RegistrationModelBuilder) updates]) = _$RegistrationModel;

  static Serializer<RegistrationModel> get serializer => _$registrationModelSerializer;

  static RegistrationModel? fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(RegistrationModel.serializer, json);
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(RegistrationModel.serializer, this) as Map<String, dynamic>;
  }
}
