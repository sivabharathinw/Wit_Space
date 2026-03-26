import 'package:flutter/material.dart';
import '../tokens/colors.dart';
import '../tokens/radius.dart';
import '../widgets/extensions.dart';

enum AppAvatarSize { sm, md, lg }

class AppAvatar extends StatelessWidget {
  final String name;
  final AppAvatarSize size;
  final String? imageUrl;

  const AppAvatar({
    super.key,
    required this.name,
    this.size = AppAvatarSize.md,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    
    double dimension;
    double fontSize;
    
    switch (size) {
      case AppAvatarSize.sm: dimension = 24; fontSize = 10; break;
      case AppAvatarSize.md: dimension = 36; fontSize = 14; break;
      case AppAvatarSize.lg: dimension = 48; fontSize = 18; break;
    }

    final initials = name.trim().split(' ').map((e) => e[0].toUpperCase()).take(2).join();

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        shape: BoxShape.circle,
        image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover) : null,
      ),
      alignment: Alignment.center,
      child: imageUrl == null ? Text(
        initials,
        style: TextStyle(
          color: colors.textSecondary,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ) : null,
    );
  }
}
