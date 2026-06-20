import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('القرآن الكريم'), centerTitle: true),
        body: Consumer<QuranProvider>(
          builder: (context, quranProvider, _) {
            if (quranProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (quranProvider.error != null) {
              return Center(
                child: Padding(
                  padding:  EdgeInsets.all(24.w),
                  child: Text(
                    quranProvider.error!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              );
            }

            final query = _query.trim().toLowerCase();
            final surahs = quranProvider.surahs.where((surah) {
              if (query.isEmpty) return true;
              return surah.number.toString() == query ||
                  surah.nameArabic.contains(_query.trim());
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    textDirection: TextDirection.rtl,
                    decoration: const InputDecoration(
                      hintText: 'ابحث باسم السورة أو رقمها',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => setState(() => _query = value),
                  ),
                ),
                Expanded(
                  child: surahs.isEmpty
                      ? const Center(child: Text('لا توجد نتائج'))
                      : ListView.builder(
                          padding:  EdgeInsets.fromLTRB(12.w, 0, 12.w, 16.h),
                          itemCount: surahs.length,
                          itemBuilder: (context, index) {
                            final surah = surahs[index];
                            return SurahListTile(
                              surah: surah,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SurahDetailScreen(surah: surah),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

