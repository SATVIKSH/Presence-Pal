import 'package:hive/hive.dart';
part 'subject_model.g.dart';

@HiveType(typeId: 0)
class SubjectModel extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String code;
  @HiveField(2)
  int attended;
  @HiveField(3)
  int total;

  SubjectModel({
    required this.name,
    required this.attended,
    required this.total,
    required this.code,
  });
}
