// lib/features/profile/presentation/profile_page.dart
import 'package:amiflow/core/auth/current_user.dart';
import 'package:amiflow/features/profile/presentation/edit_profile_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/profile/data/dummy_profile.dart';
import 'package:amiflow/features/profile/presentation/widgets/profile_badge.dart';
import 'package:amiflow/features/profile/presentation/widgets/profile_tile.dart';
import 'package:amiflow/shared/widgets/amiflow_header.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = CurrentUser.user;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            100,
          ), // 100 = ruang untuk pill
          child: Column(
            children: [
              const AmiflowHeader(),
              const SizedBox(height: 40),
              _buildAvatar(user?.name ?? "-"),
              const SizedBox(height: 20),
              Text(
                user?.name ?? "-",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Administrator",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 15),

              const SizedBox(height: 40),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Informasi Akun',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ProfileTile(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () async {
                  final result = await showModalBottomSheet<bool>(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => const EditProfileBottomSheet(),
                  );

                  if (result == true && mounted) {
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 30),
              _buildLogoutButton(context),
              const SizedBox(height: 20),
              const Text(
                ProfileData.appVersion,
                style: TextStyle(color: Colors.white30, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "?";

    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Widget _buildAvatar(String name) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Center(
              child: Text(
                _getInitials(name),
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.edit, color: Colors.black, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.2),
          foregroundColor: AppColors.danger,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          // Hapus semua halaman di stack, masuk ke login
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        },
        icon: const Icon(Icons.logout),
        label: const Text('Logout', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
