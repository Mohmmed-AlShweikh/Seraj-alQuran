import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = context
        .read<AppRepositoryProvider>()
        .asmaUlHusnaRepository
        .getAllNames();
  }

  void _search(String query) {
    final repo = context.read<AppRepositoryProvider>().asmaUlHusnaRepository;
    setState(() {
      _future = query.trim().isEmpty
          ? repo.getAllNames()
          : repo.searchNames(query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أسماء الله الحسنى'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            _PageIntro(onSearch: _search),
            Expanded(
              child: FutureBuilder<List<AsmaName>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final names = (snapshot.data!)
                    ..sort((a, b) => a.number.compareTo(b.number));
                  return GridView.builder(
                    padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 18.h),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.92,
                        ),
                    itemCount: names.length,
                    itemBuilder: (context, index) =>
                        NameCard(name: names[index]),
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

  const _PageIntro({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:  EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52.w,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                 SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تأمل الأسماء الحسنى',
                        style: theme.textTheme.titleLarge,
                      ),
                       SizedBox(height: 4.h),
                      Text(
                        'تسعة وتسعون اسماً مرتبة بتصميم هادئ وواضح.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.64,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
           SizedBox(height: 12.h),
          TextField(
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              hintText: 'ابحث في الأسماء',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: onSearch,
          ),
        ],
      ),
    );
  }
}



