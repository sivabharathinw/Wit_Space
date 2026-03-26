import 'package:flutter/material.dart';
import '../tokens/colors.dart';

extension AppThemeX on BuildContext {
  AppColors get colors {
    final extension = Theme.of(this).extension<AppThemeExtension>();
    return extension?.colors ?? AppColors.light;
  }
}
