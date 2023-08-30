import 'package:hive/hive.dart';

import 'package:presence_pal/models/subject_model.dart';
import 'package:presence_pal/models/subject_time_model.dart';

class Boxes {
  static Box<SubjectModel> getData() => Hive.box<SubjectModel>('subjects');
  static Box<SubjectTimeModel> getDaysData() =>
      Hive.box<SubjectTimeModel>('days');
}
