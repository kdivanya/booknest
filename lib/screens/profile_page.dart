import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/profile_menu_item.dart';

// STATELESS WIDGET — Profile page menampilkan menu statis
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgMain,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Profile Header ──
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEDE8FB), Color(0xFFF7E8F4)],
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'username',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryDeep),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'abcdef9@gmail.com',
                      style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 16),
                    // Stats row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _statItem('12', 'Orders'),
                        _dividerV(),
                        _statItem('5', 'Wishlist'),
                        _dividerV(),
                        _statItem('3', 'Reviews'),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Menu Sections ──
              const SizedBox(height: 12),
              _menuSection(
                context,
                title: 'Account',
                items: [
                  const ProfileMenuItem(label: 'Manage Profile', icon: Icons.manage_accounts_rounded),
                  const ProfileMenuItem(label: 'Password & Security', icon: Icons.lock_outline_rounded),
                  const ProfileMenuItem(label: 'Notifications', icon: Icons.notifications_outlined),
                  const ProfileMenuItem(label: 'History', icon: Icons.history_rounded),
                  const ProfileMenuItem(label: 'Address', icon: Icons.location_on_outlined, showDivider: false),
                ],
              ),

              const SizedBox(height: 12),
              _menuSection(
                context,
                title: 'Support',
                items: [
                  const ProfileMenuItem(label: 'Help Center', icon: Icons.help_outline_rounded, showDivider: false),
                ],
              ),

              const SizedBox(height: 12),
              // Logout
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.danger.withValues(alpha: 0.2)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout_rounded, color: AppColors.danger, size: 18),
                        SizedBox(width: 8),
                        Text('Log Out', style: TextStyle(color: AppColors.danger, fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.primaryDeep)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  Widget _dividerV() {
    return Container(height: 30, width: 1, color: AppColors.borderMid);
  }

  Widget _menuSection(BuildContext context, {required String title, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textMuted, letterSpacing: 0.3),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}