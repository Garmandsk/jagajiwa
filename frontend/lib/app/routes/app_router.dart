import 'package:frontend/features/7_anonym_forum/screens/anonym_forum_screen.dart';
import 'package:frontend/features/7_anonym_forum/screens/make_post_screen.dart';
import 'package:frontend/features/8_chatbot/screens/chatbot_screen.dart';
import 'package:frontend/features/6_loss_simulation/screens/loss_simulation_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/app/widgets/barrel.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/sign-in', // Lokasi awal saat aplikasi dibuka
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) => const SignInScreen(), // Ganti dengan widget Anda
      ),    
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(), // Ganti dengan widget Anda
      ),   
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const HomeScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/quiz-start',
        builder: (context, state) => const HomeScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/quiz-result',
        builder: (context, state) => const HomeScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/knowledge',
        builder: (context, state) => const KnowledgeScreen(),
        routes: [
          GoRoute(
            path: '/article-detail',
            builder: (context, state) {
              final article = state.extra as Article; // Ambil data artikel dari extra
              return ArticleDetailScreen(article: article); // Kirim data ke layar detail
            },
          ),
        ], // Ganti dengan widget Anda
      ),       
      GoRoute(
        path: '/loss-simulation',
        builder: (context, state) => const LossSimulationScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/anonym-forum',
        builder: (context, state) => const AnonymForumScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/make-post',
        builder: (context, state) => const MakePostScreen(),
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const AIChatBoxScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(), // Ganti dengan widget Anda
      ),       
    ],
  );
}