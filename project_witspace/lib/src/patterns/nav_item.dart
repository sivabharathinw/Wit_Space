import 'package:flutter/material.dart';
import '../components/app_icon.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

class NavItem extends StatelessWidget {
  final AppIconName icon;
  final String label;
  final bool active;
  final bool collapsed;
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.active = false,
    this.collapsed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : AppSpacing.s3),
        decoration: BoxDecoration(
          color: active ? colors.primary.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            AppIcon(
              icon,
              size: 20,
              color: active ? colors.primary : colors.textSecondary,
            ),
            if (!collapsed) ...[
              const SizedBox(width: AppSpacing.s3),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: active ? colors.primary : colors.textSecondary,
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
