import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:schedule/core/constants/constants.dart';
import 'package:schedule/presentation/router/app_router.dart';
import 'package:schedule/presentation/screens/hidden_drawer/widgets/hidden_drawer_list_tile.dart';
import 'package:schedule/presentation/screens/hidden_drawer/widgets/line_chart.dart';

class HiddenDrawerScreen extends StatelessWidget {
  const HiddenDrawerScreen({Key? key, required this.closeCallBack})
      : super(key: key);
  final VoidCallback closeCallBack;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingWidth = screenWidth * 0.1;
    final paddingHeight = screenHeight * 0.02;
    final sizedBoxHeightPadding = paddingHeight * 2;
    return Scaffold(
      backgroundColor: KDrawerColor,
      body: SafeArea(
        child: Container(
          width: screenWidth * 3 / 4,
          child: Padding(
            padding: EdgeInsets.only(left: paddingWidth, top: paddingHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircularPercentIndicator(
                      radius: 120,
                      percent: 0.5,
                      lineWidth: 3.5,
                      progressColor: Colors.purpleAccent.shade400,
                      backgroundColor: Color(0xff3C4E7B),
                      circularStrokeCap: CircularStrokeCap.round,
                      animateFromLastPercent: true,
                      animation: true,
                      center: CircleAvatar(
                        radius: 50,
                        child: FlutterLogo(
                          size: 50,
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(color: KIconColor.withOpacity(.7)),
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                        alignment: Alignment.center,
                        onPressed: closeCallBack,
                        icon: Icon(
                          Icons.arrow_back_ios_new_sharp,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                  ],
                ),
                SizedBox(
                  height: sizedBoxHeightPadding,
                ),
                Text(
                  'Joy\nMitchell',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: screenHeight / 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: sizedBoxHeightPadding,
                ),
                HiddenDrawerListTile(
                  icon: Icons.bookmark_border,
                  title: 'Templates',
                ),
                HiddenDrawerListTile(
                  icon: Icons.grid_view,
                  title: 'Categories',
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.categoriesScreen);
                  },
                ),
                HiddenDrawerListTile(
                  icon: Icons.pie_chart_outline,
                  title: 'Analytics',
                ),
                HiddenDrawerListTile(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                ),
                SizedBox(
                    width: screenWidth / 2,
                    height: screenHeight / 7,
                    child: LineChartSample2()),
                Text(
                  'Good',
                  style: TextStyle(color: KIconColor, fontSize: paddingHeight),
                ),
                SizedBox(
                  height: paddingHeight / 2,
                ),
                Text('Consistency',
                    style: TextStyle(
                        color: Colors.white, fontSize: screenHeight / 32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
