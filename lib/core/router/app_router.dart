import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../shared/widgets/dashboard_layout.dart';

/// Route paths
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String verifyEmail = '/verify-email';

  // Dashboard routes
  static const String dashboard = '/dashboard';
  static const String home = '/';

  // ZinapsAI routes
  static const String zinapsai = '/zinapsai';
  static const String zinapsaiAnalytics = '/zinapsai/analytics';
  static const String zinapsaiCollaboration = '/zinapsai/collaboration';
  static const String zinapsaiWorkflows = '/zinapsai/workflows';
  static const String zinapsaiTraining = '/zinapsai/training';
  static const String zinapsaiSearch = '/zinapsai/search';

  // Operations routes
  static const String inventory = '/inventory';
  static const String inbound = '/inbound';
  static const String outbound = '/outbound';
  static const String storage = '/storage';
  static const String shipments = '/shipments';
  static const String returns = '/returns';

  // Business routes
  static const String analytics = '/analytics';
  static const String customers = '/customers';
  static const String pricing = '/pricing';
  static const String billing = '/billing';

  // Configuration routes
  static const String rules = '/rules';
  static const String templates = '/templates';
  static const String integrations = '/integrations';
  static const String importStatus = '/import-status';

  // Support routes
  static const String onboarding = '/onboarding';
  static const String help = '/help';
  static const String feedback = '/feedback';
  static const String settings = '/settings';

  // Invoice routes (legacy)
  static const String invoices = '/invoices';
  static const String invoiceDetail = '/invoices/:id';
  static const String createInvoice = '/invoices/create';

  // Customer detail routes
  static const String customerDetail = '/customers/:id';
  static const String createCustomer = '/customers/create';

  // Product routes
  static const String products = '/products';
  static const String productDetail = '/products/:id';
  static const String createProduct = '/products/create';

  // Settings sub-routes
  static const String profile = '/settings/profile';
  static const String notifications = '/settings/notifications';
}

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // TODO: Change back to AppRoutes.login for production
    initialLocation: AppRoutes.dashboard,
    debugLogDiagnostics: true,
    routes: [
      // Auth routes (no sidebar)
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ForgotPasswordScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Dashboard routes (with sidebar via ShellRoute)
      ShellRoute(
        builder: (context, state, child) {
          return DashboardLayout(
            currentPath: state.uri.path,
            child: child,
          );
        },
        routes: [
          // Home redirects to dashboard
          GoRoute(
            path: AppRoutes.home,
            redirect: (context, state) => AppRoutes.dashboard,
          ),
          // Dashboard
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const DashboardScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          ),
          // Placeholder routes for other screens (to be implemented)
          ..._buildPlaceholderRoutes(),
        ],
      ),
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.dashboard),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
});

// Placeholder routes for screens not yet implemented
List<GoRoute> _buildPlaceholderRoutes() {
  final placeholderPaths = [
    AppRoutes.zinapsai,
    AppRoutes.zinapsaiAnalytics,
    AppRoutes.zinapsaiCollaboration,
    AppRoutes.zinapsaiWorkflows,
    AppRoutes.zinapsaiTraining,
    AppRoutes.zinapsaiSearch,
    AppRoutes.inventory,
    AppRoutes.inbound,
    AppRoutes.outbound,
    AppRoutes.storage,
    AppRoutes.shipments,
    AppRoutes.returns,
    AppRoutes.analytics,
    AppRoutes.customers,
    AppRoutes.pricing,
    AppRoutes.billing,
    AppRoutes.rules,
    AppRoutes.templates,
    AppRoutes.integrations,
    AppRoutes.importStatus,
    AppRoutes.onboarding,
    AppRoutes.help,
    AppRoutes.feedback,
    AppRoutes.settings,
  ];

  return placeholderPaths.map((path) {
    final name = path.replaceAll('/', '-').replaceFirst('-', '');
    return GoRoute(
      path: path,
      name: name,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: _PlaceholderScreen(title: _getScreenTitle(path)),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }).toList();
}

String _getScreenTitle(String path) {
  final parts = path.split('/').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return 'Unknown';
  return parts.map((p) => p[0].toUpperCase() + p.substring(1)).join(' > ');
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: Colors.white.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
