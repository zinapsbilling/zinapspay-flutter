import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';

// Navigation item model
class NavItem {
  final String name;
  final String? href;
  final IconData icon;
  final List<NavSubItem>? subItems;

  const NavItem({
    required this.name,
    this.href,
    required this.icon,
    this.subItems,
  });
}

class NavSubItem {
  final String name;
  final String href;
  final IconData icon;

  const NavSubItem({
    required this.name,
    required this.href,
    required this.icon,
  });
}

// Navigation items matching Next.js
final List<NavItem> navItems = [
  const NavItem(
    name: 'ZinapsAI',
    href: '/zinapsai',
    icon: Icons.smart_toy,
  ),
  const NavItem(
    name: 'AI Hub',
    icon: Icons.settings,
    subItems: [
      NavSubItem(name: 'Chat History', href: '/ai-hub/history', icon: Icons.chat),
      NavSubItem(name: 'Collaboration', href: '/zinapsai/collaboration', icon: Icons.people),
      NavSubItem(name: 'Workflows', href: '/zinapsai/workflows', icon: Icons.settings),
      NavSubItem(name: 'Analytics', href: '/zinapsai/analytics', icon: Icons.analytics),
      NavSubItem(name: 'Model Training', href: '/zinapsai/training', icon: Icons.work),
      NavSubItem(name: 'Search & Archive', href: '/zinapsai/search', icon: Icons.search),
    ],
  ),
  const NavItem(
    name: 'Dashboard',
    href: '/dashboard',
    icon: Icons.dashboard,
  ),
  const NavItem(
    name: 'Operations',
    icon: Icons.factory,
    subItems: [
      NavSubItem(name: 'Inventory', href: '/inventory', icon: Icons.inventory_2),
      NavSubItem(name: 'Inbound', href: '/inbound', icon: Icons.arrow_downward),
      NavSubItem(name: 'Outbound', href: '/outbound', icon: Icons.arrow_upward),
      NavSubItem(name: 'Storage', href: '/storage', icon: Icons.warehouse),
      NavSubItem(name: 'Shipments', href: '/shipments', icon: Icons.local_shipping),
      NavSubItem(name: 'Returns', href: '/returns', icon: Icons.replay),
    ],
  ),
  const NavItem(
    name: 'Business',
    icon: Icons.business_center,
    subItems: [
      NavSubItem(name: 'Analytics', href: '/analytics', icon: Icons.analytics),
      NavSubItem(name: 'Customers', href: '/customers', icon: Icons.people),
      NavSubItem(name: 'Pricing', href: '/pricing', icon: Icons.attach_money),
      NavSubItem(name: 'Billing', href: '/billing', icon: Icons.credit_card),
    ],
  ),
  const NavItem(
    name: 'Configuration',
    icon: Icons.build,
    subItems: [
      NavSubItem(name: 'Rules', href: '/rules', icon: Icons.gavel),
      NavSubItem(name: 'Templates', href: '/templates', icon: Icons.description),
      NavSubItem(name: 'Integrations', href: '/integrations', icon: Icons.extension),
      NavSubItem(name: 'Import Status', href: '/import-status', icon: Icons.cloud_download),
    ],
  ),
  const NavItem(
    name: 'Support',
    icon: Icons.support,
    subItems: [
      NavSubItem(name: 'Onboarding', href: '/onboarding', icon: Icons.rocket_launch),
      NavSubItem(name: 'Help', href: '/help', icon: Icons.help),
      NavSubItem(name: 'Feedback', href: '/feedback', icon: Icons.chat),
      NavSubItem(name: 'Settings', href: '/settings', icon: Icons.settings),
    ],
  ),
];

class SidebarNav extends StatefulWidget {
  final String currentPath;
  final Function(bool)? onCollapsedChanged;

  const SidebarNav({
    super.key,
    required this.currentPath,
    this.onCollapsedChanged,
  });

  @override
  State<SidebarNav> createState() => _SidebarNavState();
}

