import 'package:flutter/material.dart';

/// Integration model matching Next.js interface
class Integration {
  final int id;
  final String name;
  final String description;
  final IconData icon;
  final String? iconAsset; // For brand icons (Shopify, etc.)
  final String category;
  final double rating;
  final int reviews;
  final String pricing;
  final bool connected;
  final bool verified;
  final bool featured;
  final String? lastSync;

  const Integration({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.iconAsset,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.pricing,
    this.connected = false,
    this.verified = false,
    this.featured = false,
    this.lastSync,
  });
}

/// Coming Soon app model
class ComingSoonApp {
  final String name;
  final String description;
  final IconData icon;
  final String category;

  const ComingSoonApp({
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
  });
}

/// Category model for filtering
class IntegrationCategory {
  final String id;
  final String name;
  final int count;
  final IconData? icon;
  final List<Color>? gradientColors;

  const IntegrationCategory({
    required this.id,
    required this.name,
    required this.count,
    this.icon,
    this.gradientColors,
  });
}

/// Connection result from API
class ConnectionResult {
  final bool success;
  final String message;
  final String? errorDetails;
  final String? errorType;
  final bool? credentialsSaved;
  final String? integrationId;

  const ConnectionResult({
    required this.success,
    required this.message,
    this.errorDetails,
    this.errorType,
    this.credentialsSaved,
    this.integrationId,
  });
}

/// ChannelDock sync settings
class ChannelDockSyncSettings {
  bool autoSync;
  int syncIntervalMinutes;
  bool syncCustomers;
  bool syncProducts;
  bool syncOrders;
  bool syncShipments;
  bool syncReturns;
  int batchSize;

  ChannelDockSyncSettings({
    this.autoSync = true,
    this.syncIntervalMinutes = 15,
    this.syncCustomers = true,
    this.syncProducts = true,
    this.syncOrders = true,
    this.syncShipments = true,
    this.syncReturns = true,
    this.batchSize = 50,
  });
}

/// QuickBooks sync settings
class QuickBooksSyncSettings {
  bool autoSync;
  int syncIntervalMinutes;
  bool initialImportCustomers;
  bool initialImportInvoices;
  bool initialImportPayments;
  bool initialImportTransactions;
  bool syncCustomers;
  bool syncInvoices;
  bool syncPayments;
  bool syncTransactions;
  String dateRange;
  int batchSize;

  QuickBooksSyncSettings({
    this.autoSync = true,
    this.syncIntervalMinutes = 30,
    this.initialImportCustomers = true,
    this.initialImportInvoices = true,
    this.initialImportPayments = true,
    this.initialImportTransactions = false,
    this.syncCustomers = true,
    this.syncInvoices = true,
    this.syncPayments = true,
    this.syncTransactions = false,
    this.dateRange = 'last_12_months',
    this.batchSize = 100,
  });
}
