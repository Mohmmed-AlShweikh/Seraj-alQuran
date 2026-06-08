import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/data/models/models.dart';
import 'package:seraj_quran/domain/entities/entities.dart';

class QuranLocalDataSource {
  final Box _quranBox;
  List<SurahModel> _surahsCache = [];

  QuranLocalDataSource(this._quranBox);

  Future<void> init() async {
    await _quranBox.clear();
    await _loadQuranFromAssets();
    _loadSurahsCache();
  }

  Future<void> _loadQuranFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/quran.json');
    final jsonData = jsonDecode(jsonString) as List<dynamic>;

    for (final surahData in jsonData) {
      final surah = SurahModel.fromJson(surahData as Map<String, dynamic>);
      await _quranBox.put('surah_${surah.number}', jsonEncode(surah));
    }
  }

  void _loadSurahsCache() {
    _surahsCache = [];
    for (var i = 1; i <= AppConstants.totalSurahs; i++) {
      final data = _quranBox.get('surah_$i');
      if (data != null) {
        _surahsCache.add(SurahModel.fromJson(jsonDecode(data)));
      }
    }
  }

  List<Surah> getAllSurahs() {
    return _surahsCache.map(_modelToEntity).toList();
  }

  Surah? getSurah(int surahNumber) {
    final data = _quranBox.get('surah_$surahNumber');
    if (data == null) return null;
    return _modelToEntity(SurahModel.fromJson(jsonDecode(data)));
  }

  Verse? getVerse(int surahNumber, int ayahNumber) {
    final surah = getSurah(surahNumber);
    if (surah == null) return null;
    for (final verse in surah.verses) {
      if (verse.ayahNumber == ayahNumber) return verse;
    }
    return null;
  }

  List<Verse> searchVerses(String query) {
    final lowerQuery = query.toLowerCase();
    return _surahsCache
        .expand((surah) => surah.verses)
        .where(
          (verse) =>
              verse.text.contains(query) ||
              verse.transliteration.toLowerCase().contains(lowerQuery) ||
              (verse.translation?.toLowerCase().contains(lowerQuery) ?? false),
        )
        .map(_verseModelToEntity)
        .toList();
  }

  ReadingProgress? getReadingProgress() {
    final data = _quranBox.get('reading_progress');
    if (data == null) return null;
    final model = ReadingProgressModel.fromJson(jsonDecode(data));
    return ReadingProgress(
      id: model.id,
      currentSurah: model.currentSurah,
      currentAyah: model.currentAyah,
      currentPage: model.currentPage,
      lastReadAt: model.lastReadAt,
    );
  }

  Future<void> saveReadingProgress(ReadingProgress progress) async {
    final model = ReadingProgressModel(
      id: progress.id,
      currentSurah: progress.currentSurah,
      currentAyah: progress.currentAyah,
      currentPage: progress.currentPage,
      lastReadAt: progress.lastReadAt,
    );
    await _quranBox.put('reading_progress', jsonEncode(model));
  }

  Surah _modelToEntity(SurahModel model) {
    return Surah(
      number: model.number,
      nameArabic: model.nameArabic,
      nameEnglish: model.nameEnglish,
      verseCount: model.verseCount,
      revelation: model.revelation,
      meaning: model.meaning,
      verses: model.verses.map(_verseModelToEntity).toList(),
    );
  }

  Verse _verseModelToEntity(VerseModel model) {
    return Verse(
      surahNumber: model.surahNumber,
      ayahNumber: model.ayahNumber,
      text: model.text,
      transliteration: model.transliteration,
      translation: model.translation,
    );
  }
}
