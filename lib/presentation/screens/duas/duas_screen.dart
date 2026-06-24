import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
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
    final landscape = context.isLandscape;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: landscape ? 45.h : 56.h,

          title: Text(
            'الأدعية',

            style: TextStyle(fontSize: landscape ? 14.sp : 20.sp),
          ),

          centerTitle: true,
        ),

        body: Column(
          children: [
            landscape
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.fromLTRB(
                      12.w,
                      landscape ? 4.h : 8.h,
                      12.w,
                      landscape ? 4.h : 8.h,
                    ),

                    child: TextField(
                      textDirection: TextDirection.rtl,

                      decoration: InputDecoration(
                        hintText: 'ابحث في الأدعية',

                        prefixIcon: const Icon(Icons.search),

                        contentPadding: EdgeInsets.symmetric(
                          vertical: landscape ? 8.h : 14.h,
                        ),
                      ),

                      onChanged: (value) {
                        _query = value;

                        _refresh();
                      },
                    ),
                  ),

            SizedBox(
              height: landscape ? 34.h : 44.h,

              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.w),

                scrollDirection: Axis.horizontal,

                itemCount: AppConstants.duasCategories.length,

                separatorBuilder: (a,b) => SizedBox(width: 6.w),

                itemBuilder: (context, index) {
                  final category = AppConstants.duasCategories[index];

                  return ChoiceChip(
                    label: Text(
                      category,

                      style: TextStyle(fontSize: landscape ? 10.sp : 14.sp),
                    ),

                    selected: _category == category,

                    padding: EdgeInsets.symmetric(
                      horizontal: landscape ? 4.w : 8.w,
                    ),

                    onSelected: (_) {
                      _category = category;

                      _query = '';

                      _refresh();
                    },
                  );
                },
              ),
            ),

            Expanded(
              child: FutureBuilder<List<Dua>>(
                future: _future,

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final duas = snapshot.data!;

                  if (duas.isEmpty) {
                    return const Center(
                      child: Text('لا توجد أدعية في هذا القسم'),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(landscape ? 8.w : 16.w),

                    itemCount: duas.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: landscape ? 6.h : 12.h,
                        ),

                        child: DuaCard(dua: duas[index]),
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
