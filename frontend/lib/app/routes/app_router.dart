import 'package:frontend/features/1_welcome/screens/welcome_screen.dart';
import 'package:frontend/features/4_quiz/screens/quiz_result_screen.dart';
import 'package:frontend/features/4_quiz/screens/quiz_screen.dart';
import 'package:frontend/features/4_quiz/screens/quiz_start_screen.dart';
import 'package:frontend/features/7_anonym_forum/screens/anonym_forum_screen.dart';
import 'package:frontend/features/8_chatbot/screens/chatbot_screen.dart';
import 'package:frontend/features/6_loss_simulation/screens/loss_simulation_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/app/widgets/barrel.dart';

import '../../features/7_anonym_forum/screens/make_post_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/welcome', // Lokasi awal saat aplikasi dibuka
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const SplashScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) =>
            const WelcomeScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) =>
            const SignInScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) =>
            const SignUpScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const HomeScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/quiz',
        builder: (context, state) => const QuizScreen(),
        routes: [
          GoRoute(
            path: 'quiz-start', // Menjadi /quiz-intro/start
            builder: (context, state) => const QuizStartScreen(),
          ),
          GoRoute(
            path: 'quiz-result', // Menjadi /quiz-intro/result
            builder: (context, state) {
              // Menerima data yang dikirim via 'extra'
              final map = state.extra as Map<String, dynamic>;
              return QuizResultScreen(
                score: map['score'] as int,
                riskLevel: map['riskLevel'] as int,
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/knowledge',
        builder: (context, state) => const KnowledgeScreen(),
        routes: [
          GoRoute(
            path: '/article-detail',
            builder: (context, state) {
              final article =
                  state.extra as Article; // Ambil data artikel dari extra
              return ArticleDetailScreen(
                article: article,
              ); // Kirim data ke layar detail
            },
          ),
        ], // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/loss-simulation',
        builder: (context, state) =>
            const LossSimulationScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/anonym-forum',
        builder: (context, state) => const AnonymForumScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/make-post',
        builder: (context, state) => const MakePostScreen(), // Ganti dengan widget Anda
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) => const AIChatBoxScreen(), // Ganti dengan widget Anda
      ), 
      GoRoute(
        path: '/profile',
        builder: (context, state) =>
            const ProfileScreen(), // Ganti dengan widget Anda
      ),
    ],
  );
}

