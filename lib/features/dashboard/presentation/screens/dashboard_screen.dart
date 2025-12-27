import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:ui';

import '../../../../core/constants/app_colors.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 640;

    // Dashboard content only - layout wrapper handles sidebar and background
    return SingleChildScrollView(
      // Next.js: p-4 sm:p-6 lg:p-8 (16px, 24px, 32px)
      padding: EdgeInsets.all(isDesktop ? 32 : (isTablet ? 24 : 16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(isDesktop, isTablet),
          // Next.js: mb-6 lg:mb-8 (24px, 32px)
          SizedBox(height: isDesktop ? 32 : 24),
          _buildStatsGrid(isDesktop, isTablet),
          // Next.js: mb-8 lg:mb-12 (32px, 48px)
          SizedBox(height: isDesktop ? 48 : 32),
          _buildBottomSection(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(bool isDesktop, bool isTablet) {
    // Next.js: text-2xl sm:text-3xl lg:text-4xl = 24px, 30px, 36px
    final titleSize = isDesktop ? 36.0 : (isTablet ? 30.0 : 24.0);
    // Next.js: text-base sm:text-lg lg:text-xl = 16px, 18px, 20px
    final subtitleSize = isDesktop ? 20.0 : (isTablet ? 18.0 : 16.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Next.js: "Welcome to ZinapsPay" with font-extralight (w200)
        Text.rich(
          TextSpan(
            text: 'Welcome to ',
            // font-extralight = FontWeight.w200
            style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.w200, color: Colors.white),
            children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ShaderMask(
                  shaderCallback: (b) => const LinearGradient(colors: [Colors.white, AppColors.silver, Colors.white]).createShader(b),
                  // "ZinapsPay" is bold within the light title
                  child: Text('ZinapsPay', style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
        // Next.js: mb-2 lg:mb-4 (8px, 16px)
        SizedBox(height: isDesktop ? 16 : 8),
        Text(
          'Your comprehensive warehouse fulfillment and invoice management solution',
          style: TextStyle(fontSize: subtitleSize, color: Colors.white.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop, bool isTablet) {
    // Next.js data: $2.4M Monthly Revenue, 15,847 Orders, 127k Storage, 342 Clients
    final stats = [
      {'title': 'Monthly Revenue', 'value': '\$2.4M', 'change': '+12%', 'icon': Icons.receipt_long, 'color': Colors.green},
      {'title': 'Orders Processed', 'value': '15,847', 'change': '+8%', 'icon': Icons.inventory_2, 'color': Colors.blue},
      {'title': 'Storage', 'value': '127k', 'change': '85%', 'icon': Icons.warehouse, 'color': Colors.amber},
      {'title': 'Clients', 'value': '342', 'change': '+15', 'icon': Icons.people, 'color': Colors.purple},
    ];

    // Next.js: gap-3 sm:gap-4 lg:gap-6 (12px, 16px, 24px)
    final gap = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);

    // Match Next.js: grid grid-cols-2 lg:grid-cols-4
    // Cards grow to fit content naturally - no fixed aspect ratio
    if (isDesktop) {
      // Desktop: 4 columns in a row
      return Row(
        children: stats.asMap().entries.map((entry) {
          final index = entry.key;
          final stat = entry.value;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index < stats.length - 1 ? gap : 0),
              // First card has pulse-glow effect like Next.js
              child: _InteractiveStatCard(stat: stat, isDesktop: isDesktop, isTablet: isTablet, hasPulseGlow: index == 0),
            ),
          );
        }).toList(),
      );
    } else {
      // Mobile/Tablet: 2 columns using LayoutBuilder to get available width
      return LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth - gap) / 2;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: stats.asMap().entries.map((entry) {
              final index = entry.key;
              final stat = entry.value;
              return SizedBox(
                width: cardWidth,
                // First card has pulse-glow effect like Next.js
                child: _InteractiveStatCard(stat: stat, isDesktop: isDesktop, isTablet: isTablet, hasPulseGlow: index == 0),
              );
            }).toList(),
          );
        },
      );
    }
  }

  Widget _buildBottomSection(bool isDesktop, bool isTablet) {
    // Next.js: grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-8
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _InteractiveCard(isDesktop: isDesktop, isTablet: isTablet, child: _buildRecentInvoicesContent(isDesktop, isTablet))),
          const SizedBox(width: 32), // gap-8 = 32px
          Expanded(child: _InteractiveCard(isDesktop: isDesktop, isTablet: isTablet, child: _buildQuickActionsContent(isDesktop, isTablet))),
        ],
      );
    } else {
      return Column(
        children: [
          _InteractiveCard(isDesktop: isDesktop, isTablet: isTablet, child: _buildRecentInvoicesContent(isDesktop, isTablet)),
          const SizedBox(height: 16), // gap-4 = 16px
          _InteractiveCard(isDesktop: isDesktop, isTablet: isTablet, child: _buildQuickActionsContent(isDesktop, isTablet)),
        ],
      );
    }
  }

  Widget _buildRecentInvoicesContent(bool isDesktop, bool isTablet) {
    // Next.js invoice data
    final invoices = [
      {'id': 'INV-2024-001', 'company': 'GlobalTech Industries', 'amount': '\$12,450', 'status': 'Paid', 'color': Colors.green},
      {'id': 'INV-2024-002', 'company': 'FastTrack Logistics', 'amount': '\$8,720', 'status': 'Pending', 'color': Colors.amber},
      {'id': 'INV-2024-003', 'company': 'ShipSmart Solutions', 'amount': '\$15,890', 'status': 'Sent', 'color': Colors.blue},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Next.js: text-xl lg:text-2xl font-semibold mb-4 lg:mb-6
        Text(
          'Recent Invoices',
          style: TextStyle(
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        // Invoice items - Next.js: space-y-4 (16px gap)
        ...invoices.asMap().entries.map((entry) {
          final index = entry.key;
          final invoice = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index < invoices.length - 1 ? 16 : 0),
            child: _InvoiceItem(invoice: invoice, isDesktop: isDesktop, isTablet: isTablet),
          );
        }),
      ],
    );
  }

  Widget _buildQuickActionsContent(bool isDesktop, bool isTablet) {
    // Next.js: Create Invoice, Generate Quote, Add Client, View Reports
    final actions = [
      {'title': 'Create Invoice', 'icon': Icons.receipt_long},
      {'title': 'Generate Quote', 'icon': Icons.inventory_2},
      {'title': 'Add Client', 'icon': Icons.people},
      {'title': 'View Reports', 'icon': Icons.warehouse},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Next.js: text-xl lg:text-2xl font-semibold mb-4 lg:mb-6
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isDesktop ? 24 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: isDesktop ? 24 : 16),
        // Next.js: grid grid-cols-2 gap-3 lg:gap-4
        // Use Wrap to let buttons grow naturally to fit content
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = isDesktop ? 16.0 : 12.0;
            final buttonWidth = (constraints.maxWidth - gap) / 2;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: actions.map((action) => SizedBox(
                width: buttonWidth,
                child: _ActionButton(action: action, isDesktop: isDesktop, isTablet: isTablet),
              )).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Interactive stat card with shine and pop-up effects
/// Matches Next.js: theme-card theme-interactive
class _InteractiveStatCard extends StatefulWidget {
  final Map<String, dynamic> stat;
  final bool isDesktop;
  final bool isTablet;
  final bool hasPulseGlow;

  const _InteractiveStatCard({
    required this.stat,
    required this.isDesktop,
    required this.isTablet,
    this.hasPulseGlow = false,
  });

  @override
  State<_InteractiveStatCard> createState() => _InteractiveStatCardState();
}

class _InteractiveStatCardState extends State<_InteractiveStatCard>
    with TickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  // Pulse glow animation - Next.js: animation: pulse-glow 3s ease-in-out infinite
  late AnimationController _pulseGlowController;
  late Animation<double> _pulseGlowAnimation;

  @override
  void initState() {
    super.initState();
    // Shine effect on hover
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // Pulse glow effect - continuous 3s animation
    _pulseGlowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _pulseGlowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseGlowController, curve: Curves.easeInOut),
    );

    // Start pulse glow if enabled
    if (widget.hasPulseGlow) {
      _pulseGlowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    _pulseGlowController.dispose();
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
    final badgeColor = widget.stat['color'] as Color;
    final borderRadius = widget.isDesktop ? 16.0 : 12.0;
    final padding = widget.isDesktop ? 24.0 : (widget.isTablet ? 20.0 : 16.0);
    final iconSize = widget.isDesktop ? 48.0 : 40.0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      // Wrap with AnimatedBuilder to listen to pulse glow animation
      child: AnimatedBuilder(
        animation: _pulseGlowAnimation,
        builder: (context, child) {
          // Calculate pulse glow values based on animation
          // Next.js: 0% -> box-shadow: 0 0 20px rgba(255,255,255,0.1)
          //          50% -> box-shadow: 0 0 40px rgba(255,255,255,0.2)
          final glowBlur = widget.hasPulseGlow
              ? 20.0 + (_pulseGlowAnimation.value * 20.0)  // 20px -> 40px
              : 0.0;
          final glowOpacity = widget.hasPulseGlow
              ? 0.1 + (_pulseGlowAnimation.value * 0.1)    // 0.1 -> 0.2
              : 0.0;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            transform: Matrix4.identity()
              ..translate(0.0, _isHovered ? -5.0 : 0.0)
              ..scale(_isHovered ? 1.03 : 1.0),
            transformAlignment: Alignment.center,
            // Put shadows on outer container so they're not clipped
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: [
                // shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.8)
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.8),
                  offset: Offset(0, 20),
                  blurRadius: 40,
                ),
                // Pulse glow effect - white glow around the card
                if (widget.hasPulseGlow)
                  BoxShadow(
                    color: Colors.white.withOpacity(glowOpacity),
                    blurRadius: glowBlur,
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    // Card gradient per specification: linear-gradient(135deg, #000000 0%, #1a1a1a 100%)
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(_isHovered ? 0.15 : 0.1),
                      width: 1,
                    ),
                  ),
              child: Stack(
                children: [
                  // Main content - matches Next.js layout exactly
                  // Content flows naturally top to bottom, no forced height
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Let card grow to fit content
                      children: [
                        // Next.js: flex items-center justify-between mb-3 lg:mb-4
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: iconSize,
                              height: iconSize,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Icon(widget.stat['icon'] as IconData, color: Colors.white.withOpacity(0.9), size: iconSize * 0.45),
                            ),
                            Text(
                              widget.stat['change'] as String,
                              style: TextStyle(
                                fontSize: widget.isTablet ? 14 : 12,
                                fontWeight: FontWeight.w500,
                                color: badgeColor,
                              ),
                            ),
                          ],
                        ),
                        // Next.js: mb-3 lg:mb-4 (12px, 16px)
                        SizedBox(height: widget.isDesktop ? 16 : 12),
                        // Next.js: text-xl sm:text-2xl lg:text-3xl font-bold mb-1 lg:mb-2
                        Text(
                          widget.stat['value'] as String,
                          style: TextStyle(
                            fontSize: widget.isDesktop ? 32 : (widget.isTablet ? 26 : 22),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: widget.isDesktop ? 8 : 4),
                        // Next.js: text-secondary text-sm lg:text-base
                        Text(
                          widget.stat['title'] as String,
                          style: TextStyle(
                            fontSize: widget.isDesktop ? 16 : 14,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Shine effect overlay - Next.js theme-interactive::after
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
        ),
        );  // Close AnimatedContainer
      },  // Close AnimatedBuilder builder
    ),  // Close AnimatedBuilder (pulse glow)
    );  // Close MouseRegion
  }
}

