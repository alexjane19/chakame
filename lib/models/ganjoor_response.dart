import 'package:json_annotation/json_annotation.dart';
import 'poem_model.dart';
import 'poet_model.dart';

part 'ganjoor_response.g.dart';

@JsonSerializable()
class GanjoorPoemResponse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'fullTitle')
  final String fullTitle;

  @JsonKey(name: 'urlSlug')
  final String urlSlug;

  @JsonKey(name: 'fullUrl')
  final String fullUrl;

  @JsonKey(name: 'plainText')
  final String plainText;

  @JsonKey(name: 'htmlText')
  final String htmlText;

  @JsonKey(name: 'sourceName')
  final String sourceName;

  @JsonKey(name: 'sourceUrlSlug')
  final String sourceUrlSlug;

  @JsonKey(name: 'oldTag')
  final dynamic oldTag;

  @JsonKey(name: 'oldTagPageUrl')
  final dynamic oldTagPageUrl;

  @JsonKey(name: 'mixedModeOrder')
  final int mixedModeOrder;

  @JsonKey(name: 'published')
  final bool published;

  @JsonKey(name: 'language')
  final dynamic language;

  @JsonKey(name: 'poemSummary')
  final String poemSummary;

  @JsonKey(name: 'category')
  final dynamic category;

  @JsonKey(name: 'next')
  final dynamic next;

  @JsonKey(name: 'previous')
  final dynamic previous;

  @JsonKey(name: 'verses')
  final List<GanjoorVerse> verses;

  @JsonKey(name: 'recitations')
  final dynamic recitations;

  @JsonKey(name: 'images')
  final dynamic images;

  @JsonKey(name: 'songs')
  final dynamic songs;

  @JsonKey(name: 'comments')
  final dynamic comments;

  @JsonKey(name: 'sections')
  final List<GanjoorSection> sections;

  @JsonKey(name: 'geoDateTags')
  final List<dynamic> geoDateTags;

  @JsonKey(name: 'top6QuotedPoems')
  final List<dynamic> top6QuotedPoems;

  @JsonKey(name: 'sectionIndex')
  final dynamic sectionIndex;

  @JsonKey(name: 'claimedByMultiplePoets')
  final bool claimedByMultiplePoets;

  @JsonKey(name: 'coupletsCount')
  final dynamic coupletsCount;

  GanjoorPoemResponse({
    required this.id,
    required this.title,
    required this.fullTitle,
    required this.urlSlug,
    required this.fullUrl,
    required this.plainText,
    required this.htmlText,
    required this.sourceName,
    required this.sourceUrlSlug,
    this.oldTag,
    this.oldTagPageUrl,
    required this.mixedModeOrder,
    required this.published,
    this.language,
    required this.poemSummary,
    this.category,
    this.next,
    this.previous,
    required this.verses,
    this.recitations,
    this.images,
    this.songs,
    this.comments,
    required this.sections,
    required this.geoDateTags,
    required this.top6QuotedPoems,
    this.sectionIndex,
    required this.claimedByMultiplePoets,
    this.coupletsCount,
  });

  factory GanjoorPoemResponse.fromJson(Map<String, dynamic> json) => _$GanjoorPoemResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorPoemResponseToJson(this);

  Poem toPoem() {
    // Extract poet ID from the verses or sections if available
    int poetId = 0;
    String poetName = '';
    
    if (sections.isNotEmpty) {
      poetId = sections.first.poetId;
      // We'll need to fetch poet name separately
    }

    // Extract verses text
    final versesText = verses.map((verse) => verse.text).toList();

    return Poem(
      id: id,
      title: title,
      plainText: plainText,
      htmlText: htmlText,
      poetName: poetName, // Will be updated when we fetch poet details
      poetId: poetId,
      categoryName: sourceName, // Using sourceName as category
      categoryId: 0, // Not available in this response
      poemUrl: fullUrl,
      verses: versesText,
    );
  }
}

@JsonSerializable()
class GanjoorVerse {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'vOrder')
  final int vOrder;

  @JsonKey(name: 'coupletIndex')
  final int coupletIndex;

  @JsonKey(name: 'versePosition')
  final int versePosition;

  @JsonKey(name: 'sectionIndex1')
  final int sectionIndex1;

  @JsonKey(name: 'sectionIndex2')
  final dynamic sectionIndex2;

  @JsonKey(name: 'sectionIndex3')
  final dynamic sectionIndex3;

  @JsonKey(name: 'sectionIndex4')
  final dynamic sectionIndex4;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'languageId')
  final dynamic languageId;

  @JsonKey(name: 'coupletSummary')
  final String? coupletSummary;

  GanjoorVerse({
    required this.id,
    required this.vOrder,
    required this.coupletIndex,
    required this.versePosition,
    required this.sectionIndex1,
    this.sectionIndex2,
    this.sectionIndex3,
    this.sectionIndex4,
    required this.text,
    this.languageId,
    this.coupletSummary,
  });

  factory GanjoorVerse.fromJson(Map<String, dynamic> json) => _$GanjoorVerseFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorVerseToJson(this);
}

