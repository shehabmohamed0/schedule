import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:schedule/presentation/screens/hidden_drawer/hidden_drawer.dart';
import 'package:schedule/core/constants/constants.dart';
import '../screens/home_screen/home_screen.dart';

class DrawerNavigator extends StatefulWidget {
  const DrawerNavigator({Key? key}) : super(key: key);

  @override
  _DrawerNavigatorState createState() => _DrawerNavigatorState();
}

class _DrawerNavigatorState extends State<DrawerNavigator>
    with SingleTickerProviderStateMixin {
  final Duration _toggleDuration = const Duration(milliseconds: 250);
  late double _maxSlide;
  late double _minDragStartEdge;
  late double _maxDragStartEdge;

  late AnimationController _animationController;

  bool _canBeDragged = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _toggleDuration,
    );
  }

  void close() => _animationController.reverse();

  void open() => _animationController.forward();

  void toggle() => _animationController.isCompleted ? close() : open();

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    _maxSlide = screenWidth * 3 / 4;
    _minDragStartEdge = screenWidth * .15;
    _maxDragStartEdge = _maxSlide - 16;

    return Container(
      color: KDrawerColor,
      child: WillPopScope(
        onWillPop: () async {
          if (_animationController.isCompleted) {
            close();

            return false;
          }
          return true;
        },
        child: GestureDetector(
            onHorizontalDragStart: _onDragStart,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: _onDragEnd,
            child: Stack(
              children: [
                HiddenDrawerScreen(closeCallBack: close),
                AnimatedBuilder(
                  animation: _animationController,
                  child: HomeScreen(openCallBack: open),
                  builder: (context, child) {
                    final double animValue = _animationController.value;
                    final slideAmount = _maxSlide * animValue;
                    final contentScale = 1.0 - (0.2 * animValue);

                    final opacityValue = animValue / 10 * 3;
                    final borderRadiusValue = animValue * 50;

                    if (_animationController.isCompleted)
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.light));
                    if (_animationController.isDismissed)
                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                          statusBarIconBrightness: Brightness.dark));
                    return GestureDetector(
                      onTap: () {
                        if (_animationController.isCompleted) {
                          close();
                        }
                      },
                      child: Transform(
                        transform: Matrix4.identity()
                          ..translate(slideAmount)
                          ..scale(contentScale, contentScale),
                        alignment: Alignment.centerLeft,
                        child: AbsorbPointer(
                          absorbing:
                              _animationController.isCompleted ? true : false,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(borderRadiusValue),
                            child: Stack(
                              children: [
                                child!,
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            )),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < _minDragStartEdge;

    bool isDragOpenFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > _maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragOpenFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / _maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    double _kMinFlingVelocity = 365.0;
    if (_animationController.isDismissed && _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      close();
    } else {
      open();
    }
  }
}
