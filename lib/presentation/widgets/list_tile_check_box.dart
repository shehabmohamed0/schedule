import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/models/task.dart';
import 'package:schedule/logic/cubit/tasks/tasks_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListTileCheckBox extends StatefulWidget {
  const ListTileCheckBox(
      {Key? key,
      required this.value,
      required this.color,
      required this.onChanged})
      : super(key: key);
  final bool value;
  final Color color;
  final void Function() onChanged;

  @override
  _ListTileCheckBoxState createState() => _ListTileCheckBoxState();
}

class _ListTileCheckBoxState extends State<ListTileCheckBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  bool shouldAnimate = false;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _colorTween = ColorTween(
      begin: widget.color,
      end: KIconColor.withOpacity(.5),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant ListTileCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value == widget.value) {
      shouldAnimate = false;
    } else {
      shouldAnimate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    /* Here we reset the color tween to apply the change category color
    * when modifying the task because the tween Animation save it's state
    * if we didn't modify this that's happen
    * for example the task color is red that's mean the animation works like following
    * the opacity goes from 1 to 0 and the color tween goes from red to our done color
    * but if we modify the task changing the category the color changed to green for ex
    * the animation tween still goes from red to our done color as it state are saved
    * so we change it if the widget rebuild
    */
    _colorTween = ColorTween(
      begin: widget.color,
      end: KIconColor.withOpacity(.5),
    ).animate(_animationController);

    if (widget.value) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return InkWell(
        onTap: widget.onChanged,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
                animation: _colorTween,
                builder: (context, child) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: shouldAnimate
                          ? _colorTween.value
                          : KIconColor.withOpacity(.5),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16.0,
                      color: Colors.white,
                    ),
                  );
                }),
            AnimatedOpacity(
              opacity: widget.value ? 0 : 1,
              duration: Duration(milliseconds: widget.value ? 0 : 300),
              child: Container(
                padding: EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: widget.value
                      ? null
                      : Border.all(
                          width: 2.5,
                          style: BorderStyle.solid,
                          color: widget.color),
                ),
                child: Icon(
                  Icons.check,
                  size: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ));
  }
}