@JsonSerializable()
class GanjoorSection {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'poemId')
  final int poemId;

  @JsonKey(name: 'poem')
  final dynamic poem;

  @JsonKey(name: 'poetId')
  final int poetId;

  @JsonKey(name: 'poet')
  final dynamic poet;

  @JsonKey(name: 'index')
  final int index;

  @JsonKey(name: 'number')
  final int number;

  @JsonKey(name: 'sectionType')
  final int sectionType;

  @JsonKey(name: 'verseType')
  final int verseType;

  @JsonKey(name: 'ganjoorMetreId')
  final int ganjoorMetreId;

  @JsonKey(name: 'ganjoorMetre')
  final GanjoorMetre ganjoorMetre;

  @JsonKey(name: 'ganjoorMetreRefSectionIndex')
  final dynamic ganjoorMetreRefSectionIndex;

  @JsonKey(name: 'rhymeLetters')
  final String rhymeLetters;

  @JsonKey(name: 'plainText')
  final String plainText;

  @JsonKey(name: 'htmlText')
  final String htmlText;

  @JsonKey(name: 'poemFormat')
  final int poemFormat;

  @JsonKey(name: 'cachedFirstCoupletIndex')
  final int cachedFirstCoupletIndex;

  @JsonKey(name: 'language')
  final dynamic language;

  @JsonKey(name: 'coupletsCount')
  final int coupletsCount;

  @JsonKey(name: 'top6RelatedSections')
  final List<GanjoorRelatedSection> top6RelatedSections;

  @JsonKey(name: 'oldGanjoorMetreId')
  final dynamic oldGanjoorMetreId;

  @JsonKey(name: 'oldRhymeLetters')
  final dynamic oldRhymeLetters;

  @JsonKey(name: 'modified')
  final bool modified;

  @JsonKey(name: 'excerpt')
  final dynamic excerpt;

  GanjoorSection({
    required this.id,
    required this.poemId,
    this.poem,
    required this.poetId,
    this.poet,
    required this.index,
    required this.number,
    required this.sectionType,
    required this.verseType,
    required this.ganjoorMetreId,
    required this.ganjoorMetre,
    this.ganjoorMetreRefSectionIndex,
    required this.rhymeLetters,
    required this.plainText,
    required this.htmlText,
    required this.poemFormat,
    required this.cachedFirstCoupletIndex,
    this.language,
    required this.coupletsCount,
    required this.top6RelatedSections,
    this.oldGanjoorMetreId,
    this.oldRhymeLetters,
    required this.modified,
    this.excerpt,
  });

  factory GanjoorSection.fromJson(Map<String, dynamic> json) => _$GanjoorSectionFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorSectionToJson(this);
}

@JsonSerializable()
class GanjoorMetre {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'urlSlug')
  final dynamic urlSlug;

  @JsonKey(name: 'rhythm')
  final String rhythm;

  @JsonKey(name: 'name')
  final dynamic name;

  @JsonKey(name: 'description')
  final dynamic description;

  @JsonKey(name: 'verseCount')
  final int verseCount;

  GanjoorMetre({
    required this.id,
    this.urlSlug,
    required this.rhythm,
    this.name,
    this.description,
    required this.verseCount,
  });

  factory GanjoorMetre.fromJson(Map<String, dynamic> json) => _$GanjoorMetreFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorMetreToJson(this);
}

@JsonSerializable()
class GanjoorRelatedSection {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'poemId')
  final int poemId;

  @JsonKey(name: 'poem')
  final dynamic poem;

  @JsonKey(name: 'sectionIndex')
  final int sectionIndex;

  @JsonKey(name: 'poetId')
  final int poetId;

  @JsonKey(name: 'relationOrder')
  final int relationOrder;

  @JsonKey(name: 'poetName')
  final String poetName;

  @JsonKey(name: 'poetImageUrl')
  final String poetImageUrl;

  @JsonKey(name: 'fullUrl')
  final String fullUrl;

  @JsonKey(name: 'fullTitle')
  final String fullTitle;

  @JsonKey(name: 'htmlExcerpt')
  final String htmlExcerpt;

  @JsonKey(name: 'targetPoemId')
  final int targetPoemId;

  @JsonKey(name: 'targetSectionIndex')
  final int targetSectionIndex;

  @JsonKey(name: 'poetMorePoemsLikeThisCount')
  final int poetMorePoemsLikeThisCount;

  GanjoorRelatedSection({
    required this.id,
    required this.poemId,
    this.poem,
    required this.sectionIndex,
    required this.poetId,
    required this.relationOrder,
    required this.poetName,
    required this.poetImageUrl,
    required this.fullUrl,
    required this.fullTitle,
    required this.htmlExcerpt,
    required this.targetPoemId,
    required this.targetSectionIndex,
    required this.poetMorePoemsLikeThisCount,
  });

  factory GanjoorRelatedSection.fromJson(Map<String, dynamic> json) => _$GanjoorRelatedSectionFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorRelatedSectionToJson(this);
}

// Keep existing classes for backward compatibility
@JsonSerializable()
class GanjoorCategory {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'title')
  final String title;

  @JsonKey(name: 'fullUrl')
  final String fullUrl;

  GanjoorCategory({
    required this.id,
    required this.title,
    required this.fullUrl,
  });

  factory GanjoorCategory.fromJson(Map<String, dynamic> json) => _$GanjoorCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorCategoryToJson(this);
}

@JsonSerializable()
class GanjoorPoet {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'fullUrl')
  final String fullUrl;

  @JsonKey(name: 'imageUrl')
  final String? imageUrl;

  GanjoorPoet({
    required this.id,
    required this.name,
    required this.description,
    required this.fullUrl,
    this.imageUrl,
  });

  factory GanjoorPoet.fromJson(Map<String, dynamic> json) => _$GanjoorPoetFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorPoetToJson(this);
}

@JsonSerializable()
class GanjoorPoetsResponse {
  @JsonKey(name: 'poets')
  final List<Poet> poets;

  GanjoorPoetsResponse({
    required this.poets,
  });

  factory GanjoorPoetsResponse.fromJson(Map<String, dynamic> json) => _$GanjoorPoetsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GanjoorPoetsResponseToJson(this);
}