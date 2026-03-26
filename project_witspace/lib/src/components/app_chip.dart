import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

class AppChip extends StatelessWidget {
  final String label;
  final bool active;
  final bool muted;
  final Widget? leading;
  final VoidCallback? onTap;

  const AppChip({
    super.key,
    required this.label,
    this.active = false,
    this.muted = false,
    this.leading,
    this.onTap,
  });

  factory AppChip.active({required String label, Widget? leading, VoidCallback? onTap}) =>
      AppChip(label: label, active: true, leading: leading, onTap: onTap);

  factory AppChip.muted({required String label, Widget? leading, VoidCallback? onTap}) =>
      AppChip(label: label, muted: true, leading: leading, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    Color bg = colors.bgCard;
    Color border = colors.border;
    Color text = colors.textPrimary;

    if (active) {
      bg = colors.primary;
      border = colors.primary;
      text = colors.onPrimary;
    } else if (muted) {
      bg = const Color(0xFFF1F5F9);
      border = const Color(0xFFF1F5F9);
      text = colors.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppSpacing.s1),
            ],
            Text(
              label,
              style: TextStyle(
                color: text,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
