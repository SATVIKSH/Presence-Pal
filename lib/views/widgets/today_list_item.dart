import 'package:flutter/material.dart';
import 'package:presence_pal/boxes/boxes.dart';

import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/models/subject_time_model.dart';
import 'package:presence_pal/res/AppColors.dart';
import 'package:presence_pal/views/widgets/edit_subject_alert.dart';
import 'package:presence_pal/views/widgets/wavy_painter.dart';

List<String> days = ['Mon', 'Tues', 'Wed', 'Thurs', 'Fri', 'Sat', 'Sun'];

class TodayListItem extends StatefulWidget {
  const TodayListItem(
      {super.key,
      required this.subject,
      required this.day,
      required this.deleteSubject});
  final SubjectTimeModel subject;
  final String day;
  final void Function(SubjectModel model) deleteSubject;

  @override
  State<TodayListItem> createState() => _TodayListItemState();
}

class _TodayListItemState extends State<TodayListItem>
    with SingleTickerProviderStateMixin {
  late SubjectModel currSubject;
  bool isSelected = false;
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> factorAnimation;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    animation = Tween<double>(begin: -0.2, end: 0.2).animate(controller);
    factorAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
    final box = Boxes.getData();
    final allSubjects = box.values.toList();

    for (int i = 0; i < allSubjects.length; i++) {
      if (allSubjects[i].code == widget.subject.subject.code) {
        currSubject = allSubjects[i];
        break;
      }
    }
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.secondaryBackground,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.subject.subject.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: AppColors.primaryText,
                            ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        widget.subject.subject.code,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: AppColors.secondaryText,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    height: 60,
                    width: 60,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: AppColors.primaryBackground,
                        shape: BoxShape.circle),
                    child: AnimatedBuilder(
                        animation: controller,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: WavyIndicator(
                                bezier: animation.value,
                                color: AppColors.green,
                                factor: widget.subject.subject.total != 0
                                    ? widget.subject.subject.attended *
                                        factorAnimation.value /
                                        widget.subject.subject.total
                                    : 0),
                            child: Center(
                              child: Text(
                                "${((widget.subject.subject.total != 0 ? widget.subject.subject.attended / widget.subject.subject.total : 0) * 100).toStringAsFixed(2)}%",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: AppColors.primaryText),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 8),
                child: Divider(
                  color: AppColors.secondaryText,
                  thickness: 1.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Next Class : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.secondaryText),
                  ),
                  Text(
                    "${widget.subject.startTime}-${widget.subject.endTime}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.secondaryText),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) {
                              return ShowSubjectDetails(
                                  subject: widget.subject.subject);
                            });
                      },
                      icon: const Icon(Icons.edit)),
                  IgnorePointer(
                    ignoring: isSelected,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            currSubject.total = currSubject.total + 1;
                            currSubject.save();

                            isSelected = true;
                          });
                        },
                        icon: Icon(
                          Icons.close,
                          color: isSelected
                              ? AppColors.secondaryText
                              : AppColors.primaryText,
                        )),
                  ),
                  IgnorePointer(
                    ignoring: !isSelected,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            currSubject.total = currSubject.total + 1;
                            currSubject.attended = currSubject.attended + 1;
                            currSubject.save();
                            isSelected = true;
                          });
                        },
                        icon: Icon(
                          Icons.check,
                          color: isSelected
                              ? AppColors.secondaryText
                              : AppColors.primaryText,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
