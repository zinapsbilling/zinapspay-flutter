import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Customer Management Screen
/// Matches the design with:
/// - Stats cards row (Total Customers, Unique Sellers, Package Types, Data Status)
/// - Syncfusion DataGrid with columns (Customer, Seller ID, EAN, Package Type, Sub Seller)
/// - Header actions (Sync with CRM, Export Data, Ask AI for Insights, theme toggle, fullscreen)
class CustomersScreen extends ConsumerStatefulWidget {
  const CustomersScreen({super.key});

  @override
  ConsumerState<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends ConsumerState<CustomersScreen> {
  late CustomerDataSource _customerDataSource;
  final List<Customer> _customers = [
    Customer('TechCorp Inc', 1001, '1234567890123', 'Standard', ''),
    Customer('Global Solutions', 1002, '2345678901234', 'Premium', 'Regional Partner'),
  ];

  @override
  void initState() {
    super.initState();
    _customerDataSource = CustomerDataSource(customers: _customers);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;
    final isTablet = screenWidth >= 640;
    final padding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with title and actions
          _buildHeader(isDesktop, isTablet),
          const SizedBox(height: 24),
          // Stats cards row
          _buildStatsRow(isDesktop, isTablet),
          const SizedBox(height: 24),
          // Data grid section
          _buildDataGridSection(isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop, bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Management',
              style: TextStyle(
                fontSize: isDesktop ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Customer data analysis with DataGrid - ${_customers.length} customers loaded',
              style: TextStyle(
                fontSize: isDesktop ? 14 : 12,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
          ],
        ),
        // Action buttons
        if (isDesktop || isTablet) _buildActionButtons(isDesktop),
      ],
    );
  }

  Widget _buildActionButtons(bool isDesktop) {
    return Row(
      children: [
        _ActionButton(label: 'Sync with CRM', onTap: () {}),
        const SizedBox(width: 8),
        _ActionButton(label: 'Export Data', onTap: () {}),
        const SizedBox(width: 8),
        _ActionButton(label: 'Ask AI for Insights', onTap: () {}, isPrimary: true),
        const SizedBox(width: 16),
        // Theme toggle
        _IconActionButton(icon: Icons.dark_mode_outlined, onTap: () {}),
        const SizedBox(width: 8),
        // Fullscreen toggle
        _IconActionButton(icon: Icons.fullscreen, onTap: () {}),
      ],
    );
  }

