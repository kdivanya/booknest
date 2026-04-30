import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'home_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'order_history_screen.dart';
import 'profile_screen.dart';

// STATEFUL WIDGET — tab index state
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  int _previousIndex = 0;

  Widget _buildCartScreen() {
    return CartScreen(onBack: () {
      setState(() {
        _index = _previousIndex;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: [
        const HomeScreen(),
        const WishlistScreen(),
        _buildCartScreen(),
        const OrderHistoryScreen(),
        const ProfileScreen(),
      ]),
      bottomNavigationBar: BottomNav(
        currentIndex: _index,
        onTap: (i) {
          if (i != _index) {
            setState(() {
              _previousIndex = _index;
              _index = i;
            });
          }
        },
      ),
    );
  }
}
