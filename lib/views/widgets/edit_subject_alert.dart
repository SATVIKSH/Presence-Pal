import 'package:flutter/material.dart';
import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/res/AppColors.dart';

class ShowSubjectDetails extends StatefulWidget {
  const ShowSubjectDetails({super.key, required this.subject});
  final SubjectModel subject;

  @override
  State<ShowSubjectDetails> createState() => _ShowSubjectDetailsState();
}

class _ShowSubjectDetailsState extends State<ShowSubjectDetails> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final attendedController = TextEditingController();
  final totalController = TextEditingController();
  @override
  void dispose() {
    nameController.dispose();
    codeController.dispose();
    attendedController.dispose();
    totalController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    nameController.text = widget.subject.name;
    codeController.text = widget.subject.code;
    attendedController.text = widget.subject.attended.toString();
    totalController.text = widget.subject.total.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BuildContext ctx = context;
    return AlertDialog(
      backgroundColor: AppColors.secondaryBackground,
      title: Text(
        "Edit Subject Details",
        style: Theme.of(context)
            .textTheme
            .bodyLarge!
            .copyWith(color: AppColors.primaryText),
      ),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.subject.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.secondaryText),
                ),
                Text(
                  widget.subject.code,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppColors.secondaryText),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: attendedController,
                        cursorColor: AppColors.primaryText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Classes Attended",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.secondaryText),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.primaryText))),
                        validator: (value) {
                          if (value == null ||
                              value.trim() == "" ||
                              int.tryParse(value) == null) {
                            return "Enter 0 if no classes attended";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 18,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: totalController,
                        cursorColor: AppColors.primaryText,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.secondaryText),
                          hintText: "Total Classes",
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryText),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim() == "" ||
                              int.tryParse(value) == null) {
                            return "Enter 0 if no classes have taken place yet";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.primaryText),
            )),
      ],
    );
  }
}
