import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go(AppRoutes.dashboard);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleSocialLogin(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider login coming soon')),
    );
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
              // Welcome text
              Text.rich(
                TextSpan(
                  text: 'Welcome Back to ',
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                  children: [
                    WidgetSpan(
                      child: ShaderMask(
                        shaderCallback: (b) => const LinearGradient(colors: [Colors.white, AppColors.silver, Colors.white]).createShader(b),
                        child: const Text('ZinapsPay', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text('Access your dashboard and manage your payments seamlessly.', style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.6), height: 1.6), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Features - left aligned like Next.js (text-left on ul)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _featureItem(Icons.shield_outlined, 'Bank-level security'),
                  _featureItem(Icons.access_time, 'Real-time notifications'),
                  _featureItem(Icons.show_chart, 'Advanced analytics'),
                  _featureItem(Icons.headset_mic_outlined, '24/7 support'),
                ],
              ),
              const SizedBox(height: 32),
              // Trust badges
              Container(
                padding: const EdgeInsets.only(top: 32),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
                child: Column(
                  children: [
                    Text('Trusted by 50,000+ businesses worldwide', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
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
              const SizedBox(height: 24),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('© 2024 ZinapsPay', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                  Text(' • ', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                  Text('Privacy Policy', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                  Text(' • ', style: TextStyle(color: Colors.white.withOpacity(0.5))),
                  Text('Terms of Service', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    // Next.js: flex items-center space-x-3 (12px gap)
    // Icon container: w-6 h-6 (24px) glass-effect rounded-full
    // Icon: text-sm (14px)
    // Text: text-white/80
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8), // space-y-4 = 16px total between items
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
          const SizedBox(width: 12), // space-x-3
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
              // Header
              const Text('Sign In', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Enter your credentials to access your account', style: TextStyle(color: Colors.white.withOpacity(0.6)), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Social buttons
              _socialButton(Icons.g_mobiledata, 'Continue with Google', () => _handleSocialLogin('Google')),
              const SizedBox(height: 12),
              _socialButton(Icons.window, 'Continue with Microsoft', () => _handleSocialLogin('Microsoft')),
              const SizedBox(height: 12),
              _socialButton(Icons.apple, 'Continue with Apple', () => _handleSocialLogin('Apple')),
              const SizedBox(height: 32),
              // Divider
              Row(
                children: [
                  Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(0.2), Colors.transparent])))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or sign in with email', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.4)))),
                  Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(0.2), Colors.transparent])))),
                ],
              ),
              const SizedBox(height: 32),
              // Form card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.jetBlack, AppColors.darkGray]),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 40, offset: const Offset(0, 20))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Email address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      _inputField(_emailController, 'Enter your email address', TextInputType.emailAddress, false, null, (v) => v == null || v.isEmpty ? 'Required' : (!v.contains('@') ? 'Invalid email' : null)),
                      const SizedBox(height: 24),
                      Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      _inputField(_passwordController, 'Enter your password', null, !_showPassword, IconButton(icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.white.withOpacity(0.6), size: 20), onPressed: () => setState(() => _showPassword = !_showPassword)), (v) => v == null || v.isEmpty ? 'Required' : null),
                      const SizedBox(height: 16),
                      // Remember & Forgot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) => setState(() => _rememberMe = v ?? false),
                                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                                  fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white.withOpacity(0.2) : Colors.transparent),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Remember me', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                            ],
                          ),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.forgotPassword),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Forgot password?', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Sign In button
                      Container(
                        height: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.2))),
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.login, color: Colors.white, size: 18), SizedBox(width: 8), Text('Sign In', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                          TextButton(
                            onPressed: () => context.push(AppRoutes.register),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Sign up for free', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Help section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.jetBlack, AppColors.darkGray]), border: Border.all(color: Colors.white.withOpacity(0.1))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Need help?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 8),
                    _helpItem(Icons.help_outline, 'Contact support'),
                    _helpItem(Icons.book_outlined, 'View documentation'),
                    _helpItem(Icons.play_circle_outline, 'Watch tutorials'),
                  ],
                ),
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

  Widget _socialButton(IconData icon, String label, VoidCallback onPressed) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: Colors.white.withOpacity(0.05),
          child: InkWell(
            onTap: onPressed,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white.withOpacity(0.1))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(icon, color: Colors.white, size: 24), const SizedBox(width: 12), Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16))]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController controller, String hint, TextInputType? type, bool obscure, Widget? suffix, String? Function(String?)? validator) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: TextFormField(
          controller: controller,
          keyboardType: type,
          obscureText: obscure,
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
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }

  Widget _helpItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [Icon(icon, color: Colors.white.withOpacity(0.6), size: 16), const SizedBox(width: 8), Text(label, style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)))]),
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
                const Text('Signing you in...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
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