  Widget _buildStatsRow(bool isDesktop, bool isTablet) {
    final stats = [
      _StatData(
        title: 'Total Customers',
        value: '${_customers.length}',
        subtitle: 'Active records',
        color: const Color(0xFF22C55E), // green
      ),
      _StatData(
        title: 'Unique Sellers',
        value: '${_customers.map((c) => c.sellerId).toSet().length}',
        subtitle: 'Active sellers',
        color: const Color(0xFF3B82F6), // blue
      ),
      _StatData(
        title: 'Package Types',
        value: '${_customers.map((c) => c.packageType).toSet().length}',
        subtitle: 'Different types',
        color: const Color(0xFFFBBF24), // amber
      ),
      _StatData(
        title: 'Data Status',
        value: 'Ready',
        subtitle: 'Synced',
        color: const Color(0xFF22C55E), // green
        showStatusDot: true,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return Row(
            children: stats.map((stat) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: stats.indexOf(stat) < stats.length - 1 ? 16 : 0,
                  ),
                  child: _StatCard(stat: stat),
                ),
              );
            }).toList(),
          );
        } else {
          return GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: stats.map((stat) => _StatCard(stat: stat)).toList(),
          );
        }
      },
    );
  }

  Widget _buildDataGridSection(bool isDesktop, bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag hint and toolbar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Drag a column header here to group its column',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                Row(
                  children: [
                    _ToolbarButton(
                      label: 'BulkUpdate',
                      icon: Icons.add,
                      onTap: () {},
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.search, color: Colors.white.withOpacity(0.5), size: 20),
                    const SizedBox(width: 12),
                    Icon(Icons.more_vert, color: Colors.white.withOpacity(0.5), size: 20),
                  ],
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.08),
          ),
          // Syncfusion DataGrid with dark theme
          SizedBox(
            height: 400,
            child: SfDataGridTheme(
              data: SfDataGridThemeData(
                // Background colors
                headerColor: const Color(0xFF0A0A0A),
                // Selection colors - dark highlight instead of white
                selectionColor: const Color(0xFF1A1A1A),
                currentCellStyle: DataGridCurrentCellStyle(
                  borderColor: Colors.white.withOpacity(0.2),
                  borderWidth: 1,
                ),
                // Row hover color
                rowHoverColor: const Color(0xFF151515),
                // Header hover
                headerHoverColor: const Color(0xFF151515),
                // Sort icon color
                sortIconColor: Colors.white.withOpacity(0.6),
                // Filter icon color
                filterIconColor: Colors.white.withOpacity(0.5),
                filterIconHoverColor: Colors.white.withOpacity(0.8),
                // Grid lines
                gridLineColor: Colors.white.withOpacity(0.08),
                gridLineStrokeWidth: 1,
                // Frozen pane
                frozenPaneLineColor: Colors.white.withOpacity(0.1),
                // Sort order position
                sortOrderNumberBackgroundColor: const Color(0xFF2A2A2A),
                // Filter popup styling - PURE BLACK theme
                filterPopupBackgroundColor: const Color(0xFF0A0A0A),
                filterPopupTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                filterPopupDisabledTextStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                ),
                // Filter popup icons
                filterPopupIconColor: Colors.white.withOpacity(0.7),
                filterPopupDisabledIconColor: Colors.white.withOpacity(0.3),
                // Filter popup checkboxes - white when selected
                filterPopupCheckboxFillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.transparent;
                }),
                // OK button - white background with dark text
                okFilteringLabelColor: const Color(0xFF0A0A0A),
                okFilteringLabelButtonColor: Colors.white,
                // Cancel button - transparent with white text
                cancelFilteringLabelColor: Colors.white.withOpacity(0.8),
                cancelFilteringLabelButtonColor: Colors.transparent,
              ),
              child: SfDataGrid(
                source: _customerDataSource,
                columnWidthMode: ColumnWidthMode.fill,
                gridLinesVisibility: GridLinesVisibility.horizontal,
                headerGridLinesVisibility: GridLinesVisibility.horizontal,
                allowSorting: true,
                allowFiltering: true,
                selectionMode: SelectionMode.single,
                navigationMode: GridNavigationMode.cell,
                columns: [
                  // Expand/collapse column
                  GridColumn(
                    columnName: 'expand',
                    width: 50,
                    allowSorting: false,
                    allowFiltering: false,
                    label: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.center,
                      child: const SizedBox(),
                    ),
                  ),
                  // Customer column
                  GridColumn(
                    columnName: 'customer',
                    label: _buildColumnHeader('Customer'),
                  ),
                  // Seller ID column
                  GridColumn(
                    columnName: 'sellerId',
                    label: _buildColumnHeader('Seller ID'),
                  ),
                  // EAN column
                  GridColumn(
                    columnName: 'ean',
                    label: _buildColumnHeader('EAN'),
                  ),
                  // Package Type column
                  GridColumn(
                    columnName: 'packageType',
                    label: _buildColumnHeader('Package Type'),
                  ),
                  // Sub Seller column
                  GridColumn(
                    columnName: 'subSeller',
                    label: _buildColumnHeader('Sub Seller'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title, {bool showFilter = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          if (showFilter) ...[
            const Spacer(),
            Icon(
              Icons.filter_list,
              size: 16,
              color: Colors.white.withOpacity(0.4),
            ),
          ],
        ],
      ),
    );
  }
}

// Data models
class Customer {
  final String name;
  final int sellerId;
  final String ean;
  final String packageType;
  final String subSeller;

  Customer(this.name, this.sellerId, this.ean, this.packageType, this.subSeller);
}

class _StatData {
  final String title;
  final String value;
  final String subtitle;
  final Color color;
  final bool showStatusDot;

  _StatData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
    this.showStatusDot = false,
  });
}

// Syncfusion DataSource
class CustomerDataSource extends DataGridSource {
  CustomerDataSource({required List<Customer> customers}) {
    _customers = customers.map<DataGridRow>((customer) {
      return DataGridRow(cells: [
        const DataGridCell<Widget>(columnName: 'expand', value: null),
        DataGridCell<String>(columnName: 'customer', value: customer.name),
        DataGridCell<int>(columnName: 'sellerId', value: customer.sellerId),
        DataGridCell<String>(columnName: 'ean', value: customer.ean),
        DataGridCell<String>(columnName: 'packageType', value: customer.packageType),
        DataGridCell<String>(columnName: 'subSeller', value: customer.subSeller),
      ]);
    }).toList();
  }

  List<DataGridRow> _customers = [];

  @override
  List<DataGridRow> get rows => _customers;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFF0A0A0A),
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'expand') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.center,
            child: Icon(
              Icons.play_arrow,
              size: 16,
              color: Colors.white.withOpacity(0.4),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            cell.value?.toString() ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// UI Components
class _StatCard extends StatefulWidget {
  final _StatData stat;

  const _StatCard({required this.stat});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.stat.color.withOpacity(0.3)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.stat.title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.stat.value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                if (widget.stat.showStatusDot) ...[
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: widget.stat.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  widget.stat.subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: widget.stat.showStatusDot
                        ? widget.stat.color
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isPrimary
                ? (_isHovered ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.1))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.15),
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ),
      ),
    );
  }
}

class _IconActionButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered
                  ? Colors.white.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(
            widget.icon,
            size: 18,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolbarButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ToolbarButton> createState() => _ToolbarButtonState();
}

class _ToolbarButtonState extends State<_ToolbarButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                widget.icon,
                size: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
