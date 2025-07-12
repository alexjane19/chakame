// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PoetAdapter extends TypeAdapter<Poet> {
  @override
  final int typeId = 1;

  @override
  Poet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Poet(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String?,
      imageUrl: fields[3] as String?,
      nickname: fields[4] as String?,
      published: fields[5] as bool,
      fullUrl: fields[6] as String?,
      birthYearInLHijri: fields[7] as int?,
      deathYearInLHijri: fields[8] as int?,
      birthLocation: fields[9] as String?,
      deathLocation: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Poet obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.nickname)
      ..writeByte(5)
      ..write(obj.published)
      ..writeByte(6)
      ..write(obj.fullUrl)
      ..writeByte(7)
      ..write(obj.birthYearInLHijri)
      ..writeByte(8)
      ..write(obj.deathYearInLHijri)
      ..writeByte(9)
      ..write(obj.birthLocation)
      ..writeByte(10)
      ..write(obj.deathLocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PoetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poet _$PoetFromJson(Map<String, dynamic> json) => Poet(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      nickname: json['nickname'] as String?,
      published: json['published'] as bool,
      fullUrl: json['fullUrl'] as String?,
      birthYearInLHijri: (json['birthYearInLHijri'] as num?)?.toInt(),
      deathYearInLHijri: (json['deathYearInLHijri'] as num?)?.toInt(),
      birthLocation: json['birthLocation'] as String?,
      deathLocation: json['deathLocation'] as String?,
    );

Map<String, dynamic> _$PoetToJson(Poet instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'nickname': instance.nickname,
      'published': instance.published,
      'fullUrl': instance.fullUrl,
      'birthYearInLHijri': instance.birthYearInLHijri,
      'deathYearInLHijri': instance.deathYearInLHijri,
      'birthLocation': instance.birthLocation,
      'deathLocation': instance.deathLocation,
    };
