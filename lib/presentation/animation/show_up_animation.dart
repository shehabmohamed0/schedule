import 'dart:async';
import 'package:flutter/material.dart';

class ShowUp extends StatefulWidget {
  final Widget child;
  final int? delay;
  final Duration? duration;
  final bool goesUp;

  ShowUp(
      {required this.child, this.delay, required this.goesUp, this.duration});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: widget.duration ?? Duration(milliseconds: 1000));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(
            begin: Offset(0.0, widget.goesUp ? 15 : -15), end: Offset.zero)
        .animate(curve);
    if (widget.delay == null) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay!), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  void didUpdateWidget(covariant ShowUp oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animController,
        child: widget.child,
        builder: (context, child) {
          return Opacity(
            opacity: _animController.value,
            child: Transform.translate(
              offset: _animOffset.value,
              child: child!,
            ),
          );
        });
  }
}
