import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';

class SuperScaffold extends StatelessWidget {
  final Widget child;
  final Color topColor;
  final Color botColor;
  final bool xBotSafe;
  const SuperScaffold({
    super.key,
    this.topColor = Colors.white,
    this.botColor = Colors.white,
    required this.child,
    this.xBotSafe = true,
  });

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        setBarColor(topColor, botColor);
        if (Platform.isIOS) {
          topColor.computeLuminance() > 0.179
              ? setBarBrightnessDark()
              : setBarBrightnessLight();
        }
      },
      onVisibilityGained: () {
        setBarColor(topColor, botColor);
        if (Platform.isIOS) {
          topColor.computeLuminance() > 0.179
              ? setBarBrightnessDark()
              : setBarBrightnessLight();
        }
      },
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1)),
        child: Container(
          color: topColor,
          child: SafeArea(
            top: true,
            left: false,
            right: false,
            bottom: xBotSafe,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

void setBarBrightnessLight() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
  );
}

void setBarBrightnessDark() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarBrightness: Brightness.light),
  );
}

void setBarColor(Color top, Color bot) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: top,
      systemNavigationBarColor: bot,
      statusBarIconBrightness: top.computeLuminance() > 0.179
          ? Brightness.dark
          : Brightness.light,
    ),
  );
}
