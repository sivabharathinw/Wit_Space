import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/notification_model.dart';
import '../../../src/components/app_text.dart';
import '../../../src/components/app_card.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/tokens/spacing.dart';
import 'event_ref_extensions.dart';
import '../../../src/widgets/extensions.dart';
class NotificationDetailsScreen extends ConsumerStatefulWidget {
  final NotificationModel notification;

  const NotificationDetailsScreen({
    super.key,
    required this.notification,
  });

  @override
  ConsumerState<NotificationDetailsScreen> createState() => _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends ConsumerState<NotificationDetailsScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically mark as read when the details are opened
    if (!widget.notification.hasSeen) {
      Future.microtask(() {
        ref.eventNotifier.markAsRead(widget.notification.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final notification = widget.notification;

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        title: AppText.headingMd('Notification Details', color: colors.textPrimary),
        backgroundColor: colors.bgPage,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.s3),
                        decoration: BoxDecoration(
                          color: colors.primary.withAlpha((0.1 * 255).toInt()),
                          shape: BoxShape.circle,
                        ),
                        child: AppIcon(AppIconName.bell, color: colors.primary, size: 24),
                      ),
                      const SizedBox(width: AppSpacing.s4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.headingMd(notification.title),
                            AppText.labelSm(
                              'Received on ${notification.createdAt.toLocal().toString().split('.')[0]}',
                              color: colors.textMuted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: AppSpacing.s10),
                  AppText.sectionLabel('MESSAGE', color: colors.textMuted),
                  const SizedBox(height: AppSpacing.s4),
                  AppText.bodyMd(notification.message),
                  const SizedBox(height: AppSpacing.s10),
                  _InfoRow(label: 'Sender ID', value: notification.senderId),
                  const Divider(height: AppSpacing.s6),
                  _InfoRow(label: 'Receiver ID', value: notification.receiverId),
                  const Divider(height: AppSpacing.s6),
                  _InfoRow(label: 'Status', value: notification.hasSeen ? 'Read' : 'Unread'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.labelSm(label, color: colors.textMuted),
        AppText.bodySm(value, color: colors.textSecondary),
      ],
    );
  }
}
