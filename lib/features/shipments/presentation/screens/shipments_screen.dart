import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/// Shipments Screen
/// Track shipments and delivery status - Monitor active shipments across multiple carriers
/// Uses Syncfusion DataGrid with dark theme styling
class ShipmentsScreen extends ConsumerStatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  ConsumerState<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends ConsumerState<ShipmentsScreen> {
  late ShipmentDataSource _shipmentDataSource;
  final List<Shipment> _shipments = [
    Shipment('SH-2024-001', 'DHL123456789', 'Resourceas', 'DHL', 'In Transit', 'DHL Hub Frankfurt'),
    Shipment('SH-2024-002', 'NL987654321', 'HuisTuinDesign', 'PostNL', 'Out for Delivery', 'PostNL Depot Rotterdam'),
    Shipment('SH-2024-003', 'IZ999AA1234567890', 'Anydaydirect', 'UPS', 'Delivered', 'Delivered'),
    Shipment('SH-2024-004', 'FX456789123', 'Ghostek Partial Outbound', 'FedEx', 'Exception', 'FedEx Hub Paris'),
    Shipment('SH-2024-005', 'TNT789123456', 'TechStore Premium', 'TNT', 'Processing', 'TNT Hub Amsterdam'),
    Shipment('SH-2024-006', 'DP123456789DE', 'Digital Solutions', 'DPD', 'Pending Pickup', 'Main Warehouse'),
  ];

  @override
  void initState() {
    super.initState();
    _shipmentDataSource = ShipmentDataSource(shipments: _shipments);
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
              'Shipments',
              style: TextStyle(
                fontSize: isDesktop ? 28 : 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Track shipments and delivery status - Monitor ${_shipments.length} active shipments across multiple carriers',
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
        _ActionButton(label: 'Ask AI for Tracking Insights', onTap: () {}, isPrimary: true),
        const SizedBox(width: 16),
        // Theme toggle
        _IconActionButton(icon: Icons.dark_mode_outlined, onTap: () {}),
        const SizedBox(width: 8),
        // Fullscreen toggle
        _IconActionButton(icon: Icons.fullscreen, onTap: () {}),
      ],
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
            height: 500,
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
                source: _shipmentDataSource,
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
                  // Shipment ID column
                  GridColumn(
                    columnName: 'shipmentId',
                    label: _buildColumnHeader('Shipment ID'),
                  ),
                  // Tracking # column
                  GridColumn(
                    columnName: 'trackingNumber',
                    label: _buildColumnHeader('Tracking #'),
                  ),
                  // Customer column
                  GridColumn(
                    columnName: 'customer',
                    label: _buildColumnHeader('Customer'),
                  ),
                  // Carrier column
                  GridColumn(
                    columnName: 'carrier',
                    label: _buildColumnHeader('Carrier'),
                  ),
                  // Status column
                  GridColumn(
                    columnName: 'status',
                    label: _buildColumnHeader('Status'),
                  ),
                  // Current Location column
                  GridColumn(
                    columnName: 'currentLocation',
                    label: _buildColumnHeader('Current Location'),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white.withOpacity(0.9),
        ),
      ),
    );
  }
}

// Data model
class Shipment {
  final String shipmentId;
  final String trackingNumber;
  final String customer;
  final String carrier;
  final String status;
  final String currentLocation;

  Shipment(this.shipmentId, this.trackingNumber, this.customer, this.carrier, this.status, this.currentLocation);
}

// Syncfusion DataSource
class ShipmentDataSource extends DataGridSource {
  ShipmentDataSource({required List<Shipment> shipments}) {
    _shipments = shipments.map<DataGridRow>((shipment) {
      return DataGridRow(cells: [
        const DataGridCell<Widget>(columnName: 'expand', value: null),
        DataGridCell<String>(columnName: 'shipmentId', value: shipment.shipmentId),
        DataGridCell<String>(columnName: 'trackingNumber', value: shipment.trackingNumber),
        DataGridCell<String>(columnName: 'customer', value: shipment.customer),
        DataGridCell<String>(columnName: 'carrier', value: shipment.carrier),
        DataGridCell<String>(columnName: 'status', value: shipment.status),
        DataGridCell<String>(columnName: 'currentLocation', value: shipment.currentLocation),
      ]);
    }).toList();
  }

  List<DataGridRow> _shipments = [];

  @override
  List<DataGridRow> get rows => _shipments;

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

        // Status column with color coding
        if (cell.columnName == 'status') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              cell.value?.toString() ?? '',
              style: TextStyle(
                fontSize: 14,
                color: _getStatusColor(cell.value?.toString() ?? ''),
              ),
            ),
          );
        }

        // Current Location column with color for "Delivered"
        if (cell.columnName == 'currentLocation') {
          final isDelivered = cell.value?.toString() == 'Delivered';
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            alignment: Alignment.centerLeft,
            child: Text(
              cell.value?.toString() ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isDelivered ? const Color(0xFF22C55E) : Colors.white.withOpacity(0.85),
              ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'In Transit':
        return const Color(0xFFFBBF24); // amber
      case 'Out for Delivery':
        return const Color(0xFFFBBF24); // amber
      case 'Delivered':
        return const Color(0xFF22C55E); // green
      case 'Exception':
        return const Color(0xFFEF4444); // red
      case 'Processing':
        return const Color(0xFFFBBF24); // amber
      case 'Pending Pickup':
        return const Color(0xFFFBBF24); // amber
      default:
        return Colors.white.withOpacity(0.85);
    }
  }
}

// UI Components
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
