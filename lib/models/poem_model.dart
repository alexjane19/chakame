import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'poem_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class Poem extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'id')
  final int id;

  @HiveField(1)
  @JsonKey(name: 'title')
  final String title;

  @HiveField(2)
  @JsonKey(name: 'plainText')
  final String plainText;

  @HiveField(3)
  @JsonKey(name: 'htmlText')
  final String htmlText;

  @HiveField(4)
  @JsonKey(name: 'poetName')
  final String poetName;

  @HiveField(5)
  @JsonKey(name: 'poetId')
  final int poetId;

  @HiveField(6)
  @JsonKey(name: 'categoryName')
  final String categoryName;

  @HiveField(7)
  @JsonKey(name: 'categoryId')
  final int categoryId;

  @HiveField(8)
  @JsonKey(name: 'poemUrl')
  final String poemUrl;

  @HiveField(9)
  final DateTime? dateAdded;

  @HiveField(10)
  final bool isFavorite;

  @HiveField(11)
  @JsonKey(name: 'verses')
  final List<String> verses;

  Poem({
    required this.id,
    required this.title,
    required this.plainText,
    required this.htmlText,
    required this.poetName,
    required this.poetId,
    required this.categoryName,
    required this.categoryId,
    required this.poemUrl,
    this.dateAdded,
    this.isFavorite = false,
    required this.verses,
  });

  factory Poem.fromJson(Map<String, dynamic> json) => _$PoemFromJson(json);
  Map<String, dynamic> toJson() => _$PoemToJson(this);

  Poem copyWith({
    int? id,
    String? title,
    String? plainText,
    String? htmlText,
    String? poetName,
    int? poetId,
    String? categoryName,
    int? categoryId,
    String? poemUrl,
    DateTime? dateAdded,
    bool? isFavorite,
    List<String>? verses,
  }) {
    return Poem(
      id: id ?? this.id,
      title: title ?? this.title,
      plainText: plainText ?? this.plainText,
      htmlText: htmlText ?? this.htmlText,
      poetName: poetName ?? this.poetName,
      poetId: poetId ?? this.poetId,
      categoryName: categoryName ?? this.categoryName,
      categoryId: categoryId ?? this.categoryId,
      poemUrl: poemUrl ?? this.poemUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      isFavorite: isFavorite ?? this.isFavorite,
      verses: verses ?? this.verses,
    );
  }

  String get firstLine {
    return verses.isNotEmpty ? verses.first.trim() : '';
  }

  @override
  String toString() {
    return 'Poem(id: $id, title: $title, poetName: $poetName, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Poem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}