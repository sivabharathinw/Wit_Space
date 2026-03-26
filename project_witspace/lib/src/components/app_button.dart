import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

enum AppButtonSize { sm, md, lg }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final AppButtonSize size;
  final Widget? leading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderSide? border;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.leading,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
  });

  factory AppButton.primary({
    required String label,
     VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.md,
    Widget? leading,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    loading: loading,
    fullWidth: fullWidth,
    size: size,
    leading: leading,
  );

  factory AppButton.secondary({
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.md,
    Widget? leading,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    loading: loading,
    fullWidth: fullWidth,
    size: size,
    leading: leading,
    backgroundColor: Colors.transparent,
  );

  factory AppButton.ghost({
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.md,
    Widget? leading,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    loading: loading,
    fullWidth: fullWidth,
    size: size,
    leading: leading,
    backgroundColor: Colors.transparent,
  );

  factory AppButton.danger({
    required String label,
    VoidCallback? onPressed,
    bool loading = false,
    bool fullWidth = false,
    AppButtonSize size = AppButtonSize.md,
    Widget? leading,
  }) => AppButton(
    label: label,
    onPressed: onPressed,
    loading: loading,
    fullWidth: fullWidth,
    size: size,
    leading: leading,
    backgroundColor: const Color(0xFFEF4444),
    foregroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    // Default colors based on variant (detected by null bg/fg)
    Color bg = backgroundColor ?? colors.primary;
    Color fg = foregroundColor ?? colors.onPrimary;
    BorderSide? borderSide = border;

    // Handle secondary/ghost defaults
    if (backgroundColor == Colors.transparent) {
      fg = foregroundColor ?? colors.primary;
      if (border == null && foregroundColor == null) {
        // This is a secondary button if we don't have a foreground color set
        borderSide = BorderSide(color: colors.border);
      }
    }

    double height;
    double fontSize;
    double padding;

    switch (size) {
      case AppButtonSize.sm:
        height = 32;
        fontSize = 12;
        padding = AppSpacing.s3;
        break;
      case AppButtonSize.md:
        height = 44;
        fontSize = 14;
        padding = AppSpacing.s4;
        break;
      case AppButtonSize.lg:
        height = 56;
        fontSize = 16;
        padding = AppSpacing.s6;
        break;
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: borderSide ?? BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(horizontal: padding),
        ),
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: fg,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: AppSpacing.s2),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
