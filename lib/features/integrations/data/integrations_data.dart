import 'package:flutter/material.dart';
import 'models/integration_models.dart';

/// Categories for filtering - matching Next.js exactly
final List<IntegrationCategory> categories = [
  const IntegrationCategory(id: 'all', name: 'All Categories', count: 247),
  const IntegrationCategory(id: 'marketplaces', name: 'Marketplaces', count: 89),
  const IntegrationCategory(id: 'wms', name: 'WMS', count: 42),
  const IntegrationCategory(id: 'accounting', name: 'Accounting', count: 28),
  const IntegrationCategory(id: 'carriers', name: 'Carriers', count: 35),
  const IntegrationCategory(id: 'analytics', name: 'Analytics', count: 23),
  const IntegrationCategory(id: 'payment', name: 'Payment', count: 18),
  const IntegrationCategory(id: 'crm', name: 'CRM', count: 12),
];

/// Browse by category cards with gradients
final List<IntegrationCategory> browseCategories = [
  IntegrationCategory(
    id: 'marketplaces',
    name: 'Marketplaces',
    count: 89,
    icon: Icons.store,
    gradientColors: [Colors.purple.withOpacity(0.2), Colors.blue.withOpacity(0.2)],
  ),
  IntegrationCategory(
    id: 'wms',
    name: 'WMS',
    count: 42,
    icon: Icons.warehouse,
    gradientColors: [Colors.green.withOpacity(0.2), Colors.teal.withOpacity(0.2)],
  ),
  IntegrationCategory(
    id: 'accounting',
    name: 'Accounting',
    count: 28,
    icon: Icons.calculate,
    gradientColors: [Colors.yellow.withOpacity(0.2), Colors.orange.withOpacity(0.2)],
  ),
  IntegrationCategory(
    id: 'carriers',
    name: 'Carriers',
    count: 35,
    icon: Icons.local_shipping,
    gradientColors: [Colors.red.withOpacity(0.2), Colors.pink.withOpacity(0.2)],
  ),
  IntegrationCategory(
    id: 'analytics',
    name: 'Analytics',
    count: 23,
    icon: Icons.show_chart,
    gradientColors: [Colors.indigo.withOpacity(0.2), Colors.cyan.withOpacity(0.2)],
  ),
];

/// Featured apps - matching Next.js exactly
final List<Integration> featuredApps = [
  const Integration(
    id: 1,
    name: 'Shopify',
    description: 'Sync orders, inventory, and customer data seamlessly',
    icon: Icons.shopping_bag, // Placeholder - use asset for brand
    iconAsset: 'shopify',
    category: 'Marketplace',
    rating: 4.9,
    reviews: 2847,
    pricing: 'Free',
    connected: false,
    featured: true,
    verified: true,
  ),
  const Integration(
    id: 2,
    name: 'WooCommerce',
    description: 'Complete WordPress ecommerce integration',
    icon: Icons.wordpress, // Placeholder - use asset for brand
    iconAsset: 'woocommerce',
    category: 'Marketplace',
    rating: 4.8,
    reviews: 1923,
    pricing: 'Free',
    connected: false,
    featured: true,
    verified: true,
  ),
  const Integration(
    id: 3,
    name: 'Amazon Seller Central',
    description: 'Manage Amazon orders and inventory efficiently',
    icon: Icons.shopping_cart, // Placeholder - use asset for brand
    iconAsset: 'amazon',
    category: 'Marketplace',
    rating: 4.7,
    reviews: 3156,
    pricing: 'Paid',
    connected: false,
    featured: true,
    verified: true,
  ),
];

