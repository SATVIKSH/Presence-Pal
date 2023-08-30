import 'package:flutter/material.dart';

import 'package:presence_pal/res/AppColors.dart';
import 'package:presence_pal/views/widgets/select_days_list.dart';

class DaysListContainer extends StatefulWidget {
  const DaysListContainer(
      {super.key, required this.addTimings, required this.deleteTimings});
  final void Function() addTimings;
  final void Function() deleteTimings;

  @override
  State<DaysListContainer> createState() => _DaysListContainerState();
}

class _DaysListContainerState extends State<DaysListContainer> {
  TimeOfDay? start;
  TimeOfDay? end;
  final startController = TextEditingController();
  final endController = TextEditingController();
  bool isValidated = false;
  String? day;
  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  void selectDay(String selectedDay) {
    setState(() {
      day = selectedDay;
    });
  }

  final localKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          height: 200,
          width: screenSize.width * 0.8,
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.secondaryText),
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: localKey,
              child: Column(
                children: [
                  IgnorePointer(
                    ignoring: isValidated,
                    child: SelectDayList(day: 'mon', selectDay: selectDay),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IgnorePointer(
                        ignoring: isValidated,
                        child: TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 00, minute: 00));
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
                      ),
                      IgnorePointer(
                        ignoring: isValidated,
                        child: TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                                context: context,
                                initialTime:
                                    const TimeOfDay(hour: 00, minute: 00));
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
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(onTap: () {}, child: const Icon(Icons.delete)),
                      if (!isValidated)
                        InkWell(
                            onTap: () {
                              if (day == null ||
                                  start == null ||
                                  end == null ||
                                  start!.hour > end!.hour) {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Day not selected or timings not valid!")));
                                return;
                              }
                            },
                            child: const Icon(Icons.add))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
