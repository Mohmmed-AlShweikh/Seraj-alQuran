class AppConstants {
  static const String appName = 'سراج القرآن';
  static const String appNameArabic = 'سراج القرآن';
  static const String appVersion = '1.0.0';

  static const String quranBoxName = 'quran_box';
  static const String adhkarBoxName = 'adhkar_box';
  static const String duasBoxName = 'duas_box';
  static const String asmaBoxName = 'asma_ul_husna_box';
  static const String roqiaBoxName = 'roqia_box';
  static const String settingsBoxName = 'settings_box';
  static const String readingProgressBoxName = 'reading_progress_box';
  static const String favoritesBoxName = 'favorites_box';

  static const String themeKey = 'theme_mode';
  static const String fontSizeKey = 'quran_font_size';
  static const String fontFamilyKey = 'font_family';
  static const String arabicFontKey = 'arabic_font';
  static const String lastReadingSurahKey = 'last_reading_surah';
  static const String lastReadingAyahKey = 'last_reading_ayah';
  static const String lastReadingPageKey = 'last_reading_page';

  static const double defaultQuranFontSize = 22.0;
  static const double minQuranFontSize = 16.0;
  static const double maxQuranFontSize = 32.0;
  static const double defaultFontSize = 18.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 28.0;

  static const int totalSurahs = 114;
  static const int totalAyahs = 6236;

  static const List<String> adhkarCategories = [
    'أذكار الصباح',
    'أذكار المساء',
    'أذكار قبل النوم',
    'أذكار الاستيقاظ من النوم',
    'أذكار بعد الصلاة',
    'أذكار يومية',
  ];

  static const List<String> duasCategories = [
    'أدعية قرأنية',
    'أدعية النبي',
    'أدعية السفر',
    'أدعية الرزق',
    'أدعية الضيق',
  ];

  static const int totalAsmaNames = 99;

  static const int shortAnimationDuration = 300;
  static const int mediumAnimationDuration = 500;
  static const int longAnimationDuration = 800;

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;

  static const String arabicFontName = 'UthmanTN1';
  static const String englishFontName = 'UthmanTN1';
}
