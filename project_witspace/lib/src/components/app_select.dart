import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../tokens/spacing.dart';
import '../widgets/extensions.dart';

class SelectOption {
  final String value;
  final String label;
  const SelectOption(this.value, this.label);
}

class AppSelect extends StatelessWidget {
  final String label;
  final String? hint;
  final String? error;
  final bool enabled;
  final bool fullWidth;
  final List<SelectOption> options;
  final String? value;
  final ValueChanged<String?>? onChanged;

  const AppSelect({
    super.key,
    required this.label,
    this.hint,
    this.error,
    this.enabled = true,
    this.fullWidth = false,
    required this.options,
    this.value,
    this.onChanged,
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
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: enabled ? onChanged : null,
            decoration: InputDecoration(
              hintText: hint,
              errorText: error,
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
            items: options.map((opt) => DropdownMenuItem(
              value: opt.value,
              child: Text(opt.label),
            )).toList(),
          ),
        ),
      ],
    );
  }
}
