/// App-wide constants
class AppConstants {
  /// App Name
  static const String appName = 'سراج القرآن';
  static const String appNameArabic = 'سراج القرآن';

  /// Version
  static const String appVersion = '1.0.0';

  /// Hive Box Names
  static const String quranBoxName = 'quran_box';
  static const String adhkarBoxName = 'adhkar_box';
  static const String duasBoxName = 'duas_box';
  static const String asmaBoxName = 'asma_ul_husna_box';
  static const String roqiaBoxName = 'roqia_box';
  static const String settingsBoxName = 'settings_box';
  static const String readingProgressBoxName = 'reading_progress_box';

  /// Preferences Keys
  static const String themeKey = 'theme_mode';
  static const String fontSizeKey = 'font_size';
  static const String fontFamilyKey = 'font_family';
  static const String arabicFontKey = 'arabic_font';
  static const String lastReadingSurahKey = 'last_reading_surah';
  static const String lastReadingAyahKey = 'last_reading_ayah';
  static const String lastReadingPageKey = 'last_reading_page';

  /// Font Sizes
  static const double defaultFontSize = 18.0;
  static const double minFontSize = 12.0;
  static const double maxFontSize = 28.0;

  /// Quran Constants
  static const int totalSurahs = 114;
  static const int totalAyahs = 6236;

  /// Adhkar Categories
  static const List<String> adhkarCategories = [
    'أذكار الصباح',
    'أذكار المساء',
    'أذكار قبل النوم',
    'أذكار الاستيقاظ من النوم',
    'أذكار بعد الصلاة',
    'أذكار يومية',
  ];

  /// Duas Categories
  static const List<String> duasCategories = [
    'أدعية قرأنية',
    'أدعية النبي',
    'أدعية السفر',
    'أدعية الرزق',
    'أدعية الضيق',
  ];

  /// Asma Ul Husna
  static const int totalAsmaNames = 99;

  /// Animation Durations (milliseconds)
  static const int shortAnimationDuration = 300;
  static const int mediumAnimationDuration = 500;
  static const int longAnimationDuration = 800;

  /// Margins and Paddings
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  /// Border Radius
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;

  /// Font Family Names
  static const String arabicFontName = 'UthmanTN1';
  static const String englishFontName = 'UthmanTN1';
}
