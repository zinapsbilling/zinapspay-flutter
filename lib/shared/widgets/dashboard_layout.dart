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

class _DashboardLayoutState extends State<DashboardLayout> {
  bool _isSidebarCollapsed = true;
  bool _isMobileMenuOpen = false;

  static const double _collapsedWidth = 80;
  static const double _expandedWidth = 280;

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
                    onCollapsedChanged: (collapsed) {
                      setState(() => _isSidebarCollapsed = collapsed);
                    },
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
                  onCollapsedChanged: (collapsed) {
                    setState(() => _isSidebarCollapsed = collapsed);
                  },
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
      child: Stack(
        children: [
          Positioned(top: 80, left: 40, child: _orb(128, 0.05)),
          Positioned(top: 160, right: 80, child: _orb(96, 0.05)),
          Positioned(
            bottom: 128,
            left: MediaQuery.of(context).size.width * 0.25,
            child: _orb(160, 0.03),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [Colors.white.withOpacity(opacity), Colors.transparent],
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
