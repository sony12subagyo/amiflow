// lib/core/navigation/main_screen.dart
import 'package:amiflow/features/gateway/domain/entities/gateway.dart';
import 'package:amiflow/features/gateway/presentation/gateway_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amiflow/core/theme/app_colors.dart';
import 'navigation_cubit.dart';
import 'app_pages.dart';
import 'bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final PageController _pageController;

Gateway? selectedGateway;


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

@override
Widget build(BuildContext context) {
  /// Belum memilih Gateway
  if (selectedGateway == null) {
    return GatewayPage(
      onGatewaySelected: (gateway) {
        setState(() {
          selectedGateway = gateway;
        });
      },
    );
  }

  /// Sudah memilih Gateway
  return BlocProvider(
    create: (_) => NavigationCubit(),
    child: BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          extendBody: true,
          backgroundColor: AppColors.background,

          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) =>
                context.read<NavigationCubit>().selectTab(index),

            children: AppPages.pages(
              selectedGateway!,
              () {
                setState(() {
                  selectedGateway = null;
                });
              },
            ),
          ),

          bottomNavigationBar: BottomNav(
            currentIndex: currentIndex,
            onTap: _onNavTap,
          ),
        );
      },
    ),
  );
}
}