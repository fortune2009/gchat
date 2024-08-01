import 'package:flutter/material.dart';

class HSpace extends StatelessWidget {
  const HSpace(
    this.length, {
    super.key,
    this.child,
  });

  final double length;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: length,
    );
  }
}

class WSpace extends StatelessWidget {
  const WSpace(
    this.length, {
    super.key,
    this.child,
  });

  final double length;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: length,
    );
  }
}
