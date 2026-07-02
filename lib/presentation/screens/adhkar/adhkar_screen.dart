import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/widgets/dhikrCard.dart';

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  late Future<List<Dhikr>> _future;

  String _category = AppConstants.adhkarCategories.first;
  String _query = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = _load();
  }

  Future<List<Dhikr>> _load() {
    final repo = context.read<AppRepositoryProvider>().adhkarRepository;

    if (_query.trim().isNotEmpty) {
      return repo.searchAdhkar(_query.trim());
    }

    return repo.getAdhkarByCategory(_category);
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
              'الأذكار',
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
        isTablet?SizedBox():      Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(
                  hintText: 'ابحث في الأذكار',
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
                itemCount: AppConstants.adhkarCategories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = AppConstants.adhkarCategories[index];

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
              child: FutureBuilder<List<Dhikr>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final items = snapshot.data!;

                  if (items.isEmpty) {
                    return const Center(
                      child: Text('لا توجد أذكار في هذا القسم'),
                    );
                  }

                  return Center(
                    child: ConstrainedBox(
                      constraints:
                          const BoxConstraints(maxWidth: 1000),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 12),
                            child: DhikrCard(
                              dhikr: items[index],
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