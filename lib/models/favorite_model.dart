import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'poem_model.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class Favorite extends HiveObject {
  @HiveField(0)
  final int poemId;

  @HiveField(1)
  final String poemTitle;

  @HiveField(2)
  final String poetName;

  @HiveField(3)
  final String firstLine;

  @HiveField(4)
  final DateTime dateAdded;

  @HiveField(5)
  final String poemText;

  @HiveField(6)
  final int poetId;

  @HiveField(7)
  final String categoryName;

  @HiveField(8)
  final String poemUrl;

  Favorite({
    required this.poemId,
    required this.poemTitle,
    required this.poetName,
    required this.firstLine,
    required this.dateAdded,
    required this.poemText,
    required this.poetId,
    required this.categoryName,
    required this.poemUrl,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) => _$FavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);

  factory Favorite.fromPoem(Poem poem) {
    return Favorite(
      poemId: poem.id,
      poemTitle: poem.title,
      poetName: poem.poetName,
      firstLine: poem.firstLine,
      dateAdded: DateTime.now(),
      poemText: poem.plainText,
      poetId: poem.poetId,
      categoryName: poem.categoryName,
      poemUrl: poem.poemUrl,
    );
  }

  @override
  String toString() {
    return 'Favorite(poemId: $poemId, poemTitle: $poemTitle, poetName: $poetName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Favorite && other.poemId == poemId;
  }

  @override
  int get hashCode => poemId.hashCode;
}