import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle display4(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle display3(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle display2(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle display1(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle medium(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 18,
          fontFamily: 'Roboto',
        );
  }

  static TextStyle subhead(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle body2(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle body1(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle button(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall!.copyWith(
          fontFamily: 'Roboto',
        );
  }

  static TextStyle overline(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
          fontFamily: 'Roboto',
        );
  }
}
