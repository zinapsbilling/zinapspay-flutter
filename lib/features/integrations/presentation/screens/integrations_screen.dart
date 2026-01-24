import 'package:flutter/material.dart';
import '../../data/models/integration_models.dart';
import '../../data/integrations_data.dart';
import '../widgets/filter_sidebar.dart';
import '../widgets/integration_card.dart';
import '../widgets/coming_soon_card.dart';
import '../widgets/category_card.dart';
import '../widgets/app_detail_modal.dart';

class IntegrationsScreen extends StatefulWidget {
  const IntegrationsScreen({super.key});

  @override
  State<IntegrationsScreen> createState() => _IntegrationsScreenState();
}

class _IntegrationsScreenState extends State<IntegrationsScreen> {
  String _selectedCategory = 'all';
  String _searchTerm = '';
  String _connectionStatus = 'all';
  Integration? _selectedApp;
  bool _showAppModal = false;

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
  }

  void _onSearchChanged(String term) {
    setState(() => _searchTerm = term);
  }

  void _onStatusChanged(String status) {
    setState(() => _connectionStatus = status);
  }

  void _onAppTap(Integration app) {
    setState(() {
      _selectedApp = app;
      _showAppModal = true;
    });
  }

  void _closeAppModal() {
    setState(() {
      _showAppModal = false;
      _selectedApp = null;
    });
  }

  void _onConnectApp(Integration app) {
    // TODO: Implement connection flow
    debugPrint('Connect to ${app.name}');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive breakpoints matching dashboard
    final isDesktop = screenWidth >= 1200;
    final isTablet = screenWidth >= 768;
    final isMobile = screenWidth < 768;

    // Hide sidebar on mobile, show on tablet+
    final showSidebar = isTablet;
    // Sidebar width - responsive
    final sidebarWidth = isDesktop ? 320.0 : 280.0;

    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Sidebar - hide on mobile
            if (showSidebar)
              SizedBox(
                width: sidebarWidth,
                child: FilterSidebar(
                  selectedCategory: _selectedCategory,
                  searchTerm: _searchTerm,
                  connectionStatus: _connectionStatus,
                  onCategoryChanged: _onCategoryChanged,
                  onSearchChanged: _onSearchChanged,
                  onStatusChanged: _onStatusChanged,
                  onClearFilters: () {
                    setState(() {
                      _selectedCategory = 'all';
                      _searchTerm = '';
                      _connectionStatus = 'all';
                    });
                  },
                ),
              ),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(isDesktop, isTablet, isMobile),
                    _buildFeaturedSection(isDesktop, isTablet, isMobile),
                    _buildAvailableSection(isDesktop, isTablet, isMobile),
                    _buildComingSoonSection(isDesktop, isTablet, isMobile),
                    _buildBrowseByCategorySection(isDesktop, isTablet, isMobile),
                  ],
                ),
              ),
            ),
          ],
        ),
        // App Detail Modal
        if (_showAppModal && _selectedApp != null)
          AppDetailModal(
            app: _selectedApp!,
            onClose: _closeAppModal,
            onConnect: () => _onConnectApp(_selectedApp!),
          ),
      ],
    );
  }

  Widget _buildHeaderSection(bool isDesktop, bool isTablet, bool isMobile) {
    // Responsive padding
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    // Responsive font sizes
    final titleSize = isDesktop ? 36.0 : (isTablet ? 28.0 : 24.0);
    final subtitleSize = isDesktop ? 18.0 : (isTablet ? 16.0 : 14.0);

    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row - stack on mobile
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Integrations Marketplace',
                  style: TextStyle(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect your favorite apps and streamline your fulfillment workflow',
                  style: TextStyle(
                    fontSize: subtitleSize,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                _buildRequestButton(),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Integrations Marketplace',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Connect your favorite apps and streamline your fulfillment workflow',
                        style: TextStyle(
                          fontSize: subtitleSize,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                _buildRequestButton(),
              ],
            ),
          SizedBox(height: isDesktop ? 24 : 16),
          // Stats Bar
          _buildStatsBar(isDesktop, isTablet, isMobile),
        ],
      ),
    );
  }

  Widget _buildRequestButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Request integration
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.white.withOpacity(0.9), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Request Integration',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsBar(bool isDesktop, bool isTablet, bool isMobile) {
    final stats = [
      {'value': '247', 'label': 'Total Apps'},
      {'value': '12', 'label': 'Connected'},
      {'value': '34', 'label': 'Featured'},
      {'value': '15', 'label': 'New This Month'},
    ];

    final gap = isDesktop ? 16.0 : (isTablet ? 12.0 : 8.0);
    final fontSize = isDesktop ? 24.0 : (isTablet ? 20.0 : 18.0);
    final labelSize = isDesktop ? 14.0 : 12.0;

    // On mobile, show 2x2 grid; otherwise show row
    if (isMobile) {
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: stats.map((stat) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 32 - gap) / 2,
            child: _buildStatCard(stat, fontSize, labelSize),
          );
        }).toList(),
      );
    }

    return Row(
      children: stats.asMap().entries.map((entry) {
        final index = entry.key;
        final stat = entry.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < stats.length - 1 ? gap : 0),
            child: _buildStatCard(stat, fontSize, labelSize),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(Map<String, String> stat, double fontSize, double labelSize) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            stat['value']!,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat['label']!,
            style: TextStyle(
              fontSize: labelSize,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection(bool isDesktop, bool isTablet, bool isMobile) {
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final gap = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);

    // Responsive columns: 3 on desktop, 2 on tablet, 1 on mobile
    final columns = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Featured Integrations',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our most popular and highly recommended integrations',
            style: TextStyle(
              fontSize: isDesktop ? 14 : 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          _buildResponsiveGrid(
            items: featuredApps,
            columns: columns,
            gap: gap,
            itemBuilder: (app) => IntegrationCard(
              app: app,
              onTap: () => _onAppTap(app),
              onConnect: () => _onConnectApp(app),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableSection(bool isDesktop, bool isTablet, bool isMobile) {
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final gap = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);
    final columns = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Available Integrations',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to connect integrations',
            style: TextStyle(
              fontSize: isDesktop ? 14 : 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          _buildResponsiveGrid(
            items: availableApps,
            columns: columns,
            gap: gap,
            itemBuilder: (app) => IntegrationCard(
              app: app,
              onTap: () => _onAppTap(app),
              onConnect: () => _onConnectApp(app),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonSection(bool isDesktop, bool isTablet, bool isMobile) {
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final gap = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);

    // Responsive: 3 on desktop, 2 on tablet, 1 on mobile
    final columns = isDesktop ? 3 : (isTablet ? 2 : 1);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Integrations in development - get notified when ready',
            style: TextStyle(
              fontSize: isDesktop ? 14 : 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          _buildResponsiveGrid(
            items: comingSoonApps.take(4).toList(),
            columns: columns,
            gap: gap,
            itemBuilder: (app) => ComingSoonCard(
              app: app,
              onNotifyMe: () {
                // TODO: Implement notify
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseByCategorySection(bool isDesktop, bool isTablet, bool isMobile) {
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final gap = isDesktop ? 24.0 : (isTablet ? 16.0 : 12.0);

    // Responsive: 4 on desktop, 3 on tablet, 2 on mobile
    final columns = isDesktop ? 4 : (isTablet ? 3 : 2);

    return Container(
      padding: EdgeInsets.all(padding),
      color: const Color(0xFF1A1A1A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse by Category',
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find integrations by specific business needs',
            style: TextStyle(
              fontSize: isDesktop ? 14 : 13,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: isDesktop ? 24 : 16),
          _buildResponsiveGrid(
            items: browseCategories,
            columns: columns,
            gap: gap,
            itemBuilder: (category) => CategoryCard(
              category: category,
              onExplore: () {
                setState(() => _selectedCategory = category.id);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Generic responsive grid builder
  Widget _buildResponsiveGrid<T>({
    required List<T> items,
    required int columns,
    required double gap,
    required Widget Function(T item) itemBuilder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate card width based on available width and columns
        final totalGapWidth = gap * (columns - 1);
        final cardWidth = (constraints.maxWidth - totalGapWidth) / columns;

        // Ensure minimum card width to prevent overflow (200px min for proper content display)
        final effectiveCardWidth = cardWidth.clamp(200.0, double.infinity);

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: items.map((item) {
            return SizedBox(
              width: effectiveCardWidth,
              child: itemBuilder(item),
            );
          }).toList(),
        );
      },
    );
  }
}
