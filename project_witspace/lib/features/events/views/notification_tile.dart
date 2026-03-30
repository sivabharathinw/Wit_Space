import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/notification_model.dart';
import '../viewmodel/event_viewmodel.dart';
import '../../../src/components/app_text.dart';
import '../../../src/components/app_card.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/components/app_button.dart';
import '../../../src/tokens/spacing.dart';
import '../../../src/widgets/extensions.dart';

class NotificationTile extends ConsumerWidget {
  final NotificationModel notification;
  final VoidCallback onOpen;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onOpen,
  });

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
                ? colors.textMuted.withAlpha((0.1 * 255).toInt()) 
                : colors.primary.withAlpha((0.1 * 255).toInt()),
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
                      child: AppText.headingMd(
                        notification.title,
                        color: notification.hasSeen ? colors.textSecondary : colors.textPrimary,
                      ),
                    ),
                    AppText.labelSm(
                      _formatDate(notification.createdAt),
                      color: colors.textMuted,
                    ),
                    IconButton(
                      onPressed: () => _showEditDialog(context, ref),
                      icon: AppIcon(AppIconName.edit, color: colors.primary, size: 18),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      onPressed: () => ref.read(eventNotifierProvider.notifier).deleteNotification(notification.id),
                      icon: AppIcon(AppIconName.trash, color: colors.error, size: 18),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s1),
                AppText.bodySm(
                  notification.message,
                  color: colors.textSecondary,
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
                        onPressed: () => ref.read(eventNotifierProvider.notifier).markAsRead(notification.id),
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

  void _showEditDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController(text: notification.title);
    final messageController = TextEditingController(text: notification.message);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Notification'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: AppSpacing.s4),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Message'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updated = notification.rebuild((b) => b
                ..title = titleController.text
                ..message = messageController.text
              );
              ref.read(eventNotifierProvider.notifier).updateNotification(updated);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

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
}
