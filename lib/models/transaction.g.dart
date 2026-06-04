// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final int typeId = 3;

  @override
  Transaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Transaction(
      id: fields[0] as String,
      type: fields[1] as TransactionType,
      category: fields[2] as String,
      name: fields[3] as String,
      amount: fields[4] as double,
      dueDate: fields[5] as DateTime,
      cycle: fields[6] as CycleType,
      customCycleDays: fields[7] as int?,
      projectId: fields[8] as String?,
      status: fields[9] as TransactionStatus,
      completedDate: fields[10] as DateTime?,
      note: fields[11] as String?,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.cycle)
      ..writeByte(7)
      ..write(obj.customCycleDays)
      ..writeByte(8)
      ..write(obj.projectId)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.completedDate)
      ..writeByte(11)
      ..write(obj.note)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 0;

  @override
  TransactionType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionType.receivable;
      case 1:
        return TransactionType.payable;
      default:
        return TransactionType.receivable;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    switch (obj) {
      case TransactionType.receivable:
        writer.writeByte(0);
        break;
      case TransactionType.payable:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionStatusAdapter extends TypeAdapter<TransactionStatus> {
  @override
  final int typeId = 1;

  @override
  TransactionStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionStatus.pending;
      case 1:
        return TransactionStatus.completed;
      case 2:
        return TransactionStatus.overdue;
      default:
        return TransactionStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionStatus obj) {
    switch (obj) {
      case TransactionStatus.pending:
        writer.writeByte(0);
        break;
      case TransactionStatus.completed:
        writer.writeByte(1);
        break;
      case TransactionStatus.overdue:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CycleTypeAdapter extends TypeAdapter<CycleType> {
  @override
  final int typeId = 2;

  @override
  CycleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CycleType.once;
      case 1:
        return CycleType.monthly;
      case 2:
        return CycleType.weekly;
      case 3:
        return CycleType.yearly;
      case 4:
        return CycleType.custom;
      default:
        return CycleType.once;
    }
  }

  @override
  void write(BinaryWriter writer, CycleType obj) {
    switch (obj) {
      case CycleType.once:
        writer.writeByte(0);
        break;
      case CycleType.monthly:
        writer.writeByte(1);
        break;
      case CycleType.weekly:
        writer.writeByte(2);
        break;
      case CycleType.yearly:
        writer.writeByte(3);
        break;
      case CycleType.custom:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CycleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
