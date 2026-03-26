import 'package:flutter/material.dart';
import '../tokens/radius.dart';

class AppSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = AppRadius.xs,
  });

  factory AppSkeleton.line({double width = double.infinity, double height = 16}) =>
      AppSkeleton(width: width, height: height);

  factory AppSkeleton.block({required double width, required double height, double borderRadius = AppRadius.md}) =>
      AppSkeleton(width: width, height: height, borderRadius: borderRadius);

  factory AppSkeleton.circle({double size = 40}) =>
      AppSkeleton(width: size, height: size, borderRadius: AppRadius.full);

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      ),
    );
  }
}
