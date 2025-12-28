import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Returns Screen
/// Matches the design with:
/// - Stats cards row (Total Returns, Handled Returns, Sales Channels, Pending Returns)
/// - Syncfusion DataGrid with columns (Return ID, Order ID, Seller, Channel, Customer, Status)
/// - Header actions (Sync Channels, Analytics, Export Data, Ask AI for Insights, theme toggle, fullscreen)
class ReturnsScreen extends ConsumerStatefulWidget {
  const ReturnsScreen({super.key});

  @override
  ConsumerState<ReturnsScreen> createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends ConsumerState<ReturnsScreen> {
  late ReturnDataSource _returnDataSource;

  @override
  void initState() {
    super.initState();
    _returnDataSource = ReturnDataSource();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section
          _buildHeader(),
          // Main content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats cards row
                  _buildStatsCards(),
                  const SizedBox(height: 24),
                  // Data grid section
                  _buildDataGridSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
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
          // Title section
          Expanded(
            child: Row(
              children: [
                // Return icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.history,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Returns',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Process and analyze product returns - 1 returns loaded',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Action buttons - only show on larger screens
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(Icons.sync, 'Sync Channels'),
                  const SizedBox(width: 8),
                  _buildActionButton(Icons.bar_chart, 'Analytics'),
                  const SizedBox(width: 8),
                  _buildActionButton(Icons.download_outlined, 'Export Data'),
                  const SizedBox(width: 8),
                  _buildActionButton(Icons.auto_awesome, 'Ask AI for Insights'),
                  const SizedBox(width: 16),
                  // Theme toggle
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
                  // Fullscreen toggle
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
            ),
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

  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Returns',
            '1',
            'Return requests',
            null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Handled Returns',
            '0',
            'Processed',
            null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Sales Channels',
            '1',
            'Active channels',
            null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Pending Returns',
            '0',
            'Awaiting action',
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, String subtitle, Color? subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (subtitleColor == Colors.orange)
                Icon(
                  Icons.hourglass_empty,
                  color: subtitleColor,
                  size: 14,
                ),
              if (subtitleColor == Colors.orange)
                const SizedBox(width: 4),
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: subtitleColor ?? Colors.white.withOpacity(0.5),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataGridSection() {
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
                // BulkUpdate button
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
                // Add button
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
                // Search icon
                Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
                const SizedBox(width: 16),
                // More options
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
                source: _returnDataSource,
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
                  // Return ID column
                  GridColumn(
                    columnName: 'returnId',
                    label: _buildColumnHeader('Return ID'),
                  ),
                  // Order ID column
                  GridColumn(
                    columnName: 'orderId',
                    label: _buildColumnHeader('Order ID'),
                  ),
                  // Seller column
                  GridColumn(
                    columnName: 'seller',
                    label: _buildColumnHeader('Seller'),
                  ),
                  // Channel column
                  GridColumn(
                    columnName: 'channel',
                    label: _buildColumnHeader('Channel'),
                  ),
                  // Customer column
                  GridColumn(
                    columnName: 'customer',
                    label: _buildColumnHeader('Customer'),
                  ),
                  // Status column
                  GridColumn(
                    columnName: 'status',
                    label: _buildColumnHeader('Status'),
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
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data source for Returns DataGrid
class ReturnDataSource extends DataGridSource {
  ReturnDataSource() {
    _returns = [
      ReturnData(
        returnId: '9001',
        orderId: 'ORD-2024-001',
        seller: 'TechCorp Inc',
        channel: 'Online Store',
        customer: 'End User',
        status: 'Processing',
      ),
    ];
    buildDataGridRows();
  }

  List<ReturnData> _returns = [];
  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = _returns.map<DataGridRow>((returnData) {
      return DataGridRow(cells: [
        const DataGridCell<Widget>(columnName: 'expand', value: null),
        DataGridCell<String>(columnName: 'returnId', value: returnData.returnId),
        DataGridCell<String>(columnName: 'orderId', value: returnData.orderId),
        DataGridCell<String>(columnName: 'seller', value: returnData.seller),
        DataGridCell<String>(columnName: 'channel', value: returnData.channel),
        DataGridCell<String>(columnName: 'customer', value: returnData.customer),
        DataGridCell<String>(columnName: 'status', value: returnData.status),
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

/// Return data model
class ReturnData {
  ReturnData({
    required this.returnId,
    required this.orderId,
    required this.seller,
    required this.channel,
    required this.customer,
    required this.status,
  });

  final String returnId;
  final String orderId;
  final String seller;
  final String channel;
  final String customer;
  final String status;
}
