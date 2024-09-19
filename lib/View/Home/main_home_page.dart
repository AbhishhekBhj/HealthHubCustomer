import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:healthhubcustomer/View/Home/Activities/activites_page.dart';
import 'package:healthhubcustomer/View/Home/HomeOptions/home_options.dart';
import 'package:healthhubcustomer/View/Home/Side/side_options_page.dart';
import 'package:healthhubcustomer/View/Home/trainer/trainer_page.dart';

import '../../colors/colors.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({super.key});

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage> with TickerProviderStateMixin {
  final List<IconData> icons = [
    Icons.home,
    Icons.search,
    Icons.notifications,
    Icons.person,
  ];

  final List<Widget> _pages = [
    const HomeOptions(),
    const ActivitesPage(),
    const TrainerPage(),
    const SideOptionsPage(),
  ];

  int activeIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _iconAnimation;
  late PageController _pageController;

  void onTap(int index) {
    setState(() {
      activeIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _animationController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _iconAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _pageController = PageController(initialPage: activeIndex);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        allowImplicitScrolling: false,
        
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            activeIndex = index;
          });
        },
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _pages[index],
          );
        },
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: icons.length,
        tabBuilder: (int index, bool isActive) {
          final color = isActive ? Colors.blue : Colors.grey;
          return ScaleTransition(
            scale: isActive ? _iconAnimation : const AlwaysStoppedAnimation(1.0),
            child: Icon(
              icons[index],
              color: color,
              size: 28,
            ),
          );
        },
        backgroundColor: appWhiteColor,
        activeIndex: activeIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => onTap(index),
        splashColor: Colors.blueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Center action button
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded look for the button
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
