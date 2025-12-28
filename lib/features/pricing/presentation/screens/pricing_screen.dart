import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Pricing Screen
/// Matches the design with:
/// - Header: "Pricing" title with subtitle "Dynamic pricing management - Reference data from 4175 products (6 items)"
/// - Header actions: Ask AI for Pricing Insights, theme toggle, fullscreen
/// - Syncfusion DataGrid with columns: Name, Priority, Type, Value, Active
/// - Sample pricing rules data

/// Pricing rule data model
class PricingRule {
  PricingRule({
    required this.name,
    required this.priority,
    required this.type,
    required this.value,
    required this.active,
  });

  final String name;
  final int priority;
  final String type;
  final double value;
  final bool active;
}

/// Provider for pricing data
final pricingDataProvider = Provider<List<PricingRule>>((ref) {
  return [
    PricingRule(
      name: 'Enterprise Volume Discount',
      priority: 10,
      type: 'percentage_discount',
      value: 10,
      active: true,
    ),
    PricingRule(
      name: 'New Customer Welcome',
      priority: 20,
      type: 'percentage_discount',
      value: 5,
      active: true,
    ),
    PricingRule(
      name: 'Bulk Order Premium',
      priority: 15,
      type: 'percentage_markup',
      value: 15,
      active: true,
    ),
    PricingRule(
      name: 'Weekend Special',
      priority: 30,
      type: 'percentage_discount',
      value: 7.5,
      active: false,
    ),
    PricingRule(
      name: 'Shipping Distance Premium',
      priority: 5,
      type: 'fixed_markup',
      value: 25,
      active: true,
    ),
    PricingRule(
      name: 'Loyalty Gold Tier',
      priority: 12,
      type: 'percentage_discount',
      value: 12,
      active: true,
    ),
  ];
});

class PricingScreen extends ConsumerWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pricingRules = ref.watch(pricingDataProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(pricingRules.length),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildDataGridSection(pricingRules),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(int itemCount) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pricing',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Dynamic pricing management - Reference data from 4175 products ($itemCount items)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildActionButton(Icons.auto_awesome, 'Ask AI for Pricing Insights'),
              const SizedBox(width: 16),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Icon(
                  Icons.dark_mode_outlined,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Icon(
                  Icons.fullscreen,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.7),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataGridSection(List<PricingRule> pricingRules) {
    final dataSource = PricingDataSource(pricingRules: pricingRules);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag column header hint
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            child: Text(
              'Drag a column header here to group its column',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
          ),
          // Toolbar row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    'BulkUpdate',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white.withOpacity(0.7),
                    size: 16,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.sync,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
          // Syncfusion DataGrid
          SizedBox(
            height: 400,
            child: SfDataGridTheme(
              data: SfDataGridThemeData(
                headerColor: const Color(0xFF0A0A0A),
                selectionColor: const Color(0xFF1A1A1A),
                currentCellStyle: DataGridCurrentCellStyle(
                  borderColor: Colors.white.withOpacity(0.2),
                  borderWidth: 1,
                ),
                rowHoverColor: const Color(0xFF151515),
                headerHoverColor: const Color(0xFF151515),
                sortIconColor: Colors.white.withOpacity(0.6),
                filterIconColor: Colors.white.withOpacity(0.5),
                filterIconHoverColor: Colors.white.withOpacity(0.8),
                gridLineColor: Colors.white.withOpacity(0.08),
                gridLineStrokeWidth: 1,
                frozenPaneLineColor: Colors.white.withOpacity(0.1),
                sortOrderNumberBackgroundColor: const Color(0xFF2A2A2A),
                filterPopupBackgroundColor: const Color(0xFF0A0A0A),
                filterPopupTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                filterPopupDisabledTextStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14,
                ),
                filterPopupIconColor: Colors.white.withOpacity(0.7),
                filterPopupDisabledIconColor: Colors.white.withOpacity(0.3),
                filterPopupCheckboxFillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.transparent;
                }),
                okFilteringLabelColor: const Color(0xFF0A0A0A),
                okFilteringLabelButtonColor: Colors.white,
                cancelFilteringLabelColor: Colors.white.withOpacity(0.8),
                cancelFilteringLabelButtonColor: Colors.transparent,
              ),
              child: SfDataGrid(
                source: dataSource,
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
                  // Name column
                  GridColumn(
                    columnName: 'name',
                    minimumWidth: 200,
                    label: _buildColumnHeader('Name'),
                  ),
                  // Priority column
                  GridColumn(
                    columnName: 'priority',
                    minimumWidth: 100,
                    label: _buildColumnHeader('Priority'),
                  ),
                  // Type column
                  GridColumn(
                    columnName: 'type',
                    minimumWidth: 180,
                    label: _buildColumnHeader('Type'),
                  ),
                  // Value column
                  GridColumn(
                    columnName: 'value',
                    minimumWidth: 100,
                    label: _buildColumnHeader('Value'),
                  ),
                  // Active column
                  GridColumn(
                    columnName: 'active',
                    minimumWidth: 100,
                    label: _buildColumnHeader('Active'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumnHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// Data source for Pricing DataGrid
class PricingDataSource extends DataGridSource {
  final List<PricingRule> pricingRules;

  PricingDataSource({required this.pricingRules}) {
    buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = pricingRules.map<DataGridRow>((rule) {
      return DataGridRow(cells: [
        const DataGridCell<Widget>(columnName: 'expand', value: null),
        DataGridCell<String>(columnName: 'name', value: rule.name),
        DataGridCell<int>(columnName: 'priority', value: rule.priority),
        DataGridCell<String>(columnName: 'type', value: rule.type),
        DataGridCell<double>(columnName: 'value', value: rule.value),
        DataGridCell<bool>(columnName: 'active', value: rule.active),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFF0A0A0A),
      cells: row.getCells().map<Widget>((cell) {
        if (cell.columnName == 'expand') {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.play_arrow,
              color: Colors.white.withOpacity(0.5),
              size: 16,
            ),
          );
        }
        if (cell.columnName == 'type') {
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              cell.value.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFD4A574), // Tan/brown color for type
              ),
            ),
          );
        }
        if (cell.columnName == 'active') {
          final isActive = cell.value as bool;
          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              isActive ? 'true' : 'false',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          );
        }
        return Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            cell.value?.toString() ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        );
      }).toList(),
    );
  }
}
