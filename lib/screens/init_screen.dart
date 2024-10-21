import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/Analytics/analytics_screen.dart';
import 'package:shop_app/screens/favorite/favorite_screen.dart';
import 'package:shop_app/screens/home/home_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';

const Color kInActiveIconColor = Color.fromARGB(255, 0, 0, 0);
const int homeIndex = 0;
const int favIndex = 1;
const int analyticsIndex = 2;
const int profileIndex = 3;

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = homeIndex;

  // Preload only the Analytics screen
  late Widget analyticsScreen;

  @override
  void initState() {
    super.initState();
    // Preload the Analytics screen and maintain its state
    analyticsScreen = const AnalyticsBoard();
  }

  // Lazily load other screens (without state preservation)
  Widget getPage(int index) {
    switch (index) {
      case homeIndex:
        return const HomeScreen();  // Will be recreated on every access
      case favIndex:
        return FavoriteScreen();  // Will be recreated on every access
      case analyticsIndex:
        return analyticsScreen;  // Preloaded, maintains state
      case profileIndex:
        return const ProfileScreen();  // Will be recreated on every access
      default:
        return const HomeScreen();
    }
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentSelectedIndex == analyticsIndex
          ? analyticsScreen  // Show the preloaded analytics screen (maintain state)
          : getPage(currentSelectedIndex),  // Lazily load other screens (no state preservation)
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Camera Icon.svg",
              height: 28,
              width: 28,
              colorFilter: const ColorFilter.mode(
                kInActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Camera Icon.svg",
              height: 26,
              width: 26,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/Heart Icon.svg",
              height: 26,
              width: 26,
              colorFilter: const ColorFilter.mode(
                kInActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/Heart Icon.svg",
              height: 26,
              width: 26,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Fav",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart_outlined, size: 30,),
            activeIcon: Icon(Icons.stacked_bar_chart_outlined, size: 30, color: Colors.red, ),
            label: "Analytics",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              height: 26,
              width: 26,
              colorFilter: const ColorFilter.mode(
                kInActiveIconColor,
                BlendMode.srcIn,
              ),
            ),
            activeIcon: SvgPicture.asset(
              "assets/icons/User Icon.svg",
              height: 26,
              width: 26,
              colorFilter: const ColorFilter.mode(
                kPrimaryColor,
                BlendMode.srcIn,
              ),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
