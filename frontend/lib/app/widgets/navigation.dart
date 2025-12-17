import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Widget? body;
  final PreferredSizeWidget? appBar;

  const MainNavigationBar({
    super.key,
    required this.currentIndex,
    this.body,
    this.appBar,
  });

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.push('/home');
        break;
      case 1:
        context.push('/anonym-forum');
        break;
      case 2:
        context.push('/chatbot');
        break;
      case 3:
        context.push('/profile');
        break;
      case 4:      
    }
  }

  void _onFabPressed(BuildContext context) {
    context.push('/make-post');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onFabPressed(context),
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFD9D9D9),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(context, 0, 'assets/images/home.png'),
              _navItem(context, 1, 'assets/images/group.png'),
              const SizedBox(width: 40),
              _navItem(context, 2, 'assets/images/generative.png'),
              _navItem(context, 3, 'assets/images/user.png'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(BuildContext context, int index, String asset) {
    return IconButton(
      onPressed: () => _onTap(context, index),
      icon: ImageIcon(
        AssetImage(asset),
        color: currentIndex == index
            ? Colors.black
            : Colors.black.withOpacity(0.6),
      ),
    );
  }
}
