import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/event_viewmodel.dart';
import '../data/model/event_state.dart';

extension EventRefExtensions on WidgetRef {
  EventState get eventState => watch(eventNotifierProvider);
  EventNotifier get eventNotifier => read(eventNotifierProvider.notifier);
}

