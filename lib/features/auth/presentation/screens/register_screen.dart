import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created! Please verify your email.')),
        );
        context.go(AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleSocialSignUp(String provider) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$provider sign up coming soon')),
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
                  text: 'Start Your Journey with ',
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
              Text('Create your account and unlock the full potential of our platform.', style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.6), height: 1.6), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Benefits - left aligned
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _benefitItem(Icons.flash_on, 'Get started in minutes'),
                  _benefitItem(Icons.credit_card_off, 'No credit card required'),
                  _benefitItem(Icons.support_agent, 'Free 24/7 support'),
                  _benefitItem(Icons.lock_clock, '14-day free trial'),
                ],
              ),
              const SizedBox(height: 32),
              // Trust badges
              Container(
                padding: const EdgeInsets.only(top: 32),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1)))),
                child: Column(
                  children: [
                    Text('Join 50,000+ businesses worldwide', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5))),
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

  Widget _benefitItem(IconData icon, String text) {
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
              color: Colors.green.withOpacity(0.2),
            ),
            child: Center(child: Icon(icon, color: Colors.green, size: 14)),
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
              // Header
              const Text('Create Account', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Fill in your details to get started', style: TextStyle(color: Colors.white.withOpacity(0.6)), textAlign: TextAlign.center),
              const SizedBox(height: 32),
              // Social buttons
              _socialButton(Icons.g_mobiledata, 'Continue with Google', () => _handleSocialSignUp('Google')),
              const SizedBox(height: 12),
              _socialButton(Icons.window, 'Continue with Microsoft', () => _handleSocialSignUp('Microsoft')),
              const SizedBox(height: 32),
              // Divider
              Row(
                children: [
                  Expanded(child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.transparent, Colors.white.withOpacity(0.2), Colors.transparent])))),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('or sign up with email', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.4)))),
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
                      Text('Full Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      _inputField(_nameController, 'Enter your full name', TextInputType.name, false, null, (v) => v == null || v.isEmpty ? 'Required' : null),
                      const SizedBox(height: 20),
                      Text('Email address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      _inputField(_emailController, 'Enter your email address', TextInputType.emailAddress, false, null, (v) => v == null || v.isEmpty ? 'Required' : (!v.contains('@') ? 'Invalid email' : null)),
                      const SizedBox(height: 20),
                      Text('Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      _inputField(_passwordController, 'Create a strong password', null, !_showPassword, IconButton(icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.white.withOpacity(0.6), size: 20), onPressed: () => setState(() => _showPassword = !_showPassword)), (v) => v == null || v.isEmpty ? 'Required' : (v.length < 8 ? 'Min 8 characters' : null)),
                      const SizedBox(height: 20),
                      Text('Confirm Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 4),
                      _inputField(_confirmPasswordController, 'Confirm your password', null, !_showConfirmPassword, IconButton(icon: Icon(_showConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.white.withOpacity(0.6), size: 20), onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword)), (v) => v == null || v.isEmpty ? 'Required' : (v != _passwordController.text ? 'Passwords do not match' : null)),
                      const SizedBox(height: 20),
                      // Terms checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: Checkbox(
                              value: _acceptTerms,
                              onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                              side: BorderSide(color: Colors.white.withOpacity(0.2)),
                              fillColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? Colors.white.withOpacity(0.2) : Colors.transparent),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'I agree to the ',
                                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6)),
                                children: const [
                                  TextSpan(text: 'Terms of Service', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                  TextSpan(text: ' and '),
                                  TextSpan(text: 'Privacy Policy', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Create Account button
                      Container(
                        height: 48,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.white.withOpacity(0.2))),
                        child: TextButton(
                          onPressed: _isLoading ? null : _handleRegister,
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.person_add, color: Colors.white, size: 18), SizedBox(width: 8), Text('Create Account', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16))]),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.login),
                            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                            child: const Text('Sign in', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ],
                  ),
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
                              const Text('Your data is protected', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('We use bank-level encryption to keep your information safe.', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.6))),
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
                const Text('Creating your account...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
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
