import 'package:go_router/go_router.dart';

import '../features/events/views/event_list_screen.dart';
import '../features/events/views/event_detail_screen.dart';
import '../features/events/views/create_event_screen.dart';
import '../features/events/views/edit_event_screen.dart';
import '../features/events/views/registration_screen.dart';
import '../features/events/views/notification_screen.dart';
import '../features/events/views/notification_details_screen.dart';
import '../features/events/data/model/notification_model.dart';

final appRouter = GoRouter(
  initialLocation: '/events',
  routes: [
    GoRoute(
      path: '/notifications',
      name: 'notifications',
      builder: (context, state) => const NotificationScreen(),
      routes: [
        GoRoute(
          path: ':notificationId',
          name: 'notificationDetails',
          builder: (context, state) {
            //state .extra means data passing while routing,as notification model means conveert into notification model
            final notification = state.extra as NotificationModel;
            //goes to the notification details screen
            return NotificationDetailsScreen(notification: notification);
          },
        ),
      ],
    ),
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
