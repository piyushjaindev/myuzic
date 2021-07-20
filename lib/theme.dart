import 'package:flutter/material.dart';

class AppTheme {
  static Color _primaryColor = Color(0xFF2DCEEF);
  static Color _appBarColor = Color(0xFF161A1A);

  static SliderThemeData _sliderThemeData = SliderThemeData(
    activeTrackColor: Color(0xFF2DCEEF),
    inactiveTrackColor: Color(0xFF99999F),
    overlayShape: SliderComponentShape.noOverlay,
    showValueIndicator: ShowValueIndicator.never,
    thumbColor: Color(0xFF2DCEEF),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
    trackHeight: 4.0,
  );

  static AppBarTheme _appBarTheme = AppBarTheme(
    elevation: 0,
    color: _appBarColor,
    centerTitle: true,
    iconTheme: _iconThemeData,
    actionsIconTheme: _iconThemeData,
    textTheme: TextTheme(headline6: _headline6),
  );

  static ElevatedButtonThemeData _elevatedButtonThemeData =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      elevation: 0,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      textStyle: _bodyText1,
      onPrimary: Colors.white,
    ),
  );

  static OutlinedButtonThemeData _outlineButtonThemeData =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 16),
      primary: Colors.white,
      side: BorderSide(
        width: 2,
        color: Colors.white,
      ),
      textStyle: _bodyText1,
    ),
  );

  static InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    fillColor: Color(0xFFFFFFFFFF),
    filled: true,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10),
    ),
    labelStyle: TextStyle(
      fontFamily: 'Lato',
      fontSize: 12,
      color: Color(0xFF99999F),
    ),
    hintStyle: TextStyle(
      fontFamily: 'Lato',
      fontSize: 14,
      color: Colors.black,
    ),
  );

  static TabBarTheme _tabBarTheme = TabBarTheme(
    labelStyle: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    unselectedLabelStyle: TextStyle(
      fontFamily: 'Lato',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white,
    labelPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: Color(0xFF2DCEEF),
        width: 3,
        style: BorderStyle.solid,
      ),
    ),
    indicatorSize: TabBarIndicatorSize.label,
  );

  static IconThemeData _iconThemeData = IconThemeData(
    color: Colors.white,
  );

  static BottomNavigationBarThemeData _bottomNavigationBarTheme =
      BottomNavigationBarThemeData(
    showUnselectedLabels: true,
    backgroundColor: _appBarColor,
    selectedItemColor: _primaryColor,
    unselectedItemColor: Color(0xFF99999F),
    type: BottomNavigationBarType.fixed,
  );

  static TextStyle _headline1 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle _headline4 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle _headline5 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle _headline6 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle _bodyText1 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle _bodyText2 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 12,
    color: Color(0xFF99999F),
  );

  static TextStyle _subTitle1 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 16,
    color: Color(0xFFFFFFFF),
  );

  static TextStyle _subTitle2 = TextStyle(
    fontFamily: 'Lato',
    fontSize: 14,
    color: Color(0xFF99999F),
  );

  static ThemeData appTheme = ThemeData(
      primaryColor: _primaryColor,
      canvasColor: Color(0xFF161A1A),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      appBarTheme: _appBarTheme,
      sliderTheme: _sliderThemeData,
      elevatedButtonTheme: _elevatedButtonThemeData,
      outlinedButtonTheme: _outlineButtonThemeData,
      inputDecorationTheme: _inputDecorationTheme,
      iconTheme: _iconThemeData,
      tabBarTheme: _tabBarTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      textTheme: TextTheme(
        headline1: _headline1,
        headline4: _headline4,
        headline5: _headline5,
        headline6: _headline6,
        bodyText1: _bodyText1,
        bodyText2: _bodyText2,
        subtitle1: _subTitle1,
        subtitle2: _subTitle2,
      ));
}
