import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../src/components/app_text.dart';
import '../../../src/components/app_button.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/components/app_badge.dart';
import '../../../src/tokens/spacing.dart';
import '../viewmodel/event_viewmodel.dart';
import '../data/model/event_model.dart';
import '../../../src/widgets/extensions.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventNotifierProvider.notifier).checkRegistrationStatus(widget.eventId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventNotifierProvider);
    final event = eventState.events.where((e) => e.id == widget.eventId).firstOrNull;
    final colors = context.colors;
    
    final bool isNotFound = event == null;
    
    // Ownership check (Mocked for now)
    const bool isOwner = true;

    return Scaffold(
      appBar: AppBar(
        title: AppText.headingMd('Event Details', color: colors.textPrimary),
        backgroundColor: colors.bgPage,
        elevation: 0,
        actions: [
          if (isOwner && !isNotFound) ...[
            IconButton(
              icon: AppIcon(AppIconName.edit, color: colors.textSecondary),
              onPressed: () => context.goNamed('editEvent', pathParameters: {'eventId': widget.eventId}),
            ),
            IconButton(
              icon: AppIcon(AppIconName.trash, color: colors.error),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: AppText.headingMd('Delete Event'),
                    content: AppText.bodySm('Are you sure you want to delete this event? This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: AppText.label('Cancel', color: colors.textSecondary)),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: AppText.label('Delete', color: colors.error),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await ref.read(eventNotifierProvider.notifier).deleteEvent(widget.eventId);
                  if (context.mounted) {
                    context.goNamed('eventList');
                  }
                }
              },
            ),
          ]
        ],
      ),
      body: eventState.isLoading && eventState.events.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : isNotFound
              ? Center(child: AppText.bodyMd('Event not found', color: colors.error))
              : EventDetailBody(event: event, isRegistered: eventState.isRegistered),
    );
  }
}

class EventDetailBody extends StatelessWidget {
  final EventModel event;
  final bool isRegistered;

  const EventDetailBody({
    super.key,
    required this.event,
    required this.isRegistered,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (event.imageUrl.isNotEmpty && event.imageUrl.startsWith('http'))
            Image.network(
              event.imageUrl,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                color: colors.border.withAlpha((0.5 * 255).toInt()),
                child: AppIcon(AppIconName.grid, size: 100, color: colors.textMuted),
              ),
            )
          else
            Container(
              height: 300,
              color: colors.primary.withAlpha((0.05 * 255).toInt()),
              child: AppIcon(AppIconName.calendar, size: 100, color: colors.primary.withAlpha((0.2 * 255).toInt())),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: AppText.displayMd(event.title)),
                    isRegistered 
                      ? AppBadge.success('Registered')
                      : AppBadge.info('Open'),
                  ],
                ),
                const SizedBox(height: AppSpacing.s6),
                EventInfoCard(children: [
                  EventInfoRow(
                    icon: AppIconName.calendar,
                    label: 'Date',
                    value: event.date.toIso8601String().split('T')[0],
                  ),
                  const Divider(height: AppSpacing.s6),
                  EventInfoRow(
                    icon: AppIconName.clock,
                    label: 'Time',
                    value: event.time.format(context),
                  ),
                  const Divider(height: AppSpacing.s6),
                  EventInfoRow(
                    icon: AppIconName.mapPin,
                    label: 'Location',
                    value: event.location,
                  ),
                ]),
                const SizedBox(height: AppSpacing.s8),
                AppText.sectionLabel('DESCRIPTION', color: colors.primary.withAlpha((0.5 * 255).toInt())),
                const SizedBox(height: AppSpacing.s3),
                AppText.bodyMd(event.description, color: colors.primary.withAlpha((0.8 * 255).toInt())),
                const SizedBox(height: AppSpacing.s10),
                isRegistered
                  ? AppButton.secondary(
                      label: 'Already Registered',
                      onPressed: () {}, // Disable by passing empty or null if AppButton supports it
                      fullWidth: true,
                      size: AppButtonSize.lg,
                      leading: AppIcon(AppIconName.check, color: colors.success),
                    )
                  : AppButton.primary(
                      label: 'Register for Event',
                      onPressed: () => context.goNamed('registration',
                          pathParameters: {'eventId': event.id}),
                      fullWidth: true,
                      size: AppButtonSize.lg,
                      leading: const AppIcon(AppIconName.check, color: Colors.white),
                    ),
                const SizedBox(height: AppSpacing.s8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventInfoCard extends StatelessWidget {
  final List<Widget> children;

  const EventInfoCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: context.colors.bgPage,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.colors.border),
      ),
      child: Column(children: children),
    );
  }
}

class EventInfoRow extends StatelessWidget {
  final AppIconName icon;
  final String label;
  final String value;

  const EventInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.s2),
          decoration: BoxDecoration(
            color: colors.primary.withAlpha((0.1 * 255).toInt()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AppIcon(icon, size: 18, color: colors.primary),
        ),
        const SizedBox(width: AppSpacing.s3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.labelSm(label, color: colors.textMuted),
            AppText.bodyMd(value, color: colors.textPrimary),
          ],
        ),
      ],
    );
  }
}
