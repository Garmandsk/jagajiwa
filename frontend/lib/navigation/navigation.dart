import 'package:flutter/material.dart';

// Screens
import '../features/3_home/screens/home_screen.dart';
import '../features/7_anonym_forum/screens/anonym_forum_screen.dart';
import '../features/8_chatbot/screens/chatbot_screen.dart';
import '../features/9_profile/screens/profile_screen.dart';


class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({super.key, this.initialIndex = 1});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = const [
    HomeScreen(),
    AnonymForumScreen(),
    AIChatBoxScreen(),
    ProfileScreen(),
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],

      // ===== FLOATING PLUS BUTTON =====
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: aksi tambah post
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          size: 32,
          color: Colors.white,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ===== BOTTOM NAV BAR =====
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFD9D9D9),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                index: 0,
                asset: 'assets/images/home.png',
              ),
              _navItem(
                index: 1,
                asset: 'assets/images/group.png',
              ),

              const SizedBox(width: 40), // ruang FAB

              _navItem(
                index: 2,
                asset: 'assets/images/generative.png',
              ),
              _navItem(
                index: 3,
                asset: 'assets/images/user.png',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required int index,
    required String asset,
  }) {
    return IconButton(
      onPressed: () => _onItemTapped(index),
      icon: ImageIcon(
        AssetImage(asset),
        color: _selectedIndex == index
            ? Colors.black
            : Colors.black.withOpacity(0.6),
      ),
    );
  }
}
