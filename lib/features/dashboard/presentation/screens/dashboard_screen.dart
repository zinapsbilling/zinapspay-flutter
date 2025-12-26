import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 640;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.jetBlack, AppColors.charcoal, AppColors.jetBlack],
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingOrbs(context),
            SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, isDesktop),
                  Expanded(
                    child: SingleChildScrollView(
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
                    ),
                  ),
                ],
              ),
            ),
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
        gradient: RadialGradient(colors: [Colors.white.withOpacity(opacity), Colors.transparent]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32 : 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Row(
        children: [
          // Logo
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(colors: [Colors.white, AppColors.silver, Colors.white]).createShader(b),
                child: const Text('ZinapsPay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const Spacer(),
          // User menu
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined, color: Colors.white.withOpacity(0.8)),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Center(child: Text('JS', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600))),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => context.go(AppRoutes.login),
                icon: Icon(Icons.logout, color: Colors.white.withOpacity(0.6)),
                tooltip: 'Sign out',
              ),
            ],
          ),
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isDesktop ? 4 : 2,
        crossAxisSpacing: gap,
        mainAxisSpacing: gap,
        // Next.js cards are wide and short - ratio ~3:1 (width:height)
        childAspectRatio: isDesktop ? 2.5 : 1.75,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index], isDesktop, isTablet),
    );
  }

  Widget _buildStatCard(Map<String, dynamic> stat, bool isDesktop, bool isTablet) {
    final badgeColor = stat['color'] as Color;

    final borderRadius = isDesktop ? 16.0 : 12.0;
    final padding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);
    final iconSize = isDesktop ? 48.0 : 40.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            // Next.js glossy gradient
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A0A), Color(0xFF1A1A1A)],
            ),
            // Glossy border - brighter on top/left
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.12), width: 1),
              left: BorderSide(color: Colors.white.withOpacity(0.08), width: 1),
              right: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
              bottom: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    child: Icon(stat['icon'] as IconData, color: Colors.white, size: iconSize * 0.45),
                  ),
                  Text(
                    stat['change'] as String,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w500,
                      color: badgeColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stat['value'] as String,
                    style: TextStyle(
                      fontSize: isDesktop ? 32 : (isTablet ? 26 : 22),
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: isDesktop ? 4 : 2),
                  Text(
                    stat['title'] as String,
                    style: TextStyle(
                      fontSize: isDesktop ? 14 : 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(bool isDesktop, bool isTablet) {
    // Next.js: grid grid-cols-1 lg:grid-cols-2 gap-4 lg:gap-8
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildRecentInvoices(isDesktop, isTablet)),
          const SizedBox(width: 32), // gap-8 = 32px
          Expanded(child: _buildQuickActions(isDesktop, isTablet)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildRecentInvoices(isDesktop, isTablet),
          const SizedBox(height: 16), // gap-4 = 16px
          _buildQuickActions(isDesktop, isTablet),
        ],
      );
    }
  }

  Widget _buildRecentInvoices(bool isDesktop, bool isTablet) {
    // Next.js invoice data
    final invoices = [
      {'id': 'INV-2024-001', 'company': 'GlobalTech Industries', 'amount': '\$12,450', 'status': 'Paid', 'color': Colors.green},
      {'id': 'INV-2024-002', 'company': 'FastTrack Logistics', 'amount': '\$8,720', 'status': 'Pending', 'color': Colors.amber},
      {'id': 'INV-2024-003', 'company': 'ShipSmart Solutions', 'amount': '\$15,890', 'status': 'Sent', 'color': Colors.blue},
    ];

    // Next.js: rounded-2xl lg:rounded-3xl (16px, 24px)
    final borderRadius = isDesktop ? 24.0 : 16.0;
    // Next.js: p-5 sm:p-6 lg:p-8 (20px, 24px, 32px)
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 20.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.jetBlack, AppColors.darkGray]),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
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
                  child: _buildInvoiceItem(invoice, isDesktop, isTablet),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceItem(Map<String, dynamic> invoice, bool isDesktop, bool isTablet) {
    final statusColor = invoice['color'] as Color;
    // Next.js: w-8 h-8 lg:w-10 lg:h-10 (32px, 40px)
    final iconContainerSize = isDesktop ? 40.0 : 32.0;

    return Container(
      // Next.js: p-3 lg:p-4 glass-effect rounded-lg
      padding: EdgeInsets.all(isDesktop ? 16 : 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
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
          SizedBox(width: isDesktop ? 16 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Next.js: font-medium text-sm lg:text-base
                Text(
                  invoice['id'] as String,
                  style: TextStyle(fontSize: isDesktop ? 16 : 14, fontWeight: FontWeight.w500, color: Colors.white),
                ),
                const SizedBox(height: 2),
                // Next.js: text-secondary text-xs lg:text-sm
                Text(
                  invoice['company'] as String,
                  style: TextStyle(fontSize: isDesktop ? 14 : 12, color: Colors.white.withOpacity(0.6)),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Next.js: font-bold text-sm lg:text-base
              Text(
                invoice['amount'] as String,
                style: TextStyle(fontSize: isDesktop ? 16 : 14, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 2),
              // Next.js: text-secondary text-xs lg:text-sm
              Text(
                invoice['status'] as String,
                style: TextStyle(fontSize: isDesktop ? 14 : 12, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(bool isDesktop, bool isTablet) {
    // Next.js: Create Invoice, Generate Quote, Add Client, View Reports
    final actions = [
      {'title': 'Create Invoice', 'icon': Icons.receipt_long},
      {'title': 'Generate Quote', 'icon': Icons.inventory_2},
      {'title': 'Add Client', 'icon': Icons.people},
      {'title': 'View Reports', 'icon': Icons.warehouse},
    ];

    // Next.js: rounded-2xl lg:rounded-3xl (16px, 24px)
    final borderRadius = isDesktop ? 24.0 : 16.0;
    // Next.js: p-5 sm:p-6 lg:p-8 (20px, 24px, 32px)
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 20.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.jetBlack, AppColors.darkGray]),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
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
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: isDesktop ? 16 : 12,
                mainAxisSpacing: isDesktop ? 16 : 12,
                // Next.js buttons are wide rectangles, not squares - much higher ratio
                childAspectRatio: isDesktop ? 3.2 : 2.5,
                children: actions.map((action) => _buildActionButton(action, isDesktop, isTablet)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(Map<String, dynamic> action, bool isDesktop, bool isTablet) {
    // Next.js: p-4 lg:p-6 rounded-xl (16px, 24px)
    final padding = isDesktop ? 24.0 : 16.0;

    return Material(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Next.js: style={{ fontSize: '1.5rem' }} = 24px, mb-2 lg:mb-3
              Icon(
                action['icon'] as IconData,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(height: isDesktop ? 12 : 8),
              // Next.js: text-xs sm:text-sm lg:text-base font-medium
              Text(
                action['title'] as String,
                style: TextStyle(
                  fontSize: isDesktop ? 16 : (isTablet ? 14 : 12),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
