import 'package:go_router/go_router.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/super_admin/super_admin_dashboard.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/technician/technician_dashboard.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/super-admin',
        builder: (context, state) => const SuperAdminDashboard(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/technician',
        builder: (context, state) => const TechnicianDashboard(),
      ),
    ],
  );
}
