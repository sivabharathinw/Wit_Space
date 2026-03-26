import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../widgets/extensions.dart';

enum AppCardShadow { none, xs, sm, md, lg, xl }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardShadow shadow;
  final bool border;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const AppCard({
    super.key,
    required this.child,
    this.shadow = AppCardShadow.none,
    this.border = true,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    List<BoxShadow>? boxShadow;
    switch (shadow) {
      case AppCardShadow.none:
        boxShadow = null;
        break;
      case AppCardShadow.xs:
        boxShadow = [const BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))];
        break;
      case AppCardShadow.sm:
        boxShadow = [const BoxShadow(color: Color(0x0F000000), blurRadius: 3, offset: Offset(0, 1)), const BoxShadow(color: Color(0x0A000000), blurRadius: 2, offset: Offset(0, 1))];
        break;
      case AppCardShadow.md:
        boxShadow = [const BoxShadow(color: Color(0x1A000000), blurRadius: 6, offset: Offset(0, 4)), const BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 2))];
        break;
      case AppCardShadow.lg:
        boxShadow = [const BoxShadow(color: Color(0x1A000000), blurRadius: 15, offset: Offset(0, 10)), const BoxShadow(color: Color(0x0D000000), blurRadius: 6, offset: Offset(0, 4))];
        break;
      case AppCardShadow.xl:
        boxShadow = [const BoxShadow(color: Color(0x26000000), blurRadius: 25, offset: Offset(0, 20)), const BoxShadow(color: Color(0x0D000000), blurRadius: 10, offset: Offset(0, 8))];
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: colors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: border ? Border.all(color: colors.border) : null,
        boxShadow: boxShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: child,
          ),
        ),
      ),
    );
  }
}
