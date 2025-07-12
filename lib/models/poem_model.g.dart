// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poem_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoemAdapter extends TypeAdapter<Poem> {
  @override
  final int typeId = 0;

  @override
  Poem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Poem(
      id: fields[0] as int,
      title: fields[1] as String,
      plainText: fields[2] as String,
      htmlText: fields[3] as String,
      poetName: fields[4] as String,
      poetId: fields[5] as int,
      categoryName: fields[6] as String,
      categoryId: fields[7] as int,
      poemUrl: fields[8] as String,
      dateAdded: fields[9] as DateTime?,
      isFavorite: fields[10] as bool,
      verses: (fields[11] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Poem obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.plainText)
      ..writeByte(3)
      ..write(obj.htmlText)
      ..writeByte(4)
      ..write(obj.poetName)
      ..writeByte(5)
      ..write(obj.poetId)
      ..writeByte(6)
      ..write(obj.categoryName)
      ..writeByte(7)
      ..write(obj.categoryId)
      ..writeByte(8)
      ..write(obj.poemUrl)
      ..writeByte(9)
      ..write(obj.dateAdded)
      ..writeByte(10)
      ..write(obj.isFavorite)
      ..writeByte(11)
      ..write(obj.verses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poem _$PoemFromJson(Map<String, dynamic> json) => Poem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      plainText: json['plainText'] as String,
      htmlText: json['htmlText'] as String,
      poetName: json['poetName'] as String,
      poetId: (json['poetId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      poemUrl: json['poemUrl'] as String,
      dateAdded: json['dateAdded'] == null
          ? null
          : DateTime.parse(json['dateAdded'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      verses:
          (json['verses'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PoemToJson(Poem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'plainText': instance.plainText,
      'htmlText': instance.htmlText,
      'poetName': instance.poetName,
      'poetId': instance.poetId,
      'categoryName': instance.categoryName,
      'categoryId': instance.categoryId,
      'poemUrl': instance.poemUrl,
      'dateAdded': instance.dateAdded?.toIso8601String(),
      'isFavorite': instance.isFavorite,
      'verses': instance.verses,
    };
