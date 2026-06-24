import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/app_theme.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/widgets/nameCard.dart';

class AsmaUlHusnaScreen extends StatefulWidget {
  const AsmaUlHusnaScreen({super.key});

  @override
  State<AsmaUlHusnaScreen> createState() =>
      _AsmaUlHusnaScreenState();
}

class _AsmaUlHusnaScreenState
    extends State<AsmaUlHusnaScreen> {
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

    _debounce = Timer(
      const Duration(milliseconds: 300),
      () {
        if (!mounted) return;

        final repo = context
            .read<AppRepositoryProvider>()
            .asmaUlHusnaRepository;

        setState(() {
          _future = query.trim().isEmpty
              ? repo.getAllNames()
              : repo.searchNames(query.trim());
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = context.isLandscape;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight:
              isLandscape ? 45.h : 56.h,
          centerTitle: true,
          title: Text(
            'أسماء الله الحسنى',
            style: TextStyle(
              fontSize:
                  isLandscape ? 14.sp : 20.sp,
            ),
          ),
        ),
        body: Column(
          children: [
            if (!isLandscape)
              _PageIntro(
                onSearch: _search,
                compact: false,
              ),
            Expanded(
              child: FutureBuilder<List<AsmaName>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child:
                          CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'حدث خطأ أثناء تحميل البيانات',
                      ),
                    );
                  }

                  final names =
                      List<AsmaName>.from(
                    snapshot.data ?? [],
                  )..sort(
                          (a, b) => a.number.compareTo(
                            b.number,
                          ),
                        );

                  return LayoutBuilder(
                    builder: (
                      context,
                      constraints,
                    ) {
                      int crossAxisCount;

                      if (isLandscape) {
                        crossAxisCount =
                            constraints.maxWidth <
                                    1100
                                ? 4
                                : 6;
                      } else {
                        if (constraints.maxWidth <
                            500) {
                          crossAxisCount = 2;
                        } else if (constraints
                                .maxWidth <
                            800) {
                          crossAxisCount = 3;
                        } else {
                          crossAxisCount = 5;
                        }
                      }

                      return GridView.builder(
                        padding:
                            EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        cacheExtent: 500,
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              crossAxisCount,
                          mainAxisSpacing:
                              12.h,
                          crossAxisSpacing:
                              12.w,
                          childAspectRatio:
                              isLandscape
                                  ? 1.30
                                  : 0.92,
                        ),
                        itemCount: names.length,
                        itemBuilder:
                            (context, index) {
                          return RepaintBoundary(
                            child: NameCard(
                              name:
                                  names[index],
                            ),
                          );
                        },
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
      padding: EdgeInsets.fromLTRB(
        16.w,
        compact ? 6.h : 8.h,
        16.w,
        compact ? 4.h : 8.h,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              compact ? 10.w : 18.w,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary
                  .withValues(alpha: 0.10),
              borderRadius:
                  BorderRadius.circular(8.r),
              border: Border.all(
                color: theme
                    .colorScheme.primary
                    .withValues(alpha: 0.16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width:
                      compact ? 40.w : 52.w,
                  height:
                      compact ? 40.h : 52.h,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.primaryColor,
                    borderRadius:
                        BorderRadius.circular(
                      8.r,
                    ),
                  ),
                  child: Icon(
                    Icons
                        .auto_awesome_rounded,
                    color: Colors.white,
                    size: compact
                        ? 22.sp
                        : 30.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'تأمل الأسماء الحسنى',
                        style: compact
                            ? theme.textTheme
                                .titleMedium
                            : theme.textTheme
                                .titleLarge,
                      ),
                      SizedBox(
                          height: 4.h),
                      Text(
                        'تسعة وتسعون اسماً مرتبة بتصميم هادئ وواضح.',
                        maxLines:
                            compact ? 1 : 2,
                        overflow:
                            TextOverflow
                                .ellipsis,
                        style: theme
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: theme
                              .colorScheme
                              .onSurface
                              .withValues(
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
          SizedBox(
            height:
                compact ? 6.h : 12.h,
          ),
          TextField(
            textDirection:
                TextDirection.rtl,
            onChanged: onSearch,
            decoration:
                const InputDecoration(
              hintText:
                  'ابحث في الأسماء',
              prefixIcon:
                  Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}