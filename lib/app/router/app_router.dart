import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/home_screen.dart';
import '../../features/auth/screens/project_details_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../../features/auth/screens/edit_profile_screen.dart';
import '../../features/auth/screens/welcome_screen.dart';
import 'package:tasky_app/features/auth/screens/calendar_screen.dart';
import '../../features/auth/screens/create_task_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/', // ✅ Je démarre sur la page d'accueil WelcomeScreen
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeScreen(), // 🏡 WelcomeScreen devient la page d'accueil
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
  path: '/create-task',
  builder: (context, state) => const CreateTaskScreen(),
),
    GoRoute(
  path: '/calendar',
  name: 'calendar',
  builder: (context, state) => const CalendarScreen(),
),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/edit_profile',
      name: 'edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      path: '/project/:id',
      name: 'project-details',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProjectDetailsScreen(projectId: id);
      },
    ),
  ],
);
