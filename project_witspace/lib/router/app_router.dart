import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/events/views/event_list_screen.dart';
import '../features/events/views/event_detail_screen.dart';
import '../features/events/views/create_event_screen.dart';
import '../features/events/views/edit_event_screen.dart';
import '../features/events/views/registration_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/events',
  routes: [
    GoRoute(
      path: '/events',
      name: 'eventList',
      builder: (context, state) => const EventListScreen(),
      routes: [
        GoRoute(
          path: 'create',
          name: 'createEvent',
          builder: (context, state) => const CreateEventScreen(),
        ),
        GoRoute(
          path: ':eventId',
          name: 'eventDetail',
          builder: (context, state) {
            final eventId = state.pathParameters['eventId']!;
            return EventDetailScreen(eventId: eventId);
          },
          routes: [
            GoRoute(
              path: 'edit',
              name: 'editEvent',
              builder: (context, state) {
                final eventId = state.pathParameters['eventId']!;
                return EditEventScreen(eventId: eventId);
              },
            ),
            GoRoute(
              path: 'register',
              name: 'registration',
              builder: (context, state) {
                final eventId = state.pathParameters['eventId']!;
                return RegistrationScreen(eventId: eventId);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
