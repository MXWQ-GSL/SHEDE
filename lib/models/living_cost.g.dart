// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'living_cost.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LivingCostMonthAdapter extends TypeAdapter<LivingCostMonth> {
  @override
  final int typeId = 8;

  @override
  LivingCostMonth read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LivingCostMonth(
      id: fields[0] as String,
      year: fields[1] as int,
      month: fields[2] as int,
      monthlyBudget: fields[3] as double,
      entries: (fields[4] as List?)?.cast<LivingCostEntry>(),
      createdAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, LivingCostMonth obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.year)
      ..writeByte(2)
      ..write(obj.month)
      ..writeByte(3)
      ..write(obj.monthlyBudget)
      ..writeByte(4)
      ..write(obj.entries)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LivingCostMonthAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LivingCostEntryAdapter extends TypeAdapter<LivingCostEntry> {
  @override
  final int typeId = 9;

  @override
  LivingCostEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LivingCostEntry(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
      category: fields[3] as String,
      date: fields[4] as DateTime,
      note: fields[5] as String?,
      isRecurring: fields[6] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, LivingCostEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.isRecurring);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LivingCostEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
