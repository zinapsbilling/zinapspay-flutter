import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../core/constants/app_colors.dart';

/// Floating orbs background effect matching the Next.js floating-element class
class FloatingOrbs extends StatefulWidget {
  final int orbCount;

  const FloatingOrbs({
    super.key,
    this.orbCount = 3,
  });

  @override
  State<FloatingOrbs> createState() => _FloatingOrbsState();
}

class _FloatingOrbsState extends State<FloatingOrbs>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;
  late List<_OrbData> _orbs;

  @override
  void initState() {
    super.initState();
    _initializeOrbs();
  }

  void _initializeOrbs() {
    final random = math.Random();

    _orbs = List.generate(widget.orbCount, (index) {
      return _OrbData(
        left: random.nextDouble() * 0.8,
        top: random.nextDouble() * 0.8,
        size: 80 + random.nextDouble() * 80,
        delay: index * 2000,
      );
    });

    _controllers = List.generate(widget.orbCount, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 8000 + _orbs[index].delay),
        vsync: this,
      )..repeat(reverse: true);
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: 25).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return IgnorePointer(
      child: Stack(
        children: List.generate(widget.orbCount, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Positioned(
                left: size.width * _orbs[index].left,
                top: size.height * _orbs[index].top - _animations[index].value,
                child: Transform.rotate(
                  angle: _animations[index].value * 0.01,
                  child: Container(
                    width: _orbs[index].size,
                    height: _orbs[index].size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.foreground.withOpacity(0.05),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class _OrbData {
  final double left;
  final double top;
  final double size;
  final int delay;

  _OrbData({
    required this.left,
    required this.top,
    required this.size,
    required this.delay,
  });
}