/// Interactive card wrapper with shine and pop-up effects
class _InteractiveCard extends StatefulWidget {
  final Widget child;
  final bool isDesktop;
  final bool isTablet;

  const _InteractiveCard({
    required this.child,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  State<_InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<_InteractiveCard>
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
    // Next.js: rounded-2xl lg:rounded-3xl (16px, 24px)
    final borderRadius = widget.isDesktop ? 24.0 : 16.0;
    // Next.js: p-5 sm:p-6 lg:p-8 (20px, 24px, 32px)
    final padding = widget.isDesktop ? 32.0 : (widget.isTablet ? 24.0 : 20.0);

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -5.0 : 0.0)
          ..scale(_isHovered ? 1.02 : 1.0),
        transformAlignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.all(padding),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                // Card gradient per specification: linear-gradient(135deg, #000000 0%, #1a1a1a 100%)
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(_isHovered ? 0.15 : 0.1),
                  width: 1,
                ),
                boxShadow: [
                  // shadow-lg: 0 20px 40px rgba(0, 0, 0, 0.8)
                  BoxShadow(
                    color: const Color.fromRGBO(0, 0, 0, 0.8),
                    offset: const Offset(0, 20),
                    blurRadius: 40,
                  ),
                ],
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
                              borderRadius: BorderRadius.circular(borderRadius),
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
        ),
      ),
    );
  }
}

