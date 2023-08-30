import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:presence_pal/boxes/boxes.dart';

import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/models/subject_time_model.dart';
import 'package:presence_pal/res/AppColors.dart';
import 'package:presence_pal/views/screens/add_subject.dart';
import 'package:presence_pal/views/widgets/drop_down_subjects.dart';

import 'package:presence_pal/views/widgets/timetable_list_item.dart';
import 'package:presence_pal/views/widgets/today_list_item.dart';
import 'package:presence_pal/views/widgets/top_scroll_nav.dart';

List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  int index = 0;
  int selectedDay = 0;
  TimeOfDay parseTime(String timeString) {
    List<String> timeParts = timeString.split(':');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1].substring(0, 2));
    String period = timeParts[1].substring(2).trim().toLowerCase();

    if (period == 'pm' && hour != 12) {
      hour += 12;
    } else if (period == 'am' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  void setDay(int index) {
    setState(() {
      selectedDay = index;
    });
  }

  List<SubjectTimeModel> sortSubjects(List<SubjectTimeModel> subjects) {
    subjects.sort(
      (a, b) {
        if (parseTime(a.startTime).hour != parseTime(b.startTime).hour) {
          return parseTime(a.startTime)
              .hour
              .compareTo(parseTime(b.startTime).hour);
        } else {
          return parseTime(a.startTime)
              .minute
              .compareTo(parseTime(b.startTime).hour);
        }
      },
    );
    return subjects;
  }

  void deleteSubject(SubjectModel subject) async {
    await subject.delete();
  }

  int currentIndex = 0;
  changeIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  bool isPortrait(context) {
    return MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height;
  }

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween<double>(begin: 100, end: 0).animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String title = "Today's Schedule";
    final now = DateTime.now();
    int today = now.weekday - 1;
    if (currentIndex == 1) {
      title = "Time Table";
    }

    Widget widget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ValueListenableBuilder<Box<SubjectTimeModel>>(
              valueListenable: Boxes.getDaysData().listenable(),
              builder: (context, value, child) {
                var data = value.values.toList();
                List<SubjectTimeModel> subjects = [];
                for (int i = 0; i < data.length; i++) {
                  if (data[i].day == today) {
                    subjects.add(data[i]);
                  }
                }
                if (subjects.isNotEmpty) {
                  subjects = sortSubjects(subjects);
                }
                return ListView.builder(
                    itemCount: subjects.length,
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: controller,
                        builder: (context, child) {
                          return Padding(
                            padding: EdgeInsets.only(
                                top: (animation.value * (index + 4))),
                            child: child,
                          );
                        },
                        child: TodayListItem(
                          subject: subjects[index],
                          day: days[DateTime.now().weekday - 1],
                          deleteSubject: deleteSubject,
                        ),
                      );
                    });
              }),
        ),
      ],
    );

    if (currentIndex == 1) {
      widget = Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TopScrollNav(
                  day: days[selectedDay],
                  setDay: setDay,
                ),
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: Boxes.getDaysData().listenable(),
                      builder: (context, value, child) {
                        var data = value.values.toList();
                        List<SubjectTimeModel> subjects = [];
                        for (int i = 0; i < data.length; i++) {
                          if (data[i].day == selectedDay) {
                            subjects.add(data[i]);
                          }
                        }
                        if (subjects.isNotEmpty) {
                          subjects = sortSubjects(subjects);
                        }
                        return ListView.builder(
                            itemCount: subjects.length,
                            itemBuilder: (context, index) {
                              return TimetableListItem(
                                  subject: subjects[index]);
                            });
                      }),
                ),
              ],
            ),
          ),
          Positioned(
              right: 0,
              left: 0,
              bottom: 2,
              child: FloatingActionButton(
                elevation: 100,
                backgroundColor: AppColors.primaryText,
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return DropDownAlertSubjects(day: selectedDay);
                      });
                },
                child: Icon(Icons.add, color: AppColors.secondaryBackground),
              )),
        ],
      );
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const AddSubject();
                  }));
                },
                icon: const Icon(Icons.book_outlined))
          ],
          toolbarHeight: 72,
          centerTitle: true,
          elevation: 0,
          backgroundColor: AppColors.primaryBackground,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w400,
                fontSize: 28),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          elevation: 0,
          onTap: (index) {
            changeIndex(index);
          },
          selectedItemColor: AppColors.primaryText,
          enableFeedback: true,
          useLegacyColorScheme: false,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
          backgroundColor: AppColors.primaryBackground,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Today",
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_chart), label: "TimeTable"),
          ],
        ),
        backgroundColor: AppColors.primaryBackground,
        body: widget);
  }
}
