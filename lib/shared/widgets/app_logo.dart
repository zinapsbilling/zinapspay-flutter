import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import 'glass_container.dart';

enum AppLogoSize { small, medium, large }

/// ZinapsPay logo widget
class AppLogo extends StatelessWidget {
  final AppLogoSize size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = AppLogoSize.medium,
    this.showText = true,
  });

  double get _iconSize {
    switch (size) {
      case AppLogoSize.small:
        return 32;
      case AppLogoSize.medium:
        return 48;
      case AppLogoSize.large:
        return 64;
    }
  }

  double get _containerSize {
    switch (size) {
      case AppLogoSize.small:
        return 40;
      case AppLogoSize.medium:
        return 56;
      case AppLogoSize.large:
        return 72;
    }
  }

  double get _fontSize {
    switch (size) {
      case AppLogoSize.small:
        return 20;
      case AppLogoSize.medium:
        return 24;
      case AppLogoSize.large:
        return 32;
    }
  }

  double get _subtitleSize {
    switch (size) {
      case AppLogoSize.small:
        return 10;
      case AppLogoSize.medium:
        return 12;
      case AppLogoSize.large:
        return 16;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo icon with pulse glow effect
        _PulseGlowContainer(
          size: _containerSize,
          child: GlassContainer(
            padding: EdgeInsets.all(_containerSize * 0.2),
            borderRadius: _containerSize * 0.3,
            enableShine: true,
            child: Icon(
              Icons.widgets_outlined,
              color: AppColors.foreground,
              size: _iconSize * 0.5,
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(width: size == AppLogoSize.small ? 8 : 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.pureWhite, AppColors.silver, AppColors.pureWhite],
                ).createShader(bounds),
                child: Text(
                  'ZinapsPay',
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Enterprise Solutions',
                style: TextStyle(
                  fontSize: _subtitleSize,
                  color: AppColors.foreground.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Pulse glow animation container
class _PulseGlowContainer extends StatefulWidget {
  final Widget child;
  final double size;

  const _PulseGlowContainer({
    required this.child,
    required this.size,
  });

  @override
  State<_PulseGlowContainer> createState() => _PulseGlowContainerState();
}

class _PulseGlowContainerState extends State<_PulseGlowContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.1, end: 0.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.size * 0.3),
            boxShadow: [
              BoxShadow(
                color: AppColors.foreground.withOpacity(_animation.value),
                blurRadius: 30 + (_animation.value * 30),
                spreadRadius: 0,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
