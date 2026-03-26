library registration_model;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registration_model.g.dart';

abstract class RegistrationModel implements Built<RegistrationModel, RegistrationModelBuilder> {
  String get id;
  String get eventId;
  String get userId;
  String get fullName;
  String get email;
  String get phone;
  DateTime get registeredAt;
  bool get checkedIn;
  bool get checkedOut;

  RegistrationModel._();
  factory RegistrationModel([void Function(RegistrationModelBuilder) updates]) = _$RegistrationModel;

  static Serializer<RegistrationModel> get serializer => _$registrationModelSerializer;
}
