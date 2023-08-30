import 'package:flutter/material.dart';
import 'package:presence_pal/boxes/boxes.dart';

import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/res/AppColors.dart';

class NewSubject extends StatefulWidget {
  const NewSubject({super.key});

  @override
  State<NewSubject> createState() => _NewSubjectState();
}

class _NewSubjectState extends State<NewSubject> {
  String? name;
  String? code;
  int? attended;
  int? total;
  final _focusNode1 = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final _focusNode4 = FocusNode();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  final attendedController = TextEditingController();
  final totalController = TextEditingController();
  Future<void> addSubject() async {
    bool isValidated = formKey.currentState!.validate();
    if (!isValidated) {
      return;
    }

    name = nameController.text;
    attended = int.tryParse(attendedController.text);
    total = int.tryParse(totalController.text);
    code = codeController.text;
    if (attended! > total!) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Attended classes cannot be more than total classes')));
      return;
    }

    final data = SubjectModel(
      name: name!,
      attended: attended!,
      total: total!,
      code: code!,
    );
    final box = Boxes.getData();
    box.add(data);
    await data.save();
    formKey.currentState!.reset();
  }

  @override
  void dispose() {
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    nameController.dispose();
    codeController.dispose();
    attendedController.dispose();
    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
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
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: _focusNode1,
                          onTap: () {
                            if (!_focusNode1.hasFocus) {
                              _focusNode1.requestFocus();
                            } else {
                              _focusNode1.unfocus();
                            }
                          },
                          onTapOutside: (event) {
                            _focusNode1.unfocus();
                          },
                          controller: nameController,
                          cursorColor: AppColors.primaryText,
                          decoration: InputDecoration(
                            hintText: "Subject Name",
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: AppColors.secondaryText),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryText),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim() == "") {
                              return "Subject name cannot be empty";
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                focusNode: _focusNode2,
                                onTap: () {
                                  if (!_focusNode2.hasFocus) {
                                    _focusNode2.requestFocus();
                                  } else {
                                    _focusNode2.unfocus();
                                  }
                                },
                                onTapOutside: (event) {
                                  _focusNode2.unfocus();
                                },
                                controller: codeController,
                                cursorColor: AppColors.primaryText,
                                decoration: InputDecoration(
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: AppColors.secondaryText),
                                  hintText: "Subject Code",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primaryText),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim() == "") {
                                    return "Please assign a subject code";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                focusNode: _focusNode3,
                                onTap: () {
                                  if (!_focusNode3.hasFocus) {
                                    _focusNode3.requestFocus();
                                  } else {
                                    _focusNode3.unfocus();
                                  }
                                },
                                onTapOutside: (event) {
                                  _focusNode3.unfocus();
                                },
                                controller: attendedController,
                                cursorColor: AppColors.primaryText,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: "Classes Attended",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: AppColors.secondaryText),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: AppColors.primaryText))),
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
                                focusNode: _focusNode4,
                                onTap: () {
                                  if (!_focusNode4.hasFocus) {
                                    _focusNode4.requestFocus();
                                  } else {
                                    _focusNode4.unfocus();
                                  }
                                },
                                onTapOutside: (event) {
                                  _focusNode4.unfocus();
                                },
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
                                    borderSide: BorderSide(
                                        color: AppColors.primaryText),
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
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryText),
            onPressed: () async {
              await addSubject();
            },
            child: Text(
              "Add Subject",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: AppColors.secondaryBackground),
            ),
          ),
        ],
      ),
    );
  }
}
