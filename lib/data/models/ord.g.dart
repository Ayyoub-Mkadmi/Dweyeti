// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ord.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdAdapter extends TypeAdapter<Ord> {
  @override
  final int typeId = 2;

  @override
  Ord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ord(
      idOrd: fields[0] as String,
      times: (fields[1] as List).cast<String>(),
      notes: fields[2] as String,
      history: (fields[3] as List).cast<dynamic>(),
      startDate: fields[4] as DateTime,
      endDate: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Ord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idOrd)
      ..writeByte(1)
      ..write(obj.times)
      ..writeByte(2)
      ..write(obj.notes)
      ..writeByte(3)
      ..write(obj.history)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate);
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
