import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isLoading = false;
          _emailSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send reset email: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1024;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.jetBlack, AppColors.charcoal, AppColors.jetBlack],
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingOrbs(),
            Row(
              children: [
                if (isDesktop) Expanded(child: _buildBrandingSection()),
                Expanded(child: _buildFormSection(isDesktop)),
              ],
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingOrbs() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(top: 80, left: 40, child: _orb(128, 0.05)),
          Positioned(top: 160, right: 80, child: _orb(96, 0.05)),
          Positioned(
            bottom: 128,
            left: MediaQuery.of(context).size.width * 0.25,
            child: _orb(160, 0.03),
          ),
        ],
      ),
    );
  }

  Widget _orb(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.white.withOpacity(opacity), Colors.transparent]),
      ),
    );
  }

  Widget _buildBrandingSection() {
    return Container(
      padding: const EdgeInsets.all(64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 512),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo row
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(Icons.widgets_outlined, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShaderMask(
                        shaderCallback: (b) => const LinearGradient(
                          colors: [Colors.white, AppColors.silver, Colors.white],
                        ).createShader(b),
                        child: const Text('ZinapsPay', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      Text('Enterprise Solutions', style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 48),
              // Title
              Text.rich(
                TextSpan(
                  text: 'Reset Your ',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                  children: [
                    WidgetSpan(
                      child: ShaderMask(
                        shaderCallback: (b) => const LinearGradient(colors: [Colors.white, AppColors.silver, Colors.white]).createShader(b),
                        child: const Text('Password', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text("Don't worry, it happens to the best of us. We'll help you get back into your account.", style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.6), height: 1.6), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Features - left aligned
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _featureItem(Icons.mail_outline, 'Check your email inbox'),
                  _featureItem(Icons.link, 'Click the reset link'),
                  _featureItem(Icons.lock_outline, 'Create a new password'),
                  _featureItem(Icons.check_circle_outline, 'Sign in with new password'),
                ],
              ),
              const SizedBox(height: 32),
              // Trust badges
              Container(
                padding: const EdgeInsets.only(top: 32),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
                child: Column(
                  children: [
                    Text('Your security is our priority', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _badge(Icons.lock_outline, '256-bit SSL'),
                        const SizedBox(width: 32),
                        _badge(Icons.verified_outlined, 'PCI DSS'),
                        const SizedBox(width: 32),
                        _badge(Icons.star_outline, 'SOC 2'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Center(child: Icon(icon, color: Colors.white, size: 12)),
          ),
          const SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.6), size: 16),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
      ],
    );
  }

  Widget _buildFormSection(bool isDesktop) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 32, vertical: 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mobile logo
              if (!isDesktop) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white.withOpacity(0.05),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Icon(Icons.widgets_outlined, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShaderMask(
                          shaderCallback: (b) => const LinearGradient(colors: [Colors.white, AppColors.silver, Colors.white]).createShader(b),
                          child: const Text('ZinapsPay', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                        Text('Enterprise Solutions', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
              // Form card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.jetBlack, AppColors.darkGray]),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 40, offset: const Offset(0, 20))],
                ),
                child: _emailSent ? _buildSuccessContent() : _buildFormContent(),
              ),
              const SizedBox(height: 24),
              // Security notice
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield, color: Colors.green, size: 18),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Your connection is secure', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('All data is encrypted using industry-standard SSL technology.', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Icon
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.key, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Reset Password', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text("Enter your email address and we'll send you a reset link.", style: TextStyle(color: Colors.white.withOpacity(0.6)), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          Text('Email address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
          const SizedBox(height: 4),
          _inputField(_emailController, 'Enter your email address', TextInputType.emailAddress, (v) => v == null || v.isEmpty ? 'Required' : (!v.contains('@') ? 'Invalid email' : null)),
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.2))),
                  child: TextButton(
                    onPressed: () => context.go(AppRoutes.login),
                    child: const Text('Cancel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.2))),
                  child: TextButton(
                    onPressed: _isLoading ? null : _handleResetPassword,
                    child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.send, color: Colors.white, size: 18), SizedBox(width: 8), Text('Send Link', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Remember your password? ', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: const Text('Sign in', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success icon
        Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 32),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Check Your Email', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text("We've sent a password reset link to:", style: TextStyle(color: Colors.white.withOpacity(0.6)), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text(_emailController.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Text("Didn't receive the email? Check your spam folder or try again.", style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        // Buttons
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.2))),
                child: TextButton(
                  onPressed: () => setState(() => _emailSent = false),
                  child: const Text('Try Again', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.2))),
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back, color: Colors.white, size: 18), SizedBox(width: 8), Text('Back to Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))]),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _inputField(TextEditingController controller, String hint, TextInputType? type, String? Function(String?)? validator) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.1))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.white.withOpacity(0.2))),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.red)),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.jetBlack, AppColors.darkGray]), border: Border.all(color: Colors.white.withOpacity(0.1))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 64, height: 64, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)), child: const Center(child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))),
                const SizedBox(height: 16),
                const Text('Sending reset link...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 8),
                Text('Please wait a moment', style: TextStyle(color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
