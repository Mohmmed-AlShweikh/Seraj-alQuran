import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/screens/quran/surah_detail_screen.dart';
import 'package:seraj_quran/presentation/widgets/surahCard.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('القرآن الكريم'), centerTitle: true),

        body: Consumer<QuranProvider>(
          builder: (context, quranProvider, _) {
            if (quranProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final progress = quranProvider.readingProgress;

            final bookmarkedSurah = progress != null
                ? quranProvider.surahs.firstWhere(
                    (s) => s.number == progress.currentSurah,
                  )
                : null;

            final surahs = quranProvider.surahs.where((s) {
              if (_query.isEmpty) {
                return true;
              }

              return s.nameArabic.contains(_query) ||
                  s.number.toString() == _query;
            }).toList();

            Widget searchField() {
              return TextField(
                decoration: InputDecoration(
                  hintText: 'ابحث باسم السورة',

                  prefixIcon: const Icon(Icons.search),

                  filled: true,

                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18.r),

                    borderSide: BorderSide.none,
                  ),

                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),

                onChanged: (value) {
                  setState(() {
                    _query = value;
                  });
                },
              );
            }

            Widget bookmarkCard() {
              if (progress == null) {
                return const SizedBox();
              }

              return InkWell(
                borderRadius: BorderRadius.circular(18.r),

                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) => SurahDetailScreen(
                        surah: bookmarkedSurah!,
                        initialPage: progress.currentPage,
                      ),
                    ),
                  );
                },

                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,

                    vertical: isLandscape ? 10.h : 16.h,
                  ),

                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: .08),

                    borderRadius: BorderRadius.circular(18.r),
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: isLandscape ? 38.w : 50.w,

                        height: isLandscape ? 38.w : 50.w,

                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,

                          shape: BoxShape.circle,
                        ),

                        child: Icon(
                          Icons.bookmark,

                          color: Colors.white,

                          size: isLandscape ? 18.sp : 24.sp,
                        ),
                      ),

                      SizedBox(width: 10.w),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              'العلامة',

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontWeight: FontWeight.bold,

                                fontSize: isLandscape ? 13.sp : 17.sp,
                              ),
                            ),

                            Text(
                              '${bookmarkedSurah!.nameArabic} • ${progress.currentAyah}',

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: isLandscape ? 10.sp : 13.sp,

                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(Icons.arrow_back_ios, size: 16.sp),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.all(12.w),

              child: Column(
                children: [
                  if (isLandscape)
                    Row(
                      children: [
                        Expanded(flex: 3, child: searchField()),

                        SizedBox(width: 10.w),

                        Expanded(flex: 2, child: bookmarkCard()),
                      ],
                    )
                  else ...[
                    searchField(),

                    SizedBox(height: 10.h),

                    bookmarkCard(),
                  ],

                  SizedBox(height: 10.h),

                  Expanded(
                    child: isLandscape
                        ? GridView.builder(
                            itemCount: surahs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,

                                  crossAxisSpacing: 8.w,

                                  mainAxisSpacing: 8.h,

                                  childAspectRatio: isLandscape ? 2.2 : 4,
                                ),

                            itemBuilder: (context, index) {
                              return SurahListTile(
                                surah: surahs[index],
                                onTap: () {
                                  Navigator.push(
                                    context,

                                    MaterialPageRoute(
                                      builder: (_) => SurahDetailScreen(
                                        surah: surahs[index],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : ListView.builder(
                            itemCount: surahs.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: SurahListTile(
                                  surah: surahs[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SurahDetailScreen(
                                          surah: surahs[index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
