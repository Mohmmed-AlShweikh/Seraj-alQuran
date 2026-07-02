import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/widgets/nameCard.dart';

class AsmaUlHusnaScreen extends StatefulWidget {
  const AsmaUlHusnaScreen({super.key});

  @override
  State<AsmaUlHusnaScreen> createState() => _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState extends State<AsmaUlHusnaScreen> {
  late Future<List<AsmaName>> _future;
  Timer? _debounce;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _future = context
          .read<AppRepositoryProvider>()
          .asmaUlHusnaRepository
          .getAllNames();

      _initialized = true;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _search(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      final repo =
          context.read<AppRepositoryProvider>().asmaUlHusnaRepository;

      setState(() {
        _future = query.trim().isEmpty
            ? repo.getAllNames()
            : repo.searchNames(query.trim());
      });
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
              'أسماء الله الحسنى',
              maxLines: 1,
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
  isTablet?SizedBox():   _PageIntro(
              onSearch: _search,
              compact: isDesktop,
            ),
            Expanded(
              child: FutureBuilder<List<AsmaName>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('حدث خطأ أثناء تحميل البيانات'),
                    );
                  }

                  final names = List<AsmaName>.from(snapshot.data ?? [])
                    ..sort((a, b) => a.number.compareTo(b.number));

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount;
                      double aspectRatio;

                      if (constraints.maxWidth >= 1400) {
                        crossAxisCount = 6;
                        aspectRatio = 1.15;
                      } else if (constraints.maxWidth >= 1000) {
                        crossAxisCount = 5;
                        aspectRatio = 1.0;
                      } else if (constraints.maxWidth >= 700) {
                        crossAxisCount = 4;
                        aspectRatio = 0.95;
                      } else if (constraints.maxWidth >= 500) {
                        crossAxisCount = 3;
                        aspectRatio = 0.90;
                      } else {
                        crossAxisCount = 2;
                        aspectRatio = 0.70;
                      }

                      return Center(
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: 1400),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: names.length,
                            itemBuilder: (context, index) {
                              return NameCard(name: names[index]);
                            },
                          ),
                        ),
                      );
                    },
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

class _PageIntro extends StatelessWidget {
  final ValueChanged<String> onSearch;
  final bool compact;

  const _PageIntro({
    required this.onSearch,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'تأمل الأسماء الحسنى وابحث بينها بسهولة',
                    style: theme.textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            textDirection: TextDirection.rtl,
            onChanged: onSearch,
            decoration: const InputDecoration(
              hintText: 'ابحث في الأسماء',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}