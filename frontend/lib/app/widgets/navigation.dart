import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavigationBar extends StatelessWidget {
  final int currentIndex;

  const MainNavigationBar({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, String route) {
    context.go(route);
  }

  Color _iconColor(int index) {
    return currentIndex == index ? Colors.black : Colors.grey;
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
              icon: Icon(Icons.home, color: _iconColor(0)),
              onPressed: () => _navigate(context, '/home'),
            ),

            IconButton(
              icon: Icon(Icons.chat_bubble, color: _iconColor(1)),
              onPressed: () => _navigate(context, '/anonym-forum'),
            ),

            IconButton(
              icon: Icon(
                Icons.assignment, //
                size: 28,
                color: _iconColor(2),
              ),
              onPressed: () => _navigate(context, '/quiz'),
            ),

            IconButton(
              icon: Icon(Icons.lightbulb, color: _iconColor(3)),
              onPressed: () => _navigate(context, '/knowledge'),
            ),

            IconButton(
              icon: Icon(Icons.person, color: _iconColor(4)),
              onPressed: () => _navigate(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }
}


