import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

class AppBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const AppBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  factory AppBadge.success(String label) => AppBadge(
    label: label,
    backgroundColor: const Color(0xFFDCFCE7),
    textColor: const Color(0xFF166534),
  );

  factory AppBadge.warning(String label) => AppBadge(
    label: label,
    backgroundColor: const Color(0xFFFEF9C3),
    textColor: const Color(0xFF854D0E),
  );

  factory AppBadge.error(String label) => AppBadge(
    label: label,
    backgroundColor: const Color(0xFFFEE2E2),
    textColor: const Color(0xFF991B1B),
  );

  factory AppBadge.info(String label) => AppBadge(
    label: label,
    backgroundColor: const Color(0xFFDBEAFE),
    textColor: const Color(0xFF1E40AF),
  );

  factory AppBadge.neutral(String label) => AppBadge(
    label: label,
    backgroundColor: const Color(0xFFF1F5F9),
    textColor: const Color(0xFF475569),
  );

  factory AppBadge.accent(String label) => AppBadge(
    label: label,
    backgroundColor: const Color(0xFFF3E8FF),
    textColor: const Color(0xFF6B21A8),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
