// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ord.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdAdapter extends TypeAdapter<Ord> {
  @override
  final int typeId = 1;

  @override
  Ord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ord(
      idOrd: fields[0] as String,
      startDate: fields[1] as DateTime,
      endDate: fields[2] as DateTime,
      times: (fields[3] as List).cast<String>(),
      history: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
      dailyStatus: (fields[5] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as DateTime, (v as Map).cast<String, int>())),
      notes: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Ord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.idOrd)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate)
      ..writeByte(3)
      ..write(obj.times)
      ..writeByte(4)
      ..write(obj.history)
      ..writeByte(5)
      ..write(obj.dailyStatus)
      ..writeByte(6)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
