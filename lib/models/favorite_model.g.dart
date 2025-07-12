// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 2;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      poemId: fields[0] as int,
      poemTitle: fields[1] as String,
      poetName: fields[2] as String,
      firstLine: fields[3] as String,
      dateAdded: fields[4] as DateTime,
      poemText: fields[5] as String,
      poetId: fields[6] as int,
      categoryName: fields[7] as String,
      poemUrl: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.poemId)
      ..writeByte(1)
      ..write(obj.poemTitle)
      ..writeByte(2)
      ..write(obj.poetName)
      ..writeByte(3)
      ..write(obj.firstLine)
      ..writeByte(4)
      ..write(obj.dateAdded)
      ..writeByte(5)
      ..write(obj.poemText)
      ..writeByte(6)
      ..write(obj.poetId)
      ..writeByte(7)
      ..write(obj.categoryName)
      ..writeByte(8)
      ..write(obj.poemUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      poemId: (json['poemId'] as num).toInt(),
      poemTitle: json['poemTitle'] as String,
      poetName: json['poetName'] as String,
      firstLine: json['firstLine'] as String,
      dateAdded: DateTime.parse(json['dateAdded'] as String),
      poemText: json['poemText'] as String,
      poetId: (json['poetId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      poemUrl: json['poemUrl'] as String,
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'poemId': instance.poemId,
      'poemTitle': instance.poemTitle,
      'poetName': instance.poetName,
      'firstLine': instance.firstLine,
      'dateAdded': instance.dateAdded.toIso8601String(),
      'poemText': instance.poemText,
      'poetId': instance.poetId,
      'categoryName': instance.categoryName,
      'poemUrl': instance.poemUrl,
    };
