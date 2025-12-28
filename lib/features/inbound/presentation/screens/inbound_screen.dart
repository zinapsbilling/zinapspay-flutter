import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

/// Inbound Management Screen
/// Matches the design with:
/// - Stats cards row (Total Shipments, Total Boxes, Total Pallets, Stocked Items)
/// - Syncfusion DataGrid with columns (Inbound ID, Seller, Contact, Status, Boxes, Pallets, Time tracking)
/// - Header actions (Sync with WMS, Export Data, Ask AI for Insights, theme toggle, fullscreen)
/// - Time Tracking modal with WORKING session management and live timer

/// Time tracking session model
class TimeTrackingSession {
  TimeTrackingSession({
    required this.id,
    required this.date,
    required this.startTime,
    this.endTime,
    this.isActive = false,
  });

  final String id;
  final DateTime date;
  final DateTime startTime;
  DateTime? endTime;
  bool isActive;

  Duration get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  TimeTrackingSession copyWith({
    String? id,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? isActive,
  }) {
    return TimeTrackingSession(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Inbound data model
class InboundData {
  InboundData({
    required this.inboundId,
    required this.seller,
    required this.contact,
    required this.status,
    required this.boxes,
    required this.pallets,
    List<TimeTrackingSession>? timeTrackingSessions,
  }) : timeTrackingSessions = timeTrackingSessions ?? [];

  final String inboundId;
  final String seller;
  final String contact;
  final String status;
  final int boxes;
  final int pallets;
  final List<TimeTrackingSession> timeTrackingSessions;

  bool get hasActiveSession => timeTrackingSessions.any((s) => s.isActive);

  Duration get totalDuration {
    return timeTrackingSessions.fold<Duration>(
      Duration.zero,
      (sum, session) => sum + session.duration,
    );
  }
}

/// Provider for inbound data with time tracking state
final inboundDataProvider = StateNotifierProvider<InboundDataNotifier, List<InboundData>>((ref) {
  return InboundDataNotifier();
});

class InboundDataNotifier extends StateNotifier<List<InboundData>> {
  InboundDataNotifier() : super([
    InboundData(
      inboundId: '1001',
      seller: 'TechCorp Inc',
      contact: 'John Doe',
      status: 'Processing',
      boxes: 5,
      pallets: 1,
      timeTrackingSessions: [],
    ),
  ]);

  void startTimer(String inboundId) {
    state = state.map((inbound) {
      if (inbound.inboundId == inboundId) {
        // Stop any currently active session first
        final updatedSessions = inbound.timeTrackingSessions.map((s) {
          if (s.isActive) {
            return s.copyWith(endTime: DateTime.now(), isActive: false);
          }
          return s;
        }).toList();

        // Add new active session
        updatedSessions.add(TimeTrackingSession(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: DateTime.now(),
          startTime: DateTime.now(),
          isActive: true,
        ));

        return InboundData(
          inboundId: inbound.inboundId,
          seller: inbound.seller,
          contact: inbound.contact,
          status: inbound.status,
          boxes: inbound.boxes,
          pallets: inbound.pallets,
          timeTrackingSessions: updatedSessions,
        );
      }
      return inbound;
    }).toList();
  }

  void stopTimer(String inboundId) {
    state = state.map((inbound) {
      if (inbound.inboundId == inboundId) {
        final updatedSessions = inbound.timeTrackingSessions.map((s) {
          if (s.isActive) {
            return s.copyWith(endTime: DateTime.now(), isActive: false);
          }
          return s;
        }).toList();

        return InboundData(
          inboundId: inbound.inboundId,
          seller: inbound.seller,
          contact: inbound.contact,
          status: inbound.status,
          boxes: inbound.boxes,
          pallets: inbound.pallets,
          timeTrackingSessions: updatedSessions,
        );
      }
      return inbound;
    }).toList();
  }

  void addManualSession(String inboundId, DateTime startTime, DateTime endTime) {
    state = state.map((inbound) {
      if (inbound.inboundId == inboundId) {
        final updatedSessions = List<TimeTrackingSession>.from(inbound.timeTrackingSessions);
        updatedSessions.add(TimeTrackingSession(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          date: startTime,
          startTime: startTime,
          endTime: endTime,
          isActive: false,
        ));

        return InboundData(
          inboundId: inbound.inboundId,
          seller: inbound.seller,
          contact: inbound.contact,
          status: inbound.status,
          boxes: inbound.boxes,
          pallets: inbound.pallets,
          timeTrackingSessions: updatedSessions,
        );
      }
      return inbound;
    }).toList();
  }

  void deleteSession(String inboundId, String sessionId) {
    state = state.map((inbound) {
      if (inbound.inboundId == inboundId) {
        final updatedSessions = inbound.timeTrackingSessions
            .where((s) => s.id != sessionId)
            .toList();

        return InboundData(
          inboundId: inbound.inboundId,
          seller: inbound.seller,
          contact: inbound.contact,
          status: inbound.status,
          boxes: inbound.boxes,
          pallets: inbound.pallets,
          timeTrackingSessions: updatedSessions,
        );
      }
      return inbound;
    }).toList();
  }

  void clearSessions(String inboundId) {
    state = state.map((inbound) {
      if (inbound.inboundId == inboundId) {
        return InboundData(
          inboundId: inbound.inboundId,
          seller: inbound.seller,
          contact: inbound.contact,
          status: inbound.status,
          boxes: inbound.boxes,
          pallets: inbound.pallets,
          timeTrackingSessions: [],
        );
      }
      return inbound;
    }).toList();
  }

  // Force refresh to update timer display
  void refresh() {
    state = [...state];
  }
}

class InboundScreen extends ConsumerStatefulWidget {
  const InboundScreen({super.key});

  @override
  ConsumerState<InboundScreen> createState() => _InboundScreenState();
}

class _InboundScreenState extends ConsumerState<InboundScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh every second to update active timers
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        ref.read(inboundDataProvider.notifier).refresh();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _showTimeTrackingModal(InboundData inbound) {
    showDialog(
      context: context,
      builder: (context) => TimeTrackingModal(inbound: inbound),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inbounds = ref.watch(inboundDataProvider);

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
                  _buildStatsCards(inbounds),
                  const SizedBox(height: 24),
                  // Data grid section
                  _buildDataGridSection(inbounds),
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
                // Truck icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_shipping,
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
                        'Inbound Management',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Track and manage incoming shipments - 1 shipments loaded',
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
          // Action buttons
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildActionButton(Icons.sync, 'Sync with WMS'),
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

  Widget _buildStatsCards(List<InboundData> inbounds) {
    final totalBoxes = inbounds.fold<int>(0, (sum, i) => sum + i.boxes);
    final totalPallets = inbounds.fold<int>(0, (sum, i) => sum + i.pallets);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Shipments',
            '${inbounds.length}',
            'Active records',
            null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Boxes',
            '$totalBoxes',
            'Across all shipments',
            null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Total Pallets',
            '$totalPallets',
            'In warehouse',
            null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Stocked Items',
            '0',
            'Processed',
            Colors.green,
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              if (subtitleColor == Colors.green)
                Icon(
                  Icons.check_box,
                  color: subtitleColor,
                  size: 14,
                ),
              if (subtitleColor == Colors.green)
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

  Widget _buildDataGridSection(List<InboundData> inbounds) {
    final dataSource = InboundDataSource(
      inbounds: inbounds,
      onTimeTrackingTap: _showTimeTrackingModal,
      onStartTimer: (inboundId) => ref.read(inboundDataProvider.notifier).startTimer(inboundId),
      onStopTimer: (inboundId) => ref.read(inboundDataProvider.notifier).stopTimer(inboundId),
    );

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
                source: dataSource,
                columnWidthMode: ColumnWidthMode.none,
                horizontalScrollPhysics: const ClampingScrollPhysics(),
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
                  // Inbound ID column
                  GridColumn(
                    columnName: 'inboundId',
                    minimumWidth: 120,
                    label: _buildColumnHeader('Inbound ID'),
                  ),
                  // Seller column
                  GridColumn(
                    columnName: 'seller',
                    minimumWidth: 120,
                    label: _buildColumnHeader('Seller'),
                  ),
                  // Contact column
                  GridColumn(
                    columnName: 'contact',
                    minimumWidth: 100,
                    label: _buildColumnHeader('Contact'),
                  ),
                  // Status column
                  GridColumn(
                    columnName: 'status',
                    minimumWidth: 100,
                    label: _buildColumnHeader('Status'),
                  ),
                  // Boxes column
                  GridColumn(
                    columnName: 'boxes',
                    minimumWidth: 80,
                    label: _buildColumnHeader('Boxes'),
                  ),
                  // Pallets column
                  GridColumn(
                    columnName: 'pallets',
                    minimumWidth: 80,
                    label: _buildColumnHeader('Pallets'),
                  ),
                  // Time tracking column
                  GridColumn(
                    columnName: 'timeTracking',
                    minimumWidth: 180,
                    label: _buildColumnHeader('Time tracking'),
                    allowSorting: false,
                    allowFiltering: false,
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

/// Data source for Inbound DataGrid
class InboundDataSource extends DataGridSource {
  final List<InboundData> inbounds;
  final Function(InboundData) onTimeTrackingTap;
  final Function(String) onStartTimer;
  final Function(String) onStopTimer;

  InboundDataSource({
    required this.inbounds,
    required this.onTimeTrackingTap,
    required this.onStartTimer,
    required this.onStopTimer,
  }) {
    buildDataGridRows();
  }

  List<DataGridRow> _dataGridRows = [];

  void buildDataGridRows() {
    _dataGridRows = inbounds.map<DataGridRow>((inbound) {
      return DataGridRow(cells: [
        const DataGridCell<Widget>(columnName: 'expand', value: null),
        DataGridCell<String>(columnName: 'inboundId', value: inbound.inboundId),
        DataGridCell<String>(columnName: 'seller', value: inbound.seller),
        DataGridCell<String>(columnName: 'contact', value: inbound.contact),
        DataGridCell<String>(columnName: 'status', value: inbound.status),
        DataGridCell<int>(columnName: 'boxes', value: inbound.boxes),
        DataGridCell<int>(columnName: 'pallets', value: inbound.pallets),
        DataGridCell<InboundData>(columnName: 'timeTracking', value: inbound),
      ]);
    }).toList();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
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
        if (cell.columnName == 'timeTracking') {
          final inbound = cell.value as InboundData;
          final isActive = inbound.hasActiveSession;
          final totalDuration = inbound.totalDuration;

          return Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Play/Stop button
                GestureDetector(
                  onTap: () {
                    if (isActive) {
                      onStopTimer(inbound.inboundId);
                    } else {
                      onStartTimer(inbound.inboundId);
                    }
                  },
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.red : Colors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      isActive ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Timer display - clickable to open modal
                Expanded(
                  child: GestureDetector(
                    onTap: () => onTimeTrackingTap(inbound),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green.withOpacity(0.1) : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(totalDuration),
                          style: TextStyle(
                            fontSize: 14,
                            color: isActive ? Colors.green : Colors.white.withOpacity(0.8),
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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

/// Time Tracking Modal with WORKING timer
/// Shows compact view first with option to expand to full calendar
class TimeTrackingModal extends ConsumerStatefulWidget {
  final InboundData inbound;

  const TimeTrackingModal({super.key, required this.inbound});

  @override
  ConsumerState<TimeTrackingModal> createState() => _TimeTrackingModalState();
}

class _TimeTrackingModalState extends ConsumerState<TimeTrackingModal> {
  Timer? _refreshTimer;
  bool _showFullCalendar = false;

  @override
  void initState() {
    super.initState();
    // Refresh every second to update active timer display
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String _formatShortDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  String _formatDurationPreview(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    final diffMinutes = endMinutes - startMinutes;

    if (diffMinutes <= 0) return '0h 0m 0s';

    final hours = diffMinutes ~/ 60;
    final minutes = diffMinutes % 60;
    return '${hours}h ${minutes}m 0s';
  }

  String _format24Hour(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showAddSessionDialog() {
    // Default to 1 hour session ending now
    final now = TimeOfDay.now();
    TimeOfDay startTime = TimeOfDay(hour: (now.hour - 1).clamp(0, 23), minute: now.minute);
    TimeOfDay endTime = now;
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppColors.border.withOpacity(0.3)),
          ),
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: AppColors.foreground,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Inter',
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Month display
                Center(
                  child: Text(
                    DateFormat('MMMM yyyy').format(selectedDate),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: AppColors.foreground,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Show full calendar link
                const Center(
                  child: Text(
                    'Click "Show full calendar" to select a\ndifferent date',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Inter',
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: AppColors.info,
                                surface: AppColors.card,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
                      }
                    },
                    child: const Text(
                      'Show full calendar',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Inter',
                        color: AppColors.info,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.info,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Time pickers row
                Row(
                  children: [
                    // Start time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start at',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Inter',
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: startTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: AppColors.info,
                                        surface: AppColors.card,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setDialogState(() => startTime = time);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColors.mutedForeground,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _format24Hour(startTime),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      color: AppColors.foreground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.mutedForeground,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // End time
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'End at',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Inter',
                              color: AppColors.mutedForeground,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: endTime,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: AppColors.info,
                                        surface: AppColors.card,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (time != null) {
                                setDialogState(() => endTime = time);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    color: AppColors.mutedForeground,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _format24Hour(endTime),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      color: AppColors.foreground,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.mutedForeground,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Duration preview
                Center(
                  child: Column(
                    children: [
                      Text(
                        _formatDurationPreview(startTime, endTime),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Inter',
                          color: AppColors.foreground,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Duration',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          color: AppColors.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Add session button
                GestureDetector(
                  onTap: () {
                    final startDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      startTime.hour,
                      startTime.minute,
                    );
                    final endDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      endTime.hour,
                      endTime.minute,
                    );

                    if (endDateTime.isAfter(startDateTime)) {
                      ref.read(inboundDataProvider.notifier).addManualSession(
                        widget.inbound.inboundId,
                        startDateTime,
                        endDateTime,
                      );
                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('End time must be after start time'),
                          backgroundColor: AppColors.destructive,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border.withOpacity(0.3)),
                    ),
                    child: const Center(
                      child: Text(
                        'Add session',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          color: AppColors.foreground,
                        ),
                      ),
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
  Widget build(BuildContext context) {
    // Get fresh data from provider
    final inbounds = ref.watch(inboundDataProvider);
    final currentInbound = inbounds.firstWhere(
      (i) => i.inboundId == widget.inbound.inboundId,
      orElse: () => widget.inbound,
    );
    final sessions = currentInbound.timeTrackingSessions;
    final isActive = currentInbound.hasActiveSession;
    final totalDuration = currentInbound.totalDuration;

    // If compact view (default)
    if (!_showFullCalendar) {
      return _buildCompactView(currentInbound, sessions, isActive, totalDuration);
    }

    // Full calendar view
    return _buildFullCalendarView(currentInbound, sessions, isActive, totalDuration);
  }

  /// Compact view - shows timer controls, total time, and expand button
  Widget _buildCompactView(InboundData inbound, List<TimeTrackingSession> sessions, bool isActive, Duration totalDuration) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Time Tracking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.foreground,
                    fontFamily: 'Inter',
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.mutedForeground,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Timer display with controls
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive ? AppColors.success.withOpacity(0.3) : AppColors.border.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  // Timer value
                  Text(
                    _formatShortDuration(totalDuration),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isActive ? AppColors.success : AppColors.foreground,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? 'Running' : 'Stopped',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: isActive ? AppColors.success.withOpacity(0.8) : AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Control buttons row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Start/Stop button
                      GestureDetector(
                        onTap: () {
                          if (isActive) {
                            ref.read(inboundDataProvider.notifier).stopTimer(widget.inbound.inboundId);
                          } else {
                            ref.read(inboundDataProvider.notifier).startTimer(widget.inbound.inboundId);
                          }
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.destructive : AppColors.info,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: (isActive ? AppColors.destructive : AppColors.info).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            isActive ? Icons.stop : Icons.play_arrow,
                            color: AppColors.foreground,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sessions count and show full calendar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sessions.length} session${sessions.length != 1 ? 's' : ''} recorded',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: AppColors.mutedForeground,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showFullCalendar = true),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: AppColors.info,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Show full calendar',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          color: AppColors.info,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Quick action buttons
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _showAddSessionDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.border.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: AppColors.mutedForeground,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Add manually',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Inter',
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Full calendar view with all sessions - clean design matching compact view
  Widget _buildFullCalendarView(InboundData inbound, List<TimeTrackingSession> sessions, bool isActive, Duration totalDuration) {
    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border.withOpacity(0.3)),
      ),
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header - clean style
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _showFullCalendar = false),
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.mutedForeground,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Time Tracking',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.foreground,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.mutedForeground,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Timer display - same style as compact view
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.secondary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isActive ? AppColors.success.withOpacity(0.3) : AppColors.border.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _formatShortDuration(totalDuration),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                      color: isActive ? AppColors.success : AppColors.foreground,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isActive ? 'Running' : 'Stopped',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Inter',
                      color: isActive ? AppColors.success.withOpacity(0.8) : AppColors.mutedForeground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      if (isActive) {
                        ref.read(inboundDataProvider.notifier).stopTimer(widget.inbound.inboundId);
                      } else {
                        ref.read(inboundDataProvider.notifier).startTimer(widget.inbound.inboundId);
                      }
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.destructive : AppColors.info,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: (isActive ? AppColors.destructive : AppColors.info).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        isActive ? Icons.stop : Icons.play_arrow,
                        color: AppColors.foreground,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Sessions header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${sessions.length} session${sessions.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: AppColors.mutedForeground,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ref.read(inboundDataProvider.notifier).clearSessions(widget.inbound.inboundId);
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          color: AppColors.destructive,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // TODO: Export to Excel
                      },
                      child: const Text(
                        'Export',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Sessions list - compact style
            if (sessions.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: const Center(
                  child: Text(
                    'No sessions yet',
                    style: TextStyle(
                      color: AppColors.mutedForeground,
                      fontFamily: 'Inter',
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[sessions.length - 1 - index];
                    return _buildCleanSessionItem(session, inbound.inboundId);
                  },
                ),
              ),
            const SizedBox(height: 16),

            // Add manually button - clean style
            GestureDetector(
              onTap: _showAddSessionDialog,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.border.withOpacity(0.3),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: AppColors.mutedForeground,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Add manually',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Inter',
                        color: AppColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Clean session item for full calendar view
  Widget _buildCleanSessionItem(TimeTrackingSession session, String inboundId) {
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: session.isActive ? AppColors.success.withOpacity(0.1) : AppColors.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Small colored dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: session.isActive ? AppColors.success : AppColors.info,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          // Date and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(session.date),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Inter',
                    color: session.isActive ? AppColors.success : AppColors.foreground,
                  ),
                ),
                Text(
                  session.isActive
                      ? '${timeFormat.format(session.startTime)} - now'
                      : '${timeFormat.format(session.startTime)} - ${timeFormat.format(session.endTime!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontFamily: 'Inter',
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          // Duration
          Text(
            _formatDuration(session.duration),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Inter',
              color: session.isActive ? AppColors.success : AppColors.foreground.withOpacity(0.7),
            ),
          ),
          // Delete button
          if (!session.isActive) ...[
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                ref.read(inboundDataProvider.notifier).deleteSession(inboundId, session.id);
              },
              child: Icon(
                Icons.delete_outline,
                color: AppColors.mutedForeground.withOpacity(0.6),
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionItem(TimeTrackingSession session, String inboundId) {
    final dateFormat = DateFormat('MMM d');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: session.isActive ? Colors.green.withOpacity(0.1) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: session.isActive
            ? Border.all(color: Colors.green.withOpacity(0.3))
            : null,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: session.isActive ? Colors.green : Colors.purple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: session.isActive
                  ? const Icon(Icons.timer, color: Colors.white, size: 20)
                  : const Text(
                      'Z',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Date and time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      dateFormat.format(session.date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    if (session.isActive) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  session.isActive
                      ? '${timeFormat.format(session.startTime)} - Running...'
                      : '${timeFormat.format(session.startTime)} - ${timeFormat.format(session.endTime!)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          // Duration badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: session.isActive ? Colors.green.withOpacity(0.2) : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: session.isActive ? Colors.green.withOpacity(0.5) : Colors.white.withOpacity(0.2),
              ),
            ),
            child: Text(
              _formatDuration(session.duration),
              style: TextStyle(
                fontSize: 12,
                color: session.isActive ? Colors.green : Colors.white,
                fontWeight: session.isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Delete button (only for completed sessions)
          if (!session.isActive)
            GestureDetector(
              onTap: () {
                ref.read(inboundDataProvider.notifier).deleteSession(inboundId, session.id);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
