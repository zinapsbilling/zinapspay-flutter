import 'package:flutter/material.dart';
import '../../data/models/integration_models.dart';

class AppDetailModal extends StatelessWidget {
  final Integration app;
  final VoidCallback onClose;
  final VoidCallback onConnect;

  const AppDetailModal({
    super.key,
    required this.app,
    required this.onClose,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.8),
      child: Stack(
        children: [
          // Backdrop - closes modal on tap
          GestureDetector(
            onTap: onClose,
            child: Container(color: Colors.transparent),
          ),
          // Modal Content
          Center(
            child: Container(
              width: 900,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.9,
              ),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(),
                  Flexible(
                    child: SingleChildScrollView(
                      child: _buildContent(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              app.icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  app.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  app.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Close Button
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: Colors.white.withOpacity(0.6),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Description & Features
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescriptionSection(),
                const SizedBox(height: 32),
                _buildFeaturesSection(),
              ],
            ),
          ),
          const SizedBox(width: 32),
          // Right Column - Action Card & Permissions
          SizedBox(
            width: 280,
            child: Column(
              children: [
                _buildActionCard(),
                const SizedBox(height: 24),
                _buildPermissionsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Connect your ${app.name} to ZinapsPay for seamless order and inventory management. '
          'This integration automatically syncs new orders, updates inventory levels, and manages '
          'customer data across both platforms. Perfect for businesses looking to streamline their '
          'fulfillment operations and reduce manual data entry.',
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    final features = [
      'Real-time order synchronization',
      'Automatic inventory updates',
      'Customer data synchronization',
      'Multi-location support',
      'Webhook-based notifications',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.check,
                    color: Color(0xFF22C55E),
                    size: 18,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    feature,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildActionCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star,
                    color: Color(0xFFFACC15),
                    size: 16,
                  );
                }),
              ),
              Text(
                '${app.rating}/5',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_formatNumber(app.reviews)} reviews • 15,000+ installs',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          // Connect Button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onConnect,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      'Connect to ${app.name}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Details
          _buildDetailRow('Pricing:', app.pricing),
          const SizedBox(height: 8),
          _buildDetailRow('Setup time:', '5 minutes'),
          const SizedBox(height: 8),
          _buildDetailRow('Support:', '24/7'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsCard() {
    final permissions = [
      {'icon': Icons.visibility, 'label': 'Read orders'},
      {'icon': Icons.edit, 'label': 'Update inventory'},
      {'icon': Icons.group, 'label': 'Access customer data'},
      {'icon': Icons.notifications, 'label': 'Receive webhooks'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F0F0F), Color(0xFF1A1A1A)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Permissions Required',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          ...permissions.map((perm) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      perm['icon'] as IconData,
                      color: Colors.white.withOpacity(0.5),
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      perm['label'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
