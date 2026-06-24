import 'package:amiflow/core/navigation/bottom_nav.dart';
import 'package:amiflow/shared/widgets/background_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_cubit.dart';
import 'app_pages.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // PageController murni urusan animasi UI, jadi tetap di sini (bukan di Cubit)
  late final PageController _pageController;

  static const _titles = ['Home', 'Pencarian', 'Profil'];
  static const _appBarColor = Color.fromARGB(255, 0, 128, 255);

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
    return BlocProvider(
      create: (_) => NavigationCubit(),
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentIndex) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: _appBarColor,
              title: Text(
                _titles[currentIndex],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: BackgroundWrapper(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) =>
                    context.read<NavigationCubit>().selectTab(index),
                children: AppPages.pages,
              ),
            ),
            bottomNavigationBar: BottomNav(
              currentIndex: currentIndex,
              onTap: (index) => _onNavTap(index),
            ),
          );
        },
      ),
    );
  }
}
