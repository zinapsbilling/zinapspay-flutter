import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';

/// A glass-effect container matching the Next.js glass-effect class
class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final VoidCallback? onTap;
  final bool enableShine;
  final Color? backgroundColor;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = AppSizes.radiusL,
    this.onTap,
    this.enableShine = false,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget container = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: AppSizes.durationMedium,
          padding: padding ?? const EdgeInsets.symmetric(
            horizontal: AppSizes.spacing16,
            vertical: AppSizes.spacing12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.foreground.withOpacity(AppColors.opacityGlass),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.foreground.withOpacity(AppColors.opacityBorder),
            ),
          ),
          child: child,
        ),
      ),
    );

    if (enableShine) {
      container = _ShineEffect(
        borderRadius: borderRadius,
        child: container,
      );
    }

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: container,
      );
    }

    return container;
  }
}

/// Shine effect widget for hover animations
class _ShineEffect extends StatefulWidget {
  final Widget child;
  final double borderRadius;

  const _ShineEffect({
    required this.child,
    required this.borderRadius,
  });

  @override
  State<_ShineEffect> createState() => _ShineEffectState();
}

class _ShineEffectState extends State<_ShineEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _controller.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Stack(
            children: [
              widget.child,
              if (_isHovered)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: IgnorePointer(
                      child: Transform.translate(
                        offset: Offset(
                          MediaQuery.of(context).size.width * _animation.value,
                          0,
                        ),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.foreground.withOpacity(0.15),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