/// Invoice item with hover effect
class _InvoiceItem extends StatefulWidget {
  final Map<String, dynamic> invoice;
  final bool isDesktop;
  final bool isTablet;

  const _InvoiceItem({
    required this.invoice,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  State<_InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<_InvoiceItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final statusColor = widget.invoice['color'] as Color;
    // Next.js: w-8 h-8 lg:w-10 lg:h-10 (32px, 40px)
    final iconContainerSize = widget.isDesktop ? 40.0 : 32.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            // Next.js: p-3 lg:p-4 glass-effect rounded-lg
            padding: EdgeInsets.all(widget.isDesktop ? 16 : 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              // Glass effect: rgba(255, 255, 255, 0.05)
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(_isHovered ? 0.15 : 0.1)),
            ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor.withOpacity(0.2),
              ),
              child: Icon(Icons.receipt_long, color: statusColor, size: iconContainerSize * 0.45),
            ),
            // Next.js: space-x-3 lg:space-x-4 (12px, 16px)
            SizedBox(width: widget.isDesktop ? 16 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Next.js: font-medium text-sm lg:text-base
                  Text(
                    widget.invoice['id'] as String,
                    style: TextStyle(fontSize: widget.isDesktop ? 16 : 14, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                  const SizedBox(height: 2),
                  // Next.js: text-secondary text-xs lg:text-sm
                  Text(
                    widget.invoice['company'] as String,
                    style: TextStyle(fontSize: widget.isDesktop ? 14 : 12, color: Colors.white.withOpacity(0.6)),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Next.js: font-bold text-sm lg:text-base
                Text(
                  widget.invoice['amount'] as String,
                  style: TextStyle(fontSize: widget.isDesktop ? 16 : 14, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 2),
                // Next.js: text-secondary text-xs lg:text-sm
                Text(
                  widget.invoice['status'] as String,
                  style: TextStyle(fontSize: widget.isDesktop ? 14 : 12, color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
          ],
        ),
          ),  // Close AnimatedContainer
        ),  // Close BackdropFilter
      ),  // Close ClipRRect
    );  // Close MouseRegion
  }
}

