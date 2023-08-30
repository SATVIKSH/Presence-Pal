import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:presence_pal/boxes/boxes.dart';

import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/models/subject_time_model.dart';
import 'package:presence_pal/res/AppColors.dart';
import 'package:presence_pal/views/screens/add_subject.dart';

class DropDownAlertSubjects extends StatefulWidget {
  const DropDownAlertSubjects({super.key, required this.day});
  final int day;
  @override
  State<DropDownAlertSubjects> createState() => _DropDownAlertSubjectsState();
}

class _DropDownAlertSubjectsState extends State<DropDownAlertSubjects> {
  final localKey = GlobalKey<FormState>();
  final box = Boxes.getDaysData();
  bool hasSubjectData = false;
  TimeOfDay? start;
  TimeOfDay? end;
  SubjectModel? selectedValue;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.secondaryBackground,
      content: ValueListenableBuilder<Box<SubjectModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, value, child) {
          var data = value.values.toList();
          List<SubjectModel> subjects = [];
          for (int i = 0; i < data.length; i++) {
            subjects.add(data[i]);
          }
          if (subjects.isEmpty) {
            hasSubjectData = false;
          } else {
            hasSubjectData = true;
            selectedValue = subjects[0];
          }
          return subjects.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose Subject",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.primaryText),
                        ),
                        DropdownButton(
                            value: subjects.isNotEmpty ? selectedValue : null,
                            items: subjects
                                .map((e) => DropdownMenuItem<SubjectModel>(
                                      value: e,
                                      child: Text(
                                        subjects.isNotEmpty
                                            ? e.name
                                            : "No subjects added yet",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: AppColors.primaryText),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Choose Time",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: AppColors.primaryText),
                        ),
                      ],
                    ),
                    child!
                  ],
                )
              : Text(
                  "Please add some subjects first",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: AppColors.primaryText),
                );
        },
        child: Form(
          key: localKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 00, minute: 00));
                      setState(() {
                        if (picked != null) {
                          start = picked;
                        }
                      });
                    },
                    child: Text(
                      start != null
                          ? start!.format(context).toString()
                          : "Start Time",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.primaryText),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                          context: context,
                          initialTime: const TimeOfDay(hour: 00, minute: 00));
                      setState(() {
                        if (picked != null) {
                          end = picked;
                        }
                      });
                    },
                    child: Text(
                      end != null
                          ? end!.format(context).toString()
                          : "End Time",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: AppColors.primaryText),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (hasSubjectData)
          TextButton(
              onPressed: () async {
                if (start == null || end == null || selectedValue == null) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please fill all the fields")));
                  return;
                }
                if (start!.hour > end!.hour && start!.period == end!.period) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter correct timings")));
                  return;
                }
                final box = Boxes.getDaysData();
                final data = SubjectTimeModel(
                    subject: selectedValue!,
                    startTime: start!.format(context),
                    endTime: end!.format(context),
                    day: widget.day);
                box.add(data);
                await data.save();
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                "Add",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.primaryText),
              )),
        if (!hasSubjectData)
          TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const AddSubject();
                }));
              },
              child: Text(
                "Add Subject",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.primaryText),
              )),
      ],
    );
  }
}
