import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_colors.dart';

/// ZinapsPay Theme Widgets - Matching Next.js theme-utilities.css
/// These widgets provide the same effects as the Next.js theme system:
/// - Shine effect (gradient sweep on hover)
/// - Pop-up effect (lift and scale on hover)
/// - Glass morphism
/// - Theme-appropriate shadows

/// Interactive card with shine and pop-up effects
/// Equivalent to: `className="theme-card theme-interactive"`
class ThemeCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;
  final bool enableHoverEffects;
  final VoidCallback? onTap;

  const ThemeCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.enableHoverEffects = true,
    this.onTap,
  });

  @override
  State<ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<ThemeCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    if (!widget.enableHoverEffects) return;
    setState(() => _isHovered = hovering);
    if (hovering) {
      _shineController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? 16.0;
    final padding = widget.padding ?? const EdgeInsets.all(24);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -5.0 : 0.0)
            ..scale(_isHovered ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  // Next.js gradient-card: linear-gradient(135deg, #000000 0%, #1a1a1a 100%)
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(_isHovered ? 0.15 : 0.1),
                    width: 1,
                  ),
                  // Next.js shadow-md: 0 10px 30px rgba(0, 0, 0, 0.6)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(_isHovered ? 0.8 : 0.6),
                      blurRadius: _isHovered ? 40 : 30,
                      offset: Offset(0, _isHovered ? 20 : 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Main content
                    Padding(
                      padding: padding,
                      child: widget.child,
                    ),
                    // Shine effect overlay
                    if (widget.enableHoverEffects)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _shineAnimation,
                          builder: (context, child) {
                            return IgnorePointer(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  gradient: LinearGradient(
                                    begin: Alignment(_shineAnimation.value - 1, 0),
                                    end: Alignment(_shineAnimation.value, 0),
                                    colors: [
                                      Colors.transparent,
                                      Colors.white.withOpacity(0.15),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.5, 1.0],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass morphism container
/// Equivalent to: `className="theme-glass"`
class ThemeGlass extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double? borderRadius;

  const ThemeGlass({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? 12.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            // opacity-glass: 0.03
            color: AppColors.silver.withOpacity(0.03),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Interactive button with shine effect
/// Equivalent to: `className="theme-button"`
class ThemeButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final EdgeInsets? padding;

  const ThemeButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isPrimary = true,
    this.padding,
  });

  @override
  State<ThemeButton> createState() => _ThemeButtonState();
}

class _ThemeButtonState extends State<ThemeButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _shineController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -2.0 : 0.0)
            ..scale(_isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: widget.padding ??
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.isPrimary
                      ? Colors.white.withOpacity(0.05)
                      : Colors.transparent,
                  border: Border.all(
                    color: Colors.white.withOpacity(_isHovered ? 0.2 : 0.1),
                    width: 1,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 40,
                            offset: const Offset(0, 20),
                          ),
                        ]
                      : null,
                ),
                child: Stack(
                  children: [
                    // Main content
                    widget.child,
                    // Shine effect overlay
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _shineAnimation,
                        builder: (context, child) {
                          return IgnorePointer(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  begin: Alignment(_shineAnimation.value - 1, 0),
                                  end: Alignment(_shineAnimation.value, 0),
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.15),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigation item with hover effects
/// Equivalent to: `className="theme-nav-item"`
class ThemeNavItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isActive;
  final EdgeInsets? padding;

  const ThemeNavItem({
    super.key,
    required this.child,
    this.onTap,
    this.isActive = false,
    this.padding,
  });

  @override
  State<ThemeNavItem> createState() => _ThemeNavItemState();
}

class _ThemeNavItemState extends State<ThemeNavItem>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _shineController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    final isHighlighted = isActive || _isHovered;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isHighlighted ? Colors.white.withOpacity(0.1) : Colors.transparent,
            border: isActive
                ? const Border(
                    left: BorderSide(
                      color: Color(0x99F5F5F7), // 60% opacity accent
                      width: 4,
                    ),
                  )
                : null,
          ),
          child: Stack(
            children: [
              widget.child,
              // Shine effect overlay
              if (_isHovered)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return IgnorePointer(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment(_shineAnimation.value - 1, 0),
                              end: Alignment(_shineAnimation.value, 0),
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Badge with theme styling
/// Equivalent to: `className="theme-badge"` variants
class ThemeBadge extends StatelessWidget {
  final String text;
  final ThemeBadgeVariant variant;

  const ThemeBadge({
    super.key,
    required this.text,
    this.variant = ThemeBadgeVariant.neutral,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getBadgeColors();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
        color: colors.background,
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.text,
        ),
      ),
    );
  }

  _BadgeColors _getBadgeColors() {
    switch (variant) {
      case ThemeBadgeVariant.success:
        return _BadgeColors(
          background: const Color(0xFF22C55E).withOpacity(0.1),
          border: const Color(0xFF22C55E).withOpacity(0.3),
          text: const Color(0xFF22C55E),
        );
      case ThemeBadgeVariant.warning:
        return _BadgeColors(
          background: const Color(0xFFFBBF24).withOpacity(0.1),
          border: const Color(0xFFFBBF24).withOpacity(0.3),
          text: const Color(0xFFFBBF24),
        );
      case ThemeBadgeVariant.error:
        return _BadgeColors(
          background: const Color(0xFFEF4444).withOpacity(0.1),
          border: const Color(0xFFEF4444).withOpacity(0.3),
          text: const Color(0xFFEF4444),
        );
      case ThemeBadgeVariant.info:
        return _BadgeColors(
          background: const Color(0xFF3B82F6).withOpacity(0.1),
          border: const Color(0xFF3B82F6).withOpacity(0.3),
          text: const Color(0xFF3B82F6),
        );
      case ThemeBadgeVariant.neutral:
        return _BadgeColors(
          background: Colors.white.withOpacity(0.03),
          border: Colors.white.withOpacity(0.1),
          text: Colors.white,
        );
    }
  }
}

enum ThemeBadgeVariant { neutral, success, warning, error, info }

class _BadgeColors {
  final Color background;
  final Color border;
  final Color text;

  _BadgeColors({
    required this.background,
    required this.border,
    required this.text,
  });
}

/// Gradient heading text
/// Equivalent to: `className="theme-heading-gradient"`
class ThemeHeadingGradient extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  const ThemeHeadingGradient({
    super.key,
    required this.text,
    this.fontSize = 24,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, AppColors.silver, Colors.white],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Main surface background
/// Equivalent to: `className="theme-surface"`
class ThemeSurface extends StatelessWidget {
  final Widget child;

  const ThemeSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // Next.js gradient-main: linear-gradient(135deg, #000000 0%, #0a0a0a 50%, #000000 100%)
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF000000),
            Color(0xFF0A0A0A),
            Color(0xFF000000),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: child,
    );
  }
}
