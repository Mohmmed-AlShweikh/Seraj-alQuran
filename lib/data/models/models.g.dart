// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseModel _$VerseModelFromJson(Map<String, dynamic> json) => VerseModel(
      surahNumber: (json['surah_number'] as num).toInt(),
      ayahNumber: (json['ayah_number'] as num).toInt(),
      text: json['text'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String?,
    );

Map<String, dynamic> _$VerseModelToJson(VerseModel instance) =>
    <String, dynamic>{
      'surah_number': instance.surahNumber,
      'ayah_number': instance.ayahNumber,
      'text': instance.text,
      'transliteration': instance.transliteration,
      'translation': instance.translation,
    };

SurahModel _$SurahModelFromJson(Map<String, dynamic> json) => SurahModel(
      number: (json['number'] as num).toInt(),
      nameArabic: json['name_arabic'] as String,
      nameEnglish: json['name_english'] as String,
      verseCount: (json['verse_count'] as num).toInt(),
      revelation: json['revelation'] as String,
      meaning: json['meaning'] as String?,
      verses: (json['verses'] as List<dynamic>)
          .map((e) => VerseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SurahModelToJson(SurahModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name_arabic': instance.nameArabic,
      'name_english': instance.nameEnglish,
      'verse_count': instance.verseCount,
      'revelation': instance.revelation,
      'meaning': instance.meaning,
      'verses': instance.verses,
    };

DhikrModel _$DhikrModelFromJson(Map<String, dynamic> json) => DhikrModel(
      id: json['id'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      count: (json['count'] as num).toInt(),
      reference: json['reference'] as String?,
      userCount: (json['user_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DhikrModelToJson(DhikrModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'category': instance.category,
      'count': instance.count,
      'reference': instance.reference,
      'user_count': instance.userCount,
    };

DuaModel _$DuaModelFromJson(Map<String, dynamic> json) => DuaModel(
      id: json['id'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      reference: json['reference'] as String?,
      transliteration: json['transliteration'] as String?,
    );

Map<String, dynamic> _$DuaModelToJson(DuaModel instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'category': instance.category,
      'reference': instance.reference,
      'transliteration': instance.transliteration,
    };

AsmaNameModel _$AsmaNameModelFromJson(Map<String, dynamic> json) =>
    AsmaNameModel(
      number: (json['number'] as num).toInt(),
      nameArabic: json['name_arabic'] as String,
      nameTransliteration: json['name_transliteration'] as String,
      meaning: json['meaning'] as String,
      explanation: json['explanation'] as String?,
    );

Map<String, dynamic> _$AsmaNameModelToJson(AsmaNameModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'name_arabic': instance.nameArabic,
      'name_transliteration': instance.nameTransliteration,
      'meaning': instance.meaning,
      'explanation': instance.explanation,
    };

FavoriteItemModel _$FavoriteItemModelFromJson(Map<String, dynamic> json) =>
    FavoriteItemModel(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      metadata: json['metadata'] as String?,
      addedAt: DateTime.parse(json['added_at'] as String),
    );

Map<String, dynamic> _$FavoriteItemModelToJson(FavoriteItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'content': instance.content,
      'metadata': instance.metadata,
      'added_at': instance.addedAt.toIso8601String(),
    };

ReadingProgressModel _$ReadingProgressModelFromJson(
        Map<String, dynamic> json) =>
    ReadingProgressModel(
      id: json['id'] as String,
      currentSurah: (json['current_surah'] as num).toInt(),
      currentAyah: (json['current_ayah'] as num).toInt(),
      currentPage: (json['current_page'] as num).toInt(),
      lastReadAt: DateTime.parse(json['last_read_at'] as String),
    );

Map<String, dynamic> _$ReadingProgressModelToJson(
        ReadingProgressModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'current_surah': instance.currentSurah,
      'current_ayah': instance.currentAyah,
      'current_page': instance.currentPage,
      'last_read_at': instance.lastReadAt.toIso8601String(),
    };

TasbihCounterModel _$TasbihCounterModelFromJson(Map<String, dynamic> json) =>
    TasbihCounterModel(
      id: json['id'] as String,
      text: json['text'] as String,
      targetCount: (json['target_count'] as num).toInt(),
      currentCount: (json['current_count'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
    );

Map<String, dynamic> _$TasbihCounterModelToJson(TasbihCounterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'target_count': instance.targetCount,
      'current_count': instance.currentCount,
      'created_at': instance.createdAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
    };
