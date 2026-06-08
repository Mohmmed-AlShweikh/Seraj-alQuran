import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/quran/quran_provider.dart';
import 'package:seraj_quran/presentation/screens/quran/surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('القرآن الكريم'), centerTitle: true),
      body: Consumer<QuranProvider>(
        builder: (context, quranProvider, _) {
          if (quranProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (quranProvider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
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
                surah.nameArabic.contains(_query.trim()) ||
                surah.nameEnglish.toLowerCase().contains(query) ||
                (surah.meaning?.toLowerCase().contains(query) ?? false);
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
    );
  }
}

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final VoidCallback onTap;

  const SurahListTile({required this.surah, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          child: Text('${surah.number}'),
        ),
        title: Text(
          surah.nameArabic,
          style: Theme.of(context).textTheme.titleLarge,
          textDirection: TextDirection.rtl,
        ),
        subtitle: Text('${surah.verseCount} آية • ${surah.revelation}'),
        trailing: Text(
          surah.nameEnglish,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
