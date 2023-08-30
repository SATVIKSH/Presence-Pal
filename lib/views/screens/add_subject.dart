import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:presence_pal/boxes/boxes.dart';
import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/res/AppColors.dart';
import 'package:presence_pal/views/widgets/add_subject_container.dart';
import 'package:presence_pal/views/widgets/subjects_list_item.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({super.key});

  @override
  State<AddSubject> createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  addTimeWidget(Widget widget) {}
  void deleteSubject(SubjectModel subject) async {
    await subject.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBackground,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 72,
        title: Text(
          "Add New Subject",
          style: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(color: AppColors.primaryText, fontSize: 28),
        ),
      ),
      backgroundColor: AppColors.primaryBackground,
      body: ValueListenableBuilder(
          valueListenable: Boxes.getData().listenable(),
          builder: (conext, value, child) {
            var subjects = value.values.toList();
            return SingleChildScrollView(
              child: Column(
                children: [
                  const NewSubject(),
                  ...subjects
                      .map((subject) => SubjectsListItem(
                          subject: subject, deleteSubject: deleteSubject))
                      .toList(),
                ],
              ),
            );
          }),
    );
  }
}
