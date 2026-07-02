import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/widgets/duaCard.dart';

class DuasScreen extends StatefulWidget {
  const DuasScreen({super.key});

  @override
  State<DuasScreen> createState() => _DuasScreenState();
}

class _DuasScreenState extends State<DuasScreen> {
  late Future<List<Dua>> _future;

  String _category = AppConstants.duasCategories.first;
  String _query = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = _load();
  }

  Future<List<Dua>> _load() {
    final repo = context.read<AppRepositoryProvider>().duasRepository;

    if (_query.trim().isNotEmpty) {
      return repo.searchDuas(_query.trim());
    }

    return repo.getDuasByCategory(_category);
  }

  void _refresh() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1024;
    final isTablet = width >= 600 && width < 1024;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: isDesktop ? 70 : 56,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'الأدعية',
              style: TextStyle(
                fontSize: isDesktop
                    ? 28
                    : isTablet
                        ? 24
                        : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
        isTablet?SizedBox():    Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: 'ابحث في الأدعية',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  _query = value;
                  _refresh();
                },
              ),
            ),

            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: AppConstants.duasCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = AppConstants.duasCategories[index];

                  return ChoiceChip(
                    label: Text(category),
                    selected: _category == category,
                    onSelected: (_) {
                      _category = category;
                      _query = '';
                      _refresh();
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: FutureBuilder<List<Dua>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final duas = snapshot.data!;

                  if (duas.isEmpty) {
                    return const Center(
                      child: Text('لا توجد أدعية في هذا القسم'),
                    );
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 1000),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: duas.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 12),
                            child: DuaCard(
                              dua: duas[index],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}