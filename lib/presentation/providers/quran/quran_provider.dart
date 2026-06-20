import 'package:flutter/material.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/domain/repositories/repositories.dart';

/// Quran Provider
class QuranProvider extends ChangeNotifier {
  final QuranRepository _repository;

 List<Surah> _surahs = [];
Surah? _currentSurah;
List<Verse> _searchResults = [];
ReadingProgress? _readingProgress;
int _selectedSurahIndex = 0;

  bool _isLoading = true;
  String? _error;

  QuranProvider(this._repository);

  /// Getters
  List<Surah> get surahs => _surahs;
  Surah? get currentSurah => _currentSurah;
  List<Verse> get searchResults => _searchResults;
  ReadingProgress? get readingProgress => _readingProgress;
  int get selectedSurahIndex => _selectedSurahIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize
  Future<void> init() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _surahs = await _repository.getAllSurahs();
      _readingProgress = await _repository.getReadingProgress();

      if (_readingProgress != null) {
        _selectedSurahIndex = _readingProgress!.currentSurah - 1;
        _currentSurah = _surahs[_selectedSurahIndex];
      } else {
        _selectedSurahIndex = 0;
        _currentSurah = _surahs.isNotEmpty ? _surahs[0] : null;
      }

      _searchResults = [];
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  /// Get surah by number
  Future<void> getSurah(int surahNumber) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _currentSurah = await _repository.getSurah(surahNumber);
      _selectedSurahIndex = surahNumber - 1;

      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  /// Search verses
  Future<void> searchVerses(String query) async {
    try {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = await _repository.searchVerses(query);
      }
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Save reading progress
  Future<void> saveReadingProgress(
    int surahNumber,
    int ayahNumber,
    int page,
  ) async {
    try {
      final progress = ReadingProgress(
        id: 'reading_progress',
        currentSurah: surahNumber,
        currentAyah: ayahNumber,
        currentPage: page,
        lastReadAt: DateTime.now(),
      );
      await _repository.saveReadingProgress(progress);
      _readingProgress = progress;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
