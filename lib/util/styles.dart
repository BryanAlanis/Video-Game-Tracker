import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

//
// Colors
//
Color getBackgroundColor () => const Color(0xFF151618);
Color getDarkBackgroundColor () => const Color(0xFF090A0B);
Color getWhiteColor () => const Color(0xFFffffff);
Color getWhiteOpacityColor () => Colors.white38;
Color getGreenColor () => const Color(0xFF87b38d);
Color getYellowColor () => const Color(0xFFde9e36);
Color getVioletColor () => const  Color(0xFF8865A4); //Color(0xFF7b506f);
Color getBlueColor () => const Color(0xFF7EBCE6);
Color getRedColor () => const Color(0xFFEF2917);

//
// Padding and Sizes
//
double getEdgePadding () => 15;

/// Default: 8 can be increased by providing a factor
double getBorderRadius ({double factor = 1}) => 8 * factor;

double getAppBarHeight ({double factor = 1}) => 60 * factor;

double getProfilePictureRadiusBig () => 60;

//
// App Theme
//
ThemeData getAppTheme () {
  return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: getBackgroundColor(),
      splashFactory: InkRipple.splashFactory,
      /// Color Scheme
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: getVioletColor(),
          onPrimary: getWhiteColor(),
          secondary: getDarkBackgroundColor(),
          onSecondary: getWhiteColor(),
          error: getRedColor(),
          onError: getWhiteColor(),
          surface: getBackgroundColor(),
          onSurface: getWhiteColor()
      ),
      dividerColor: Colors.white30,
      /// Icon Theme
      iconTheme: IconThemeData(
          color: getWhiteColor()
      ),
      /// Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 15,
          // showSelectedLabels: false,
          // showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          backgroundColor: getBackgroundColor(),
          selectedItemColor: getWhiteColor(),
          unselectedItemColor: getWhiteColor(),
          enableFeedback: false,
          selectedIconTheme: const IconThemeData(size: 32,)
      ),
      /// Appbar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: getBackgroundColor(),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 55,
      )
  );
}

//
// Pagination
//
SwiperPagination getPagination () {
  return SwiperPagination(
    alignment: Alignment.bottomCenter,
    builder: DotSwiperPaginationBuilder(
      color: Colors.white54,
      activeColor: getVioletColor(),
    ),
  );
}