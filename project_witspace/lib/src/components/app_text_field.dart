import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? error;
  final bool enabled;
  final bool obscureText;
  final Widget? prefixIcon;
  final bool fullWidth;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.enabled = true,
    this.obscureText = false,
    this.prefixIcon,
    this.fullWidth = false,
    this.controller,
    this.validator,
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
            obscureText: obscureText,
            enabled: enabled,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              errorText: error,
              prefixIcon: prefixIcon,
              filled: !enabled,
              fillColor: enabled ? null : const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4, vertical: 12),
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
