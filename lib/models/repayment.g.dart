// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RepaymentPlanAdapter extends TypeAdapter<RepaymentPlan> {
  @override
  final int typeId = 6;

  @override
  RepaymentPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepaymentPlan(
      id: fields[0] as String,
      name: fields[1] as String,
      totalMonths: fields[2] as int,
      defaultDueDay: fields[3] as int,
      isFixedAmount: fields[4] as bool,
      fixedAmount: fields[5] as double,
      entries: (fields[6] as List?)?.cast<RepaymentEntry>(),
      startDate: fields[7] as DateTime,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RepaymentPlan obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.totalMonths)
      ..writeByte(3)
      ..write(obj.defaultDueDay)
      ..writeByte(4)
      ..write(obj.isFixedAmount)
      ..writeByte(5)
      ..write(obj.fixedAmount)
      ..writeByte(6)
      ..write(obj.entries)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepaymentPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepaymentEntryAdapter extends TypeAdapter<RepaymentEntry> {
  @override
  final int typeId = 7;

  @override
  RepaymentEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RepaymentEntry(
      year: fields[0] as int,
      month: fields[1] as int,
      amount: fields[2] as double,
      dueDay: fields[3] as int,
      isCompleted: fields[4] as bool,
      completedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, RepaymentEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.dueDay)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.completedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepaymentEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
