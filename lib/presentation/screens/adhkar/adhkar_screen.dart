import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/config/theme/responsive.dart';
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
    final landscape = context.isLandscape;

    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: landscape ? 45.h : 56.h,

          title: Text(
            'الأذكار',

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
                        hintText: 'ابحث في الأذكار',

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
              height: landscape ? 35.h : 44.h,

              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.w),

                scrollDirection: Axis.horizontal,

                itemCount: AppConstants.adhkarCategories.length,

                separatorBuilder: (a, b) => SizedBox(width: 6.w),

                itemBuilder: (context, index) {
                  final category = AppConstants.adhkarCategories[index];

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
              child: FutureBuilder<List<Dhikr>>(
                future: _future,

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final items = snapshot.data!;

                  if (items.isEmpty) {
                    return const Center(
                      child: Text('لا توجد أذكار في هذا القسم'),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.all(landscape ? 8.w : 16.w),

                    itemCount: items.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: landscape ? 6.h : 12.h,
                        ),

                        child: DhikrCard(dhikr: items[index]),
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