class _SidebarNavState extends State<SidebarNav> with SingleTickerProviderStateMixin {
  bool _isCollapsed = true;
  bool _showExpandedContent = false; // Delayed state for content rendering
  final Set<String> _expandedItems = {};
  String? _hoveredDropdown;
  String? _hoveredItem; // Track which item is being hovered for tooltip
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  // Sidebar widths matching Next.js - EXACT per specification
  static const double _collapsedWidth = 80;   // Collapsed: 80px
  static const double _expandedWidth = 320;   // Expanded: 320px
  static const Duration _animationDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    // Auto-expand the group containing current page
    _autoExpandCurrentGroup();
  }

  void _autoExpandCurrentGroup() {
    for (final item in navItems) {
      if (item.subItems != null) {
        final hasActiveChild = item.subItems!.any((sub) => widget.currentPath == sub.href);
        if (hasActiveChild) {
          _expandedItems.add(item.name);
        }
      }
    }
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
      // When collapsing: immediately hide expanded content
      // When expanding: delay showing expanded content until animation completes
      if (_isCollapsed) {
        _showExpandedContent = false;
      } else {
        // Delay expanded content until width animation is done
        Future.delayed(_animationDuration, () {
          if (mounted && !_isCollapsed) {
            setState(() {
              _showExpandedContent = true;
            });
          }
        });
      }
    });
    widget.onCollapsedChanged?.call(_isCollapsed);
  }

  void _toggleExpanded(String itemName) {
    setState(() {
      if (_expandedItems.contains(itemName)) {
        _expandedItems.remove(itemName);
      } else {
        _expandedItems.add(itemName);
      }
    });
  }

  bool _isItemActive(NavItem item) {
    if (item.href != null && widget.currentPath == item.href) {
      return true;
    }
    if (item.subItems != null) {
      return item.subItems!.any((sub) => widget.currentPath == sub.href);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final width = _isCollapsed ? _collapsedWidth : _expandedWidth;

    // The key insight from Next.js:
    // - Width animates with CSS transition (300ms)
    // - Content is conditionally rendered with {!isCollapsed && ...}
    // - overflow: hidden clips content during animation
    //
    // In Flutter, we use:
    // - AnimatedContainer for width animation
    // - OverflowBox to allow content to be larger than the animated width
    // - ClipRect to clip the overflowing content
    // - _isCollapsed for conditional content rendering

    // Match Next.js behavior: conditionally render text, not clip it
    // Icons are centered when collapsed, full layout when expanded
    // Use _showExpandedContent (delayed) instead of !_isCollapsed to prevent overflow during animation
    return AnimatedContainer(
      duration: _animationDuration,
      curve: Curves.easeInOut,
      width: width,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0A0A0A), Color(0xFF0F0F0F)],
            ),
            border: Border(
              right: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(),
              _buildAISection(),
              if (_showExpandedContent) _buildSearchBar(),
              Expanded(child: _buildNavigation()),
              _buildUserProfile(),
              _buildSignOutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Next.js approach: conditionally show text, center icon when collapsed
    // Use !_showExpandedContent to delay Row rendering until animation is done
    return Container(
      padding: EdgeInsets.all(_showExpandedContent ? 24 : 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: !_showExpandedContent
          // Collapsed: centered icon + collapse button vertically
          ? Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.05),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: const Icon(Icons.receipt_long, color: Colors.white, size: 24),
                ),
                const SizedBox(height: 12),
                _buildCollapseButton(),
              ],
            )
          // Expanded: full row with icon, text, and collapse button
          : Row(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, AppColors.silver, Colors.white],
                        ).createShader(bounds),
                        child: const Text(
                          'ZinapsPay',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Text(
                        'Warehouse Management',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildCollapseButton(),
              ],
            ),
    );
  }

  Widget _buildCollapseButton() {
    return IconButton(
      onPressed: _toggleCollapse,
      icon: const Icon(Icons.menu, size: 20),
      color: Colors.white.withOpacity(0.6),
      tooltip: _isCollapsed ? 'Expand Sidebar' : 'Collapse Sidebar',
    );
  }

  Widget _buildAISection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: _showExpandedContent ? 16 : 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Column(
        children: navItems.take(2).map((item) => _buildNavItem(item, isAISection: true)).toList(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _searchTerm = value),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search navigation...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.4), size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation() {
    final filteredItems = navItems.skip(2).where((item) {
      if (_searchTerm.isEmpty) return true;
      final searchLower = _searchTerm.toLowerCase();
      if (item.name.toLowerCase().contains(searchLower)) return true;
      if (item.subItems != null) {
        return item.subItems!.any((sub) => sub.name.toLowerCase().contains(searchLower));
      }
      return false;
    }).toList();

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: _showExpandedContent ? 16 : 8, vertical: 8),
      children: filteredItems.map((item) => _buildNavItem(item)).toList(),
    );
  }

  Widget _buildNavItem(NavItem item, {bool isAISection = false}) {
    final isActive = _isItemActive(item);
    final hasSubmenu = item.subItems != null && item.subItems!.isNotEmpty;
    final isExpanded = _expandedItems.contains(item.name);

    return Column(
      children: [
        MouseRegion(
          onEnter: (_) {
            if (_isCollapsed) {
              setState(() {
                _hoveredItem = item.name;
                if (hasSubmenu) {
                  _hoveredDropdown = item.name;
                }
              });
            }
          },
          onExit: (_) {
            if (_isCollapsed) {
              Future.delayed(const Duration(milliseconds: 200), () {
                if (mounted) {
                  setState(() {
                    if (_hoveredItem == item.name) _hoveredItem = null;
                    if (_hoveredDropdown == item.name) _hoveredDropdown = null;
                  });
                }
              });
            }
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    if (hasSubmenu) {
                      if (_isCollapsed) {
                        setState(() {
                          _hoveredDropdown = _hoveredDropdown == item.name ? null : item.name;
                        });
                      } else {
                        _toggleExpanded(item.name);
                      }
                    } else if (item.href != null) {
                      context.go(item.href!);
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  // Next.js approach: conditionally show text
                  // Use !_showExpandedContent to delay Row rendering until animation is done
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
                    ),
                    child: !_showExpandedContent
                        // Collapsed: just centered icon
                        ? Center(
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                            ),
                          )
                        // Expanded: icon + text + arrow
                        : Row(
                            children: [
                              Icon(
                                item.icon,
                                size: 20,
                                color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                    color: isActive ? Colors.white : Colors.white.withOpacity(0.8),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hasSubmenu)
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
              // Collapsed tooltip - only show on hover for items WITHOUT submenu
              // Items with submenu show dropdown instead
              if (_isCollapsed && !hasSubmenu && _hoveredItem == item.name)
                Positioned(
                  left: 60,
                  top: 8,
                  child: _buildTooltip(item.name),
                ),
              // Collapsed dropdown menu for items WITH submenu
              if (_isCollapsed && hasSubmenu && _hoveredDropdown == item.name)
                Positioned(
                  left: 70,
                  top: 0,
                  child: _buildCollapsedDropdown(item),
                ),
            ],
          ),
        ),
        // Expanded submenu
        if (_showExpandedContent && hasSubmenu && isExpanded)
          _buildSubmenu(item.subItems!),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _buildTooltip(String text) {
    return IgnorePointer(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedDropdown(NavItem item) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredDropdown = item.name),
      onExit: (_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) setState(() => _hoveredDropdown = null);
        });
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F0F),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                item.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Divider(color: Colors.white.withOpacity(0.1), height: 1),
            const SizedBox(height: 8),
            ...item.subItems!.map((subItem) {
              final isSubActive = widget.currentPath == subItem.href;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.go(subItem.href);
                    setState(() => _hoveredDropdown = null);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isSubActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          subItem.icon,
                          size: 16,
                          color: isSubActive ? Colors.white : Colors.white.withOpacity(0.6),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            subItem.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSubActive ? FontWeight.w600 : FontWeight.w400,
                              color: isSubActive ? Colors.white : Colors.white.withOpacity(0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmenu(List<NavSubItem> subItems) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 4),
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white.withOpacity(0.1))),
        ),
        child: Column(
          children: subItems.map((subItem) {
            final isSubActive = widget.currentPath == subItem.href;
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go(subItem.href),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSubActive ? Colors.white.withOpacity(0.05) : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        subItem.icon,
                        size: 16,
                        color: isSubActive ? Colors.white : Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          subItem.name,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSubActive ? Colors.white : Colors.white.withOpacity(0.6),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: EdgeInsets.all(_showExpandedContent ? 16 : 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: Container(
        padding: EdgeInsets.all(_showExpandedContent ? 12 : 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white.withOpacity(0.05),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        // Next.js approach: conditionally show text
        // Use !_showExpandedContent to delay Row rendering until animation is done
        child: !_showExpandedContent
            // Collapsed: just centered avatar
            ? Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Center(
                    child: Text(
                      'JS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              )
            // Expanded: avatar + name + settings button
            : Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'John Smith',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Administrator',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go('/settings'),
                    icon: Icon(Icons.settings, size: 18, color: Colors.white.withOpacity(0.6)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: EdgeInsets.all(_showExpandedContent ? 16 : 8).copyWith(top: 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Implement sign out with Cognito
            context.go(AppRoutes.login);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            // Conditional rendering like Next.js approach
            // Use !_showExpandedContent to delay Row rendering until animation is done
            child: !_showExpandedContent
                // Collapsed: just centered icon
                ? Center(
                    child: Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  )
                // Expanded: icon + text
                : Row(
                    children: [
                      Icon(
                        Icons.logout,
                        size: 20,
                        color: Colors.white.withOpacity(0.6),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
