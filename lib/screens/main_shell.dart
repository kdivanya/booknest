import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'home_page.dart';
import 'wishlist_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

// STATEFUL WIDGET — MainShell menyimpan index tab aktif
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    WishlistPage(),
    CartPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}
