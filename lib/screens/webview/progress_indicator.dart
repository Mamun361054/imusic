import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveProgressIndicator extends StatelessWidget {
  const AdaptiveProgressIndicator({
    Key? key,
    this.backgroundColor,
    this.color,
    this.strokeWidth = 4,
    this.value,
    this.iOSLoadingIndicatorRadius = 15,
  }) : super(key: key);

  /// Main color for `CircularProgressIndicator` or `CupertinoActivityIndicator`
  final Color? color;

  /// Only `Android` - it gave `CircularProgressIndicator` background color
  final Color? backgroundColor;

  /// Only `Android` - it gave `CircularProgressIndicator` stroke width
  final double strokeWidth;

  /// Only `Android` - set value 0.0 to maximum 1.0
  final double? value;

  /// Only `iOS` - we use this to give `CupertinoActivityIndicator` radius
  final double iOSLoadingIndicatorRadius;

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? androidIndicator(context)
        : iOSIndicator(context);
  }

  CircularProgressIndicator androidIndicator(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: backgroundColor ?? Colors.transparent,
      color: color ?? Theme.of(context).colorScheme.primary,
      strokeWidth: strokeWidth,
      value: value,
      key: key,
    );
  }

  CupertinoActivityIndicator iOSIndicator(BuildContext context) {
    return CupertinoActivityIndicator(
      color: color ?? Theme.of(context).colorScheme.primary,
      radius: iOSLoadingIndicatorRadius,
      key: key,
    );
  }
}
