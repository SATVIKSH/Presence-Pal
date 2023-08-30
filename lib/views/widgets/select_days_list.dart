import 'package:flutter/material.dart';
import 'package:presence_pal/res/AppColors.dart';

List<String> days = ['Sun', 'Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat'];

class SelectDayList extends StatefulWidget {
  const SelectDayList({super.key, required this.day, required this.selectDay});
  final void Function(String) selectDay;

  @override
  State<SelectDayList> createState() => _SelectDayListState();
  final String day;
}

bool isPortrait(context) {
  return MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
}

class _SelectDayListState extends State<SelectDayList>
    with SingleTickerProviderStateMixin {
  late int index;
  late AnimationController controller;

  @override
  void initState() {
    index = days.indexOf(widget.day);
    controller = AnimationController(vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: isPortrait(context) ? 60 : 50,
      width: screenSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: days
              .map((day) => GestureDetector(
                    onTap: () {
                      setState(() {
                        index = days.indexOf(day);
                        widget.selectDay(day);
                      });
                    },
                    child: Card(
                      color: days.indexOf(day) == index
                          ? AppColors.primaryText
                          : AppColors.primaryBackground,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: SizedBox(
                        height: screenSize.height * 0.06,
                        width: screenSize.width * 0.16,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              day,
                              style: index == days.indexOf(day)
                                  ? Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: days.indexOf(day) == index
                                            ? AppColors.secondaryBackground
                                            : AppColors.secondaryText,
                                      )
                                  : Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: days.indexOf(day) == index
                                            ? AppColors.secondaryBackground
                                            : AppColors.secondaryText,
                                      ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
