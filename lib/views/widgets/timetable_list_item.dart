import 'package:flutter/material.dart';

import 'package:presence_pal/models/subject_time_model.dart';
import 'package:presence_pal/res/AppColors.dart';
import 'package:presence_pal/views/widgets/wavy_painter.dart';

class TimetableListItem extends StatelessWidget {
  const TimetableListItem({super.key, required this.subject});
  final SubjectTimeModel subject;
  @override
  Widget build(BuildContext context) {
    final percentage = ((subject.subject.total != 0
                ? subject.subject.attended / subject.subject.total
                : 0) *
            100)
        .toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
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
                        subject.subject.name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: AppColors.primaryText,
                            ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        subject.subject.code,
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
                    child: CustomPaint(
                      painter: WavyIndicator(
                          bezier: 0.2,
                          color: AppColors.green,
                          factor: subject.subject.total != 0
                              ? subject.subject.attended / subject.subject.total
                              : 0),
                      child: Center(
                        child: Text(
                          "$percentage%",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: AppColors.primaryText),
                        ),
                      ),
                    ),
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
                    "${subject.startTime}-${subject.endTime}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: AppColors.secondaryText),
                  )
                ],
              ),
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: const Text(
                                "Are you sure you want to remove the subject from timetable"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    "No",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: AppColors.primaryText),
                                  )),
                              TextButton(
                                  onPressed: () async {
                                    await subject.delete();
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                    "Delete",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: Colors.red),
                                  )),
                            ],
                          );
                        });
                  },
                  icon: const Icon(Icons.delete))
            ],
          ),
        ),
      ),
    );
  }
}
