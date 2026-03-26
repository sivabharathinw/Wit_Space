import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/registration_model.dart';
import '../data/repository/event_repository.dart';

final registrationViewModelProvider = StateNotifierProvider<RegistrationViewModel, AsyncValue<String?>>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return RegistrationViewModel(repository);
});

class RegistrationViewModel extends StateNotifier<AsyncValue<String?>> {
  final EventRepository _repository;

  RegistrationViewModel(this._repository) : super(const AsyncValue.data(null));

  Future<void> register({
    required String eventId,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    final registration = RegistrationModel((b) => b
      ..id = ''
      ..eventId = eventId
      ..userId = 'tempUserId_${DateTime.now().millisecondsSinceEpoch}'
      ..fullName = fullName
      ..email = email
      ..phone = phone
      ..registeredAt = DateTime.now()
      ..checkedIn = false
      ..checkedOut = false
    );
    
    final registrationId = await _repository.registerForEvent(registration);
    state = AsyncValue.data(registrationId);
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
