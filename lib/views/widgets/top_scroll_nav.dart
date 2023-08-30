import 'package:flutter/material.dart';
import 'package:presence_pal/res/AppColors.dart';

List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];

class TopScrollNav extends StatefulWidget {
  const TopScrollNav({super.key, required this.day, required this.setDay});
  @override
  State<TopScrollNav> createState() => _TopScrollNavState();
  final String day;
  final void Function(int) setDay;
}

bool isPortrait(context) {
  return MediaQuery.of(context).size.width < MediaQuery.of(context).size.height;
}

class _TopScrollNavState extends State<TopScrollNav> {
  late int index;
  ScrollController scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    index = days.indexOf(widget.day);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.animateTo(index * (screenSize.width * 0.16 + 22) / 4,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    });

    return SizedBox(
      height: isPortrait(context) ? 60 : 50,
      width: screenSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          children: days
              .map((day) => GestureDetector(
                    onTap: () {
                      setState(() {
                        index = days.indexOf(day);
                        widget.setDay(index);
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
                            Text(day,
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
                                        )),
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
