import 'package:flutter/material.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/data/models/category_num_tasks.dart';
import 'package:schedule/presentation/router/app_router.dart';

class CategoryCard extends StatefulWidget {
  final int numAllTasks;
  final String showedTaskWord;
  final String categoryName;
  final Color sliderColor;
  final double sliderProgressValue;
  final Function() onTab;

  const CategoryCard({
    Key? key,
    required this.numAllTasks,
    required this.showedTaskWord,
    required this.categoryName,
    required this.sliderColor,
    required this.sliderProgressValue,
    required this.onTab,
  }) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    _animationController.animateTo(widget.sliderProgressValue);

    return InkWell(
      onTap: widget.onTab,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: KIconColor.withOpacity(0.2),
              offset: const Offset(0, 6),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                '${widget.numAllTasks} ${widget.showedTaskWord}',
                style: const TextStyle(color: KIconColor),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "${widget.categoryName}",
                maxLines: 1,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: KDrawerColor,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
                child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: widget.sliderColor,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
                trackShape: CustomTrackShape(),
                trackHeight: 2,
              ),
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Slider(
                      value: _animationController.value,
                      onChanged: (double value) {},
                    );
                  }),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    _animationController.dispose();
  }

  @override
  void didUpdateWidget(covariant CategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
  }
}

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