/// Available apps - matching Next.js exactly
final List<Integration> availableApps = [
  const Integration(
    id: 4,
    name: 'ChannelDock',
    description: 'Multi-channel inventory and order management',
    icon: Icons.anchor,
    category: 'WMS',
    rating: 4.6,
    reviews: 892,
    pricing: 'Paid',
    connected: true,
    verified: true,
    lastSync: '2 min ago',
  ),
  const Integration(
    id: 5,
    name: 'MoneyBird',
    description: 'Automated accounting and invoice management',
    icon: Icons.flutter_dash, // Dove equivalent
    category: 'Accounting',
    rating: 4.5,
    reviews: 567,
    pricing: 'Free',
    connected: true,
    verified: true,
    lastSync: '5 min ago',
  ),
  const Integration(
    id: 6,
    name: 'QuickBooks',
    description: 'Import customers, invoices, and payments from QuickBooks',
    icon: Icons.calculate,
    category: 'Accounting',
    rating: 4.8,
    reviews: 3421,
    pricing: 'Free',
    connected: false,
    verified: true,
  ),
  const Integration(
    id: 7,
    name: 'Magento Commerce',
    description: 'Enterprise ecommerce platform integration',
    icon: Icons.shopping_cart,
    category: 'Marketplace',
    rating: 4.2,
    reviews: 1234,
    pricing: 'Paid',
    connected: false,
    verified: true,
  ),
];

/// Coming soon apps - matching Next.js exactly
final List<ComingSoonApp> comingSoonApps = [
  const ComingSoonApp(
    name: 'Etsy',
    description: 'Handmade marketplace integration',
    icon: Icons.store,
    category: 'Marketplace',
  ),
  const ComingSoonApp(
    name: 'Zalando',
    description: 'European fashion marketplace',
    icon: Icons.store,
    category: 'Marketplace',
  ),
  const ComingSoonApp(
    name: 'Bol.com',
    description: 'Netherlands marketplace leader',
    icon: Icons.store,
    category: 'Marketplace',
  ),
  const ComingSoonApp(
    name: 'DHL',
    description: 'Global shipping and logistics',
    icon: Icons.local_shipping,
    category: 'Carrier',
  ),
  const ComingSoonApp(
    name: 'PostNL',
    description: 'Netherlands postal service',
    icon: Icons.mail,
    category: 'Carrier',
  ),
  const ComingSoonApp(
    name: 'QLS',
    description: 'Quick logistics solutions',
    icon: Icons.local_shipping,
    category: 'Carrier',
  ),
  const ComingSoonApp(
    name: 'QuickCargo',
    description: 'Express cargo services',
    icon: Icons.inventory_2,
    category: 'Carrier',
  ),
];

/// Sync frequency options for dropdowns
final List<Map<String, dynamic>> syncFrequencyOptions = [
  {'value': 15, 'label': 'Every 15 minutes'},
  {'value': 30, 'label': 'Every 30 minutes'},
  {'value': 60, 'label': 'Every hour'},
  {'value': 240, 'label': 'Every 4 hours'},
  {'value': 480, 'label': 'Every 8 hours'},
  {'value': 1440, 'label': 'Daily'},
];

/// QuickBooks sync frequency options
final List<Map<String, dynamic>> quickBooksSyncFrequencyOptions = [
  {'value': 30, 'label': 'Every 30 minutes'},
  {'value': 60, 'label': 'Every hour'},
  {'value': 240, 'label': 'Every 4 hours'},
  {'value': 480, 'label': 'Every 8 hours'},
  {'value': 1440, 'label': 'Daily'},
];

/// Date range options for QuickBooks
final List<Map<String, String>> dateRangeOptions = [
  {'value': 'last_30_days', 'label': 'Last 30 days'},
  {'value': 'last_12_months', 'label': 'Last 12 months (recommended)'},
  {'value': 'all_time', 'label': 'All time'},
];

/// Batch size options
final List<Map<String, dynamic>> batchSizeOptions = [
  {'value': 50, 'label': '50 records per request'},
  {'value': 100, 'label': '100 records per request (recommended)'},
  {'value': 250, 'label': '250 records per request'},
  {'value': 500, 'label': '500 records per request'},
];
