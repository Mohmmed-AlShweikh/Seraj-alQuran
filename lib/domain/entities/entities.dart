/// Quran Verse Entity
class Verse {
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String transliteration;
  final String? translation;

  Verse({
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.transliteration,
    this.translation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Verse &&
          runtimeType == other.runtimeType &&
          surahNumber == other.surahNumber &&
          ayahNumber == other.ayahNumber;

  @override
  int get hashCode => surahNumber.hashCode ^ ayahNumber.hashCode;
}

/// Surah Entity
class Surah {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final int verseCount;
  final String revelation; // Meccan or Medinan
  final String? meaning;
  final List<Verse> verses;

  Surah({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.verseCount,
    required this.revelation,
    this.meaning,
    required this.verses,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
}

/// Dhikr Entity
class Dhikr {
  final String id;
  final String text;
  final String category;
  final int count;
  final String? reference;
  final int? userCount;

  Dhikr({
    required this.id,
    required this.text,
    required this.category,
    required this.count,
    this.reference,
    this.userCount,
  });
}

/// Dua Entity
class Dua {
  final String id;
  final String text;
  final String category;
  final String? reference;
  final String? transliteration;

  Dua({
    required this.id,
    required this.text,
    required this.category,
    this.reference,
    this.transliteration,
  });
}

/// Asma Ul Husna Entity
class AsmaName {
  final int number;
  final String nameArabic;
  final String nameTransliteration;
  final String meaning;
  final String? explanation;

  AsmaName({
    required this.number,
    required this.nameArabic,
    required this.nameTransliteration,
    required this.meaning,
    this.explanation,
  });
}

/// Favorite Item Entity (for favorites across all modules)
class FavoriteItem {
  final String id;
  final String type; // 'verse', 'surah', 'dhikr', 'dua', 'asma'
  final String content;
  final String? metadata;
  final DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.type,
    required this.content,
    this.metadata,
    required this.addedAt,
  });
}

/// Reading Progress Entity
class ReadingProgress {
  final String id;
  final int currentSurah;
  final int currentAyah;
  final int currentPage; // For optional page-based reading
  final DateTime lastReadAt;

  ReadingProgress({
    required this.id,
    required this.currentSurah,
    required this.currentAyah,
    required this.currentPage,
    required this.lastReadAt,
  });
}

/// Tasbih Counter Entity
class TasbihCounter {
  final String id;
  final String text;
  final int targetCount;
  final int currentCount;
  final DateTime createdAt;
  final DateTime? completedAt;

  TasbihCounter({
    required this.id,
    required this.text,
    required this.targetCount,
    required this.currentCount,
    required this.createdAt,
    this.completedAt,
  });
}
