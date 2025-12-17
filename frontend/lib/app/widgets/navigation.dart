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

  static const double _iconSize = 26; // 🔥 ukuran seragam

  void _navigate(BuildContext context, String route) {
    context.go(route);
  }

  Color _iconColor(int index) {
    return currentIndex == index ? Colors.black : Colors.grey;
  }

  void _onFabPressed(BuildContext context) {
    context.push('/make-post');
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                size: _iconSize,
                color: _iconColor(0),
              ),
              onPressed: () => _navigate(context, '/home'),
            ),

            IconButton(
              icon: Icon(
                Icons.chat_bubble,
                size: _iconSize,
                color: _iconColor(1),
              ),
              onPressed: () => _navigate(context, '/anonym-forum'),
            ),

            IconButton(
              icon: Icon(
                Icons.assignment,
                size: _iconSize,
                color: _iconColor(2),
              ),
              onPressed: () => _navigate(context, '/quiz'),
            ),

            IconButton(
              icon: Icon(
                Icons.lightbulb,
                size: _iconSize,
                color: _iconColor(3),
              ),
              onPressed: () => _navigate(context, '/knowledge'),
            ),

            IconButton(
              icon: Icon(
                Icons.person,
                size: _iconSize,
                color: _iconColor(4),
              ),
              onPressed: () => _navigate(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}