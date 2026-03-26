import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

class AppTextarea extends StatelessWidget {
  final String label;
  final String? hint;
  final String? error;
  final bool enabled;
  final int minLines;
  final int? maxLines;
  final bool fullWidth;
  final TextEditingController? controller;

  const AppTextarea({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.enabled = true,
    this.minLines = 3,
    this.maxLines,
    this.fullWidth = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.s1),
        SizedBox(
          width: fullWidth ? double.infinity : null,
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            minLines: minLines,
            maxLines: maxLines ?? minLines + 2,
            decoration: InputDecoration(
              hintText: hint,
              errorText: error,
              filled: !enabled,
              fillColor: enabled ? null : const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.all(AppSpacing.s4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: colors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: colors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: colors.primary, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
