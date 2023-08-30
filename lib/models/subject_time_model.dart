import 'package:hive/hive.dart';
import 'package:presence_pal/models/subject_model.dart';
part 'subject_time_model.g.dart';

@HiveType(typeId: 1)
class SubjectTimeModel extends HiveObject {
  @HiveField(0)
  final SubjectModel subject;
  @HiveField(1)
  final String startTime;
  @HiveField(2)
  final String endTime;
  @HiveField(3)
  final int day;
  SubjectTimeModel(
      {required this.subject,
      required this.startTime,
      required this.endTime,
      required this.day});
}
