import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

/// Verse Model
@JsonSerializable()
class VerseModel {
  @JsonKey(name: 'surah_number')
  final int surahNumber;

  @JsonKey(name: 'ayah_number')
  final int ayahNumber;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'transliteration')
  final String transliteration;

  @JsonKey(name: 'translation')
  final String? translation;

  VerseModel({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.transliteration,
    this.translation,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) =>
      _$VerseModelFromJson(json);

  Map<String, dynamic> toJson() => _$VerseModelToJson(this);
}

/// Surah Model
@JsonSerializable()
class SurahModel {
  @JsonKey(name: 'number')
  final int number;

  @JsonKey(name: 'name_arabic')
  final String nameArabic;

  @JsonKey(name: 'name_english')
  final String nameEnglish;

  @JsonKey(name: 'verse_count')
  final int verseCount;

  @JsonKey(name: 'revelation')
  final String revelation;

  @JsonKey(name: 'meaning')
  final String? meaning;

  @JsonKey(name: 'verses')
  final List<VerseModel> verses;

  SurahModel({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.verseCount,
    required this.revelation,
    this.meaning,
    required this.verses,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) =>
      _$SurahModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurahModelToJson(this);
}

/// Dhikr Model
@JsonSerializable()
class DhikrModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'count')
  final int count;

  @JsonKey(name: 'reference')
  final String? reference;

  @JsonKey(name: 'user_count')
  final int? userCount;

  DhikrModel({
    required this.id,
    required this.text,
    required this.category,
    required this.count,
    this.reference,
    this.userCount,
  });

  factory DhikrModel.fromJson(Map<String, dynamic> json) =>
      _$DhikrModelFromJson(json);

  Map<String, dynamic> toJson() => _$DhikrModelToJson(this);
}

/// Dua Model
@JsonSerializable()
class DuaModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'category')
  final String category;

  @JsonKey(name: 'reference')
  final String? reference;

  @JsonKey(name: 'transliteration')
  final String? transliteration;

  DuaModel({
    required this.id,
    required this.text,
    required this.category,
    this.reference,
    this.transliteration,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) =>
      _$DuaModelFromJson(json);

  Map<String, dynamic> toJson() => _$DuaModelToJson(this);
}

/// Asma Ul Husna Model
@JsonSerializable()
class AsmaNameModel {
  @JsonKey(name: 'number')
  final int number;

  @JsonKey(name: 'name_arabic')
  final String nameArabic;

  @JsonKey(name: 'name_transliteration')
  final String nameTransliteration;

  @JsonKey(name: 'meaning')
  final String meaning;

  @JsonKey(name: 'explanation')
  final String? explanation;

  AsmaNameModel({
    required this.number,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.meaning,
    this.explanation,
  });

  factory AsmaNameModel.fromJson(Map<String, dynamic> json) =>
      _$AsmaNameModelFromJson(json);

  Map<String, dynamic> toJson() => _$AsmaNameModelToJson(this);
}

/// Favorite Item Model
@JsonSerializable()
class FavoriteItemModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'content')
  final String content;

  @JsonKey(name: 'metadata')
  final String? metadata;

  @JsonKey(name: 'added_at')
  final DateTime addedAt;

  FavoriteItemModel({
    required this.id,
    required this.type,
    required this.content,
    this.metadata,
    required this.addedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteItemModelToJson(this);
}

/// Reading Progress Model
@JsonSerializable()
class ReadingProgressModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'current_surah')
  final int currentSurah;

  @JsonKey(name: 'current_ayah')
  final int currentAyah;

  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'last_read_at')
  final DateTime lastReadAt;

  ReadingProgressModel({
    required this.id,
    required this.currentSurah,
    required this.currentAyah,
    required this.currentPage,
    required this.lastReadAt,
  });

  factory ReadingProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ReadingProgressModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReadingProgressModelToJson(this);
}

/// Tasbih Counter Model
@JsonSerializable()
class TasbihCounterModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'text')
  final String text;

  @JsonKey(name: 'target_count')
  final int targetCount;

  @JsonKey(name: 'current_count')
  final int currentCount;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  TasbihCounterModel({
    required this.id,
    required this.text,
    required this.targetCount,
    required this.currentCount,
    required this.createdAt,
    this.completedAt,
  });

  factory TasbihCounterModel.fromJson(Map<String, dynamic> json) =>
      _$TasbihCounterModelFromJson(json);

  Map<String, dynamic> toJson() => _$TasbihCounterModelToJson(this);
}
