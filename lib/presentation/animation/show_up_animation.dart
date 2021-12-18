import 'dart:async';
import 'package:flutter/material.dart';

class ShowUp extends StatefulWidget {
  final Widget child;
  final int? delay;
  final Duration? duration;
  final bool goesUp;

  const ShowUp(
      {required this.child, this.delay, required this.goesUp, this.duration});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;
  bool _animate = false;
  late Duration duration;
  static bool _isStart = true;

  @override
  void initState() {
    super.initState();

    duration = widget.duration == null
        ? const Duration(milliseconds: 1000)
        : widget.duration!;
    _animController =
        AnimationController(vsync: this, duration: widget.duration ?? duration);

    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset = Tween<Offset>(
            begin: Offset(0.0, widget.goesUp ? 15 : -15), end: Offset.zero)
        .animate(curve);
    if (widget.delay == null) {
      _animController.forward();
      setState(() {
        _animate = true;
        _isStart = false;
      });
    } else {
      _isStart
          ? Future.delayed(Duration(milliseconds: widget.delay!), () {
              setState(() {
                _animate = true;
                _isStart = false;
              });
            })
          : _animate = true;
      _animController.forward();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
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
          return AnimatedOpacity(
            opacity: _animate ? 1 : 0,
            duration: duration,
            child: Transform.translate(
              offset: _animOffset.value,
              child: child!,
            ),
          );
        });
  }
}
