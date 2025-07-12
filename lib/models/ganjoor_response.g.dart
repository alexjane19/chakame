// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ganjoor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GanjoorPoemResponse _$GanjoorPoemResponseFromJson(Map<String, dynamic> json) =>
    GanjoorPoemResponse(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      fullTitle: json['fullTitle'] as String,
      urlSlug: json['urlSlug'] as String,
      fullUrl: json['fullUrl'] as String,
      plainText: json['plainText'] as String,
      htmlText: json['htmlText'] as String,
      sourceName: json['sourceName'] as String,
      sourceUrlSlug: json['sourceUrlSlug'] as String,
      oldTag: json['oldTag'],
      oldTagPageUrl: json['oldTagPageUrl'],
      mixedModeOrder: (json['mixedModeOrder'] as num).toInt(),
      published: json['published'] as bool,
      language: json['language'],
      poemSummary: json['poemSummary'] as String,
      category: json['category'],
      next: json['next'],
      previous: json['previous'],
      verses: (json['verses'] as List<dynamic>)
          .map((e) => GanjoorVerse.fromJson(e as Map<String, dynamic>))
          .toList(),
      recitations: json['recitations'],
      images: json['images'],
      songs: json['songs'],
      comments: json['comments'],
      sections: (json['sections'] as List<dynamic>)
          .map((e) => GanjoorSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      geoDateTags: json['geoDateTags'] as List<dynamic>,
      top6QuotedPoems: json['top6QuotedPoems'] as List<dynamic>,
      sectionIndex: json['sectionIndex'],
      claimedByMultiplePoets: json['claimedByMultiplePoets'] as bool,
      coupletsCount: json['coupletsCount'],
    );

Map<String, dynamic> _$GanjoorPoemResponseToJson(
        GanjoorPoemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fullTitle': instance.fullTitle,
      'urlSlug': instance.urlSlug,
      'fullUrl': instance.fullUrl,
      'plainText': instance.plainText,
      'htmlText': instance.htmlText,
      'sourceName': instance.sourceName,
      'sourceUrlSlug': instance.sourceUrlSlug,
      'oldTag': instance.oldTag,
      'oldTagPageUrl': instance.oldTagPageUrl,
      'mixedModeOrder': instance.mixedModeOrder,
      'published': instance.published,
      'language': instance.language,
      'poemSummary': instance.poemSummary,
      'category': instance.category,
      'next': instance.next,
      'previous': instance.previous,
      'verses': instance.verses,
      'recitations': instance.recitations,
      'images': instance.images,
      'songs': instance.songs,
      'comments': instance.comments,
      'sections': instance.sections,
      'geoDateTags': instance.geoDateTags,
      'top6QuotedPoems': instance.top6QuotedPoems,
      'sectionIndex': instance.sectionIndex,
      'claimedByMultiplePoets': instance.claimedByMultiplePoets,
      'coupletsCount': instance.coupletsCount,
    };

GanjoorVerse _$GanjoorVerseFromJson(Map<String, dynamic> json) => GanjoorVerse(
      id: (json['id'] as num).toInt(),
      vOrder: (json['vOrder'] as num).toInt(),
      coupletIndex: (json['coupletIndex'] as num).toInt(),
      versePosition: (json['versePosition'] as num).toInt(),
      sectionIndex1: (json['sectionIndex1'] as num).toInt(),
      sectionIndex2: json['sectionIndex2'],
      sectionIndex3: json['sectionIndex3'],
      sectionIndex4: json['sectionIndex4'],
      text: json['text'] as String,
      languageId: json['languageId'],
      coupletSummary: json['coupletSummary'] as String?,
    );

Map<String, dynamic> _$GanjoorVerseToJson(GanjoorVerse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vOrder': instance.vOrder,
      'coupletIndex': instance.coupletIndex,
      'versePosition': instance.versePosition,
      'sectionIndex1': instance.sectionIndex1,
      'sectionIndex2': instance.sectionIndex2,
      'sectionIndex3': instance.sectionIndex3,
      'sectionIndex4': instance.sectionIndex4,
      'text': instance.text,
      'languageId': instance.languageId,
      'coupletSummary': instance.coupletSummary,
    };

GanjoorSection _$GanjoorSectionFromJson(Map<String, dynamic> json) =>
    GanjoorSection(
      id: (json['id'] as num).toInt(),
      poemId: (json['poemId'] as num).toInt(),
      poem: json['poem'],
      poetId: (json['poetId'] as num).toInt(),
      poet: json['poet'],
      index: (json['index'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      sectionType: (json['sectionType'] as num).toInt(),
      verseType: (json['verseType'] as num).toInt(),
      ganjoorMetreId: (json['ganjoorMetreId'] as num).toInt(),
      ganjoorMetre:
          GanjoorMetre.fromJson(json['ganjoorMetre'] as Map<String, dynamic>),
      ganjoorMetreRefSectionIndex: json['ganjoorMetreRefSectionIndex'],
      rhymeLetters: json['rhymeLetters'] as String,
      plainText: json['plainText'] as String,
      htmlText: json['htmlText'] as String,
      poemFormat: (json['poemFormat'] as num).toInt(),
      cachedFirstCoupletIndex: (json['cachedFirstCoupletIndex'] as num).toInt(),
      language: json['language'],
      coupletsCount: (json['coupletsCount'] as num).toInt(),
      top6RelatedSections: (json['top6RelatedSections'] as List<dynamic>)
          .map((e) => GanjoorRelatedSection.fromJson(e as Map<String, dynamic>))
          .toList(),
      oldGanjoorMetreId: json['oldGanjoorMetreId'],
      oldRhymeLetters: json['oldRhymeLetters'],
      modified: json['modified'] as bool,
      excerpt: json['excerpt'],
    );

Map<String, dynamic> _$GanjoorSectionToJson(GanjoorSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poemId': instance.poemId,
      'poem': instance.poem,
      'poetId': instance.poetId,
      'poet': instance.poet,
      'index': instance.index,
      'number': instance.number,
      'sectionType': instance.sectionType,
      'verseType': instance.verseType,
      'ganjoorMetreId': instance.ganjoorMetreId,
      'ganjoorMetre': instance.ganjoorMetre,
      'ganjoorMetreRefSectionIndex': instance.ganjoorMetreRefSectionIndex,
      'rhymeLetters': instance.rhymeLetters,
      'plainText': instance.plainText,
      'htmlText': instance.htmlText,
      'poemFormat': instance.poemFormat,
      'cachedFirstCoupletIndex': instance.cachedFirstCoupletIndex,
      'language': instance.language,
      'coupletsCount': instance.coupletsCount,
      'top6RelatedSections': instance.top6RelatedSections,
      'oldGanjoorMetreId': instance.oldGanjoorMetreId,
      'oldRhymeLetters': instance.oldRhymeLetters,
      'modified': instance.modified,
      'excerpt': instance.excerpt,
    };

GanjoorMetre _$GanjoorMetreFromJson(Map<String, dynamic> json) => GanjoorMetre(
      id: (json['id'] as num).toInt(),
      urlSlug: json['urlSlug'],
      rhythm: json['rhythm'] as String,
      name: json['name'],
      description: json['description'],
      verseCount: (json['verseCount'] as num).toInt(),
    );

Map<String, dynamic> _$GanjoorMetreToJson(GanjoorMetre instance) =>
    <String, dynamic>{
      'id': instance.id,
      'urlSlug': instance.urlSlug,
      'rhythm': instance.rhythm,
      'name': instance.name,
      'description': instance.description,
      'verseCount': instance.verseCount,
    };

GanjoorRelatedSection _$GanjoorRelatedSectionFromJson(
        Map<String, dynamic> json) =>
    GanjoorRelatedSection(
      id: (json['id'] as num).toInt(),
      poemId: (json['poemId'] as num).toInt(),
      poem: json['poem'],
      sectionIndex: (json['sectionIndex'] as num).toInt(),
      poetId: (json['poetId'] as num).toInt(),
      relationOrder: (json['relationOrder'] as num).toInt(),
      poetName: json['poetName'] as String,
      poetImageUrl: json['poetImageUrl'] as String,
      fullUrl: json['fullUrl'] as String,
      fullTitle: json['fullTitle'] as String,
      htmlExcerpt: json['htmlExcerpt'] as String,
      targetPoemId: (json['targetPoemId'] as num).toInt(),
      targetSectionIndex: (json['targetSectionIndex'] as num).toInt(),
      poetMorePoemsLikeThisCount:
          (json['poetMorePoemsLikeThisCount'] as num).toInt(),
    );

Map<String, dynamic> _$GanjoorRelatedSectionToJson(
        GanjoorRelatedSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'poemId': instance.poemId,
      'poem': instance.poem,
      'sectionIndex': instance.sectionIndex,
      'poetId': instance.poetId,
      'relationOrder': instance.relationOrder,
      'poetName': instance.poetName,
      'poetImageUrl': instance.poetImageUrl,
      'fullUrl': instance.fullUrl,
      'fullTitle': instance.fullTitle,
      'htmlExcerpt': instance.htmlExcerpt,
      'targetPoemId': instance.targetPoemId,
      'targetSectionIndex': instance.targetSectionIndex,
      'poetMorePoemsLikeThisCount': instance.poetMorePoemsLikeThisCount,
    };

GanjoorCategory _$GanjoorCategoryFromJson(Map<String, dynamic> json) =>
    GanjoorCategory(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      fullUrl: json['fullUrl'] as String,
    );

Map<String, dynamic> _$GanjoorCategoryToJson(GanjoorCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'fullUrl': instance.fullUrl,
    };

GanjoorPoet _$GanjoorPoetFromJson(Map<String, dynamic> json) => GanjoorPoet(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String,
      fullUrl: json['fullUrl'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$GanjoorPoetToJson(GanjoorPoet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'fullUrl': instance.fullUrl,
      'imageUrl': instance.imageUrl,
    };

GanjoorPoetsResponse _$GanjoorPoetsResponseFromJson(
        Map<String, dynamic> json) =>
    GanjoorPoetsResponse(
      poets: (json['poets'] as List<dynamic>)
          .map((e) => Poet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GanjoorPoetsResponseToJson(
        GanjoorPoetsResponse instance) =>
    <String, dynamic>{
      'poets': instance.poets,
    };
