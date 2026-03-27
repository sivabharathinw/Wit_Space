import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../src/components/app_text.dart';
import '../../../src/components/app_card.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/tokens/spacing.dart';
import '../../../src/widgets/extensions.dart';
import '../data/model/event_model.dart';
import 'event_ref_extensions.dart';

class EventListScreen extends ConsumerWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventState = ref.eventState;
    final events = eventState.events;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingLg('Events'),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.goNamed('createEvent'),
        backgroundColor: colors.primary,
        icon: AppIcon(AppIconName.plus, color: colors.onPrimary, size: 18),
        label: AppText.label('Create Event', color: colors.onPrimary),
      ),
      body: eventState.isLoading && eventState.events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(AppIconName.calendar, size: 48, color: colors.textMuted),
            const SizedBox(height: AppSpacing.s4),
            AppText.bodyMd('No events found', color: colors.textSecondary),
          ],
        ),
      )
          : EventListView(events: events.toList()),
    );
  }
}

class EventListView extends StatelessWidget {
  final List<EventModel> events;

  const EventListView({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.s4),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s4),
          child: AppCard(
            shadow: AppCardShadow.sm,
            onTap: () => context.goNamed('eventDetail', pathParameters: {'eventId': event.id}),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (event.imageUrl.isNotEmpty && event.imageUrl.startsWith('http'))
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      event.imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 220,
                        color: colors.border.withOpacity(0.5),
                        child: AppIcon(AppIconName.grid, size: 48, color: colors.textMuted),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.headingMd(event.title, color: colors.primary),
                      const SizedBox(height: AppSpacing.s2),
                      Row(
                        children: [
                          AppIcon(AppIconName.calendar, size: 14, color: colors.primary.withOpacity(0.7)),
                          const SizedBox(width: AppSpacing.s1),
                          AppText.bodySm(event.date.toIso8601String().split('T')[0], color: colors.primary.withOpacity(0.7)),
                          const SizedBox(width: AppSpacing.s4),
                          AppIcon(AppIconName.mapPin, size: 14, color: colors.primary.withOpacity(0.7)),
                          const SizedBox(width: AppSpacing.s1),
                          Expanded(child: AppText.bodySm(event.location, color: colors.primary.withOpacity(0.7), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}