import 'package:flutter/material.dart';

class TabNavigation extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const TabNavigation({
    Key? key,
    required this.selectedIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF1C1B1F),
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
