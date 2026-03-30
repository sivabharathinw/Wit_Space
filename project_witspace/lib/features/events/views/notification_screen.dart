import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../viewmodel/event_viewmodel.dart';
import 'notification_tile.dart';
import '../../../src/components/app_text.dart';
import '../../../src/components/app_button.dart';
import '../../../src/components/app_icon.dart';
import '../../../src/tokens/spacing.dart';
import '../../../src/widgets/extensions.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate getting user ID (mock for now)
    Future.microtask(() {
      ref.read(eventNotifierProvider.notifier).setUserId('temp_user_id');
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(eventNotifierProvider);
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bgPage,
      appBar: AppBar(
        title: AppText.headingMd('Notifications', color: colors.textPrimary),
        backgroundColor: colors.bgPage,
        elevation: 0,
        actions: [
          if (state.notifications.any((n) => !n.hasSeen))
            TextButton.icon(
              onPressed: () => ref.read(eventNotifierProvider.notifier).markAllAsRead(),
              icon: AppIcon(AppIconName.check, color: colors.primary, size: 18),
              label: AppText.label('Mark all as read', color: colors.primary),
            ),
          if (state.notifications.isNotEmpty)
            IconButton(
              onPressed: () => _confirmDeleteAll(context, ref),
              icon: AppIcon(AppIconName.trash, color: colors.error, size: 18),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: state.isLoading && state.notifications.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.notifications.isEmpty
              ? _EmptyNotifications()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.s6),
                  itemCount: state.notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.s4),
                  itemBuilder: (context, index) {
                    final notification = state.notifications[index];
                    return NotificationTile(
                      notification: notification,
                      onOpen: () {
                        if (!notification.hasSeen) {
                          ref.read(eventNotifierProvider.notifier).markAsRead(notification.id);
                        }
                        context.pushNamed(
                          'notificationDetails',
                          pathParameters: {'notificationId': notification.id},
                          extra: notification,
                        );
                      },
                    );
                  },
                ),
    );
  }

  void _confirmDeleteAll(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(eventNotifierProvider.notifier).deleteAllNotifications();
              Navigator.pop(context);
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.s8),
            decoration: BoxDecoration(
              color: colors.primary.withAlpha((0.05 * 255).toInt()),
              shape: BoxShape.circle,
            ),
            child: AppIcon(AppIconName.bell, size: 64, color: colors.primary.withAlpha((0.2 * 255).toInt())),
          ),
          const SizedBox(height: AppSpacing.s6),
          AppText.headingMd('No Notifications Yet', color: colors.textSecondary),
          const SizedBox(height: AppSpacing.s2),
          AppText.bodyMd('We\'ll notify you when something important happens.', color: colors.textMuted),
        ],
      ),
    );
  }
}
