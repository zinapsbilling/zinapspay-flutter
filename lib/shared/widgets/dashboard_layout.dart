import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/constants/app_colors.dart';
import 'sidebar_nav.dart';

class DashboardLayout extends StatefulWidget {
  final Widget child;
  final String currentPath;

  const DashboardLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> with TickerProviderStateMixin {
  bool _isMobileMenuOpen = false;

  // Animation controllers for floating orbs
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    // Float animation: 8s ease-in-out infinite per specification
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -25).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        // Pure black background - exact #000000
        color: const Color(0xFF000000),
        child: Stack(
          children: [
            // Floating orbs background
            _buildFloatingOrbs(context),
            // Main content
            Row(
              children: [
                // Desktop Sidebar
                if (!isMobile)
                  SidebarNav(
                    currentPath: widget.currentPath,
                  ),
                // Main content area
                Expanded(
                  child: Column(
                    children: [
                      // Mobile header
                      if (isMobile) _buildMobileHeader(),
                      // Page content
                      Expanded(child: widget.child),
                    ],
                  ),
                ),
              ],
            ),
            // Mobile sidebar overlay
            if (isMobile && _isMobileMenuOpen) ...[
              // Backdrop
              GestureDetector(
                onTap: () => setState(() => _isMobileMenuOpen = false),
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              // Sidebar
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: SidebarNav(
                  currentPath: widget.currentPath,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingOrbs(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _floatAnimation,
        builder: (context, child) {
          return Stack(
            children: [
              // Orb 1: no delay
              Positioned(
                top: 80 + _floatAnimation.value,
                left: 40,
                child: _orb(128, 0.6),
              ),
              // Orb 2: animation-delay: -2s (offset the animation)
              Positioned(
                top: 160 + (_floatAnimation.value * 0.75),
                right: 80,
                child: _orb(96, 0.6),
              ),
              // Orb 3: animation-delay: -4s (offset the animation)
              Positioned(
                bottom: 128 + (_floatAnimation.value * 0.5),
                left: MediaQuery.of(context).size.width * 0.25,
                child: _orb(160, 0.6),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _orb(double size, double opacity) {
    // Spec: filter: blur(40px); opacity: 0.6
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.white.withOpacity(opacity * 0.15), // Subtle glow
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          // Menu button
          IconButton(
            onPressed: () => setState(() => _isMobileMenuOpen = !_isMobileMenuOpen),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          const SizedBox(width: 12),
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.receipt_long, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, AppColors.silver, Colors.white],
            ).createShader(bounds),
            child: const Text(
              'ZinapsPay',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          // Notifications
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined, color: Colors.white.withOpacity(0.8)),
          ),
          // User avatar
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                'JS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
