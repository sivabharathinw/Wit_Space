import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_witspace/features/events/views/event_ref_extensions.dart';
import '../data/model/notification_model.dart';
import '../viewmodel/event_viewmodel.dart';
import '../../../src/components/app_card.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/components/app_button.dart';
import '../../../src/tokens/spacing.dart';
import '../../../src/components/app_text.dart';
import '../../../src/widgets/extensions.dart';

class NotificationTile extends ConsumerWidget {
  final NotificationModel notification;
  final VoidCallback onOpen;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onOpen,
  });
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return AppCard(
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.s4),
      shadow: notification.hasSeen ? AppCardShadow.none : AppCardShadow.sm,
      border: !notification.hasSeen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s2),
            decoration: BoxDecoration(
              color: notification.hasSeen
                  ? colors.textMuted.withOpacity(0.1)
                  : colors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: AppIcon(
              AppIconName.bell,
              color: notification.hasSeen ? colors.textMuted : colors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.s4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          color: notification.hasSeen ? colors.textSecondary : colors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    AppText.labelSm(
                      _formatDate(notification.createdAt),
                      color: colors.textMuted,
                    ),
                    IconButton(
                      onPressed: () => ref.eventNotifier.deleteNotification(notification.id),
                      icon: AppIcon(AppIconName.trash, color: colors.error, size: 18),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s1),
                Text(
                  notification.message,
                  style: TextStyle(color: colors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s3),
                Row(
                  children: [
                    AppButton.ghost(
                      label: 'Open',
                      onPressed: onOpen,
                      size: AppButtonSize.sm,
                      leading: AppIcon(AppIconName.arrowRight, size: 14, color: colors.primary),
                    ),
                    if (!notification.hasSeen) ...[
                      const SizedBox(width: AppSpacing.s2),
                      AppButton.ghost(
                        label: 'Mark as read',
                        onPressed: () => ref.eventNotifier.markAsRead(notification.id),
                        size: AppButtonSize.sm,
                        leading: AppIcon(AppIconName.check, size: 14, color: colors.success),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



}
