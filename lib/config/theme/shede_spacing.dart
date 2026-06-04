import 'package:flutter/material.dart';

/// 舍得 App 间距系统
class SheDeSpacing {
  SheDeSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double marginMobile = 16;
  static const double marginDesktop = 32;
}

/// 舍得 App 圆角系统
class SheDeRadius {
  SheDeRadius._();

  static const double sm = 8;   // DEFAULT
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  static BorderRadius get smAll => BorderRadius.circular(sm);
  static BorderRadius get mdAll => BorderRadius.circular(md);
  static BorderRadius get lgAll => BorderRadius.circular(lg);
  static BorderRadius get xlAll => BorderRadius.circular(xl);
}
