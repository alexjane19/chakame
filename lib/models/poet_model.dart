import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poet_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Poet extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String name;

  @HiveField(2)
  @JsonKey(name: 'description')
  final String? description;

  @HiveField(3)
  @JsonKey(name: 'imageUrl')
  final String? imageUrl;

  @HiveField(4)
  @JsonKey(name: 'nickname')
  final String? nickname;

  @HiveField(5)
  @JsonKey(name: 'published')
  final bool published;

  @HiveField(6)
  @JsonKey(name: 'fullUrl')
  final String? fullUrl;

  @HiveField(7)
  @JsonKey(name: 'birthYearInLHijri')
  final int? birthYearInLHijri;

  @HiveField(8)
  @JsonKey(name: 'deathYearInLHijri')
  final int? deathYearInLHijri;

  @HiveField(9)
  @JsonKey(name: 'birthLocation')
  final String? birthLocation;

  @HiveField(10)
  @JsonKey(name: 'deathLocation')
  final String? deathLocation;

  Poet({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.nickname,
    required this.published,
    this.fullUrl,
    this.birthYearInLHijri,
    this.deathYearInLHijri,
    this.birthLocation,
    this.deathLocation,
  });

  factory Poet.fromJson(Map<String, dynamic> json) => _$PoetFromJson(json);
  Map<String, dynamic> toJson() => _$PoetToJson(this);

  String get displayName => nickname ?? name;

  @override
  String toString() {
    return 'Poet(id: $id, name: $name, nickname: $nickname)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Poet && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}