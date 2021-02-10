import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/view/homepage.dart';
import 'package:movie_app/view/trandingMovies.dart';

class MainView extends StatelessWidget {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PageViewController>(
      init: PageViewController(),
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.selectedPage,
            onTap: (value) {
              controller.onTapHandler(value);
              pageController.animateToPage(
                value,
                duration: Duration(milliseconds: 100),
                curve: Curves.bounceIn,
              );
            },
            items: [
              BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home_outlined),
              ),
              BottomNavigationBarItem(
                label: "Trending",
                icon: Icon(Icons.trending_up_rounded),
              ),
            ],
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: (value) {
              controller.onTapHandler(value);
            },
            children: [
              HomePage(),
              TrendingMovies(),
            ],
          ),
        );
      },
    );
  }
}

class PageViewController extends GetxController {
  int currentIndex = 0;
  int selectedPage = 0;
  onTapHandler(int value) {
    selectedPage = value;
    update();
  }
}
