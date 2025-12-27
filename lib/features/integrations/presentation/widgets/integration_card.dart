import 'package:flutter/material.dart';
import '../../data/models/integration_models.dart';

class IntegrationCard extends StatefulWidget {
  final Integration app;
  final VoidCallback onTap;
  final VoidCallback onConnect;

  const IntegrationCard({
    super.key,
    required this.app,
    required this.onTap,
    required this.onConnect,
  });

  @override
  State<IntegrationCard> createState() => _IntegrationCardState();
}

class _IntegrationCardState extends State<IntegrationCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: _isHovered
            ? (Matrix4.identity()..translate(0.0, -5.0)..scale(1.02))
            : Matrix4.identity(),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF000000), Color(0xFF1A1A1A)],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.8),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Icon + Badges
                _buildHeader(),
                const SizedBox(height: 16),
                // App Name
                Text(
                  widget.app.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  widget.app.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                // Rating
                _buildRating(),
                const SizedBox(height: 16),
                // Footer: Category + Pricing + Button
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.app.icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // Badges - flexible to wrap if needed
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (widget.app.connected)
                _buildBadge(
                  'Connected',
                  Icons.check_circle,
                  const Color(0xFF22C55E),
                )
              else if (widget.app.featured)
                _buildBadge(
                  'Featured',
                  Icons.star,
                  Colors.white.withOpacity(0.6),
                  isDefault: true,
                ),
              if (widget.app.verified)
                _buildBadge(
                  'Verified',
                  Icons.shield,
                  widget.app.connected
                      ? Colors.white.withOpacity(0.6)
                      : const Color(0xFF22C55E),
                  isDefault: !widget.app.connected,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color, {bool isDefault = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDefault
            ? Colors.white.withOpacity(0.05)
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDefault
              ? Colors.white.withOpacity(0.1)
              : color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: isDefault ? Colors.white : color),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDefault ? Colors.white : color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final isFilled = index < widget.app.rating.floor();
            return Icon(
              Icons.star,
              size: 16,
              color: isFilled ? const Color(0xFFFACC15) : Colors.grey[700],
            );
          }),
        ),
        Text(
          '${widget.app.rating} (${_formatNumber(widget.app.reviews)} reviews)',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: [
        // Category + Pricing badges
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSmallBadge(widget.app.category),
            _buildSmallBadge(
              widget.app.pricing,
              color: widget.app.pricing == 'Free'
                  ? const Color(0xFF22C55E)
                  : const Color(0xFFFBBF24),
            ),
          ],
        ),
        // Action Button
        widget.app.connected ? _buildManageButton() : _buildConnectButton(),
      ],
    );
  }

  Widget _buildSmallBadge(String label, {Color? color}) {
    final badgeColor = color ?? Colors.white;
    final isColored = color != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isColored ? badgeColor.withOpacity(0.1) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isColored ? badgeColor.withOpacity(0.3) : Colors.white.withOpacity(0.1),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isColored ? badgeColor : Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }

  Widget _buildManageButton() {
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
            // TODO: Manage integration
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              'Manage',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onConnect,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Text(
              'Connect',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
