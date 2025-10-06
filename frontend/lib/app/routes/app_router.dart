import 'package:go_router/go_router.dart';
import 'package:frontend/app/widgets/barrel.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/profile', // Lokasi awal saat aplikasi dibuka
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/sign_in',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ),    
      GoRoute(
        path: '/sign_up',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/home',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ),   
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/quiz_start',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/quiz_result',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/knowledge_article_list',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/knowledge_article_detail',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/loss_simulation',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/anonym_forum',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(), // Ganti dengan widget Anda
      ),       
    ],
  );
}