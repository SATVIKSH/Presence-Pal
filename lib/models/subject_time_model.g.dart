// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_time_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectTimeModelAdapter extends TypeAdapter<SubjectTimeModel> {
  @override
  final int typeId = 1;

  @override
  SubjectTimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectTimeModel(
      subject: fields[0] as SubjectModel,
      startTime: fields[1] as String,
      endTime: fields[2] as String,
      day: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectTimeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.subject)
      ..writeByte(1)
      ..write(obj.startTime)
      ..writeByte(2)
      ..write(obj.endTime)
      ..writeByte(3)
      ..write(obj.day);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectTimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
