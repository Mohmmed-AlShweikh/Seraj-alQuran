import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _future = _load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأذكار'), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
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
              height: 44.h,
              child: ListView.separated(
                padding:  EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.adhkarCategories.length,
                separatorBuilder: (_, _) =>  SizedBox(width: 8.w),
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
                    padding:  EdgeInsets.all(16.w),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        DhikrCard(dhikr: items[index]),
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

