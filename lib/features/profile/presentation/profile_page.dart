// lib/features/profile/presentation/profile_page.dart
import 'package:flutter/material.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'package:amiflow/features/profile/data/dummy_profile.dart';
import 'package:amiflow/features/profile/presentation/widgets/profile_badge.dart';
import 'package:amiflow/features/profile/presentation/widgets/profile_tile.dart';
import 'package:amiflow/shared/widgets/amiflow_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
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
              _buildAvatar(),
              const SizedBox(height: 20),
              const Text(
                ProfileData.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                ProfileData.role,
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
                onTap: () {
                  /* TODO: buka edit profile */
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

  Widget _buildAvatar() {
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
            child: Image.network(ProfileData.avatarUrl, fit: BoxFit.cover),
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
