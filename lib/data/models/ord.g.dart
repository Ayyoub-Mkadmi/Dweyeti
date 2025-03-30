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
      frequency: fields[1] as String,
      times: (fields[2] as List).cast<String>(),
      notes: fields[3] as String,
      history: (fields[4] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Ord obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idOrd)
      ..writeByte(1)
      ..write(obj.frequency)
      ..writeByte(2)
      ..write(obj.times)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.history);
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