/// Action button with shine effect
class _ActionButton extends StatefulWidget {
  final Map<String, dynamic> action;
  final bool isDesktop;
  final bool isTablet;

  const _ActionButton({
    required this.action,
    required this.isDesktop,
    required this.isTablet,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
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
    // Next.js: p-4 lg:p-6 rounded-xl (16px, 24px)
    final padding = widget.isDesktop ? 24.0 : 16.0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -2.0 : 0.0)
            ..scale(_isHovered ? 1.02 : 1.0),
          transformAlignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            // Glass effect: bg-white/5 hover:bg-white/10
            color: Colors.white.withOpacity(_isHovered ? 0.1 : 0.05),
            border: Border.all(color: Colors.white.withOpacity(_isHovered ? 0.15 : 0.1)),
          ),
          child: Stack(
            children: [
              // Main content - Next.js: text-center
              Center(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Next.js: style={{ fontSize: '1.5rem' }} = 24px, mb-2 lg:mb-3
                      Icon(
                        widget.action['icon'] as IconData,
                        color: Colors.white.withOpacity(0.9),
                        size: 24,
                      ),
                      SizedBox(height: widget.isDesktop ? 12 : 8),
                      // Next.js: text-xs sm:text-sm lg:text-base font-medium
                      Text(
                        widget.action['title'] as String,
                        style: TextStyle(
                          fontSize: widget.isDesktop ? 16 : (widget.isTablet ? 14 : 12),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              // Shine effect overlay
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _shineAnimation,
                  builder: (context, child) {
                    return IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            begin: Alignment(_shineAnimation.value - 1, 0),
                            end: Alignment(_shineAnimation.value, 0),
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.08),
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
