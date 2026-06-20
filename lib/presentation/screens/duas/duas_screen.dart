import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    _future = _load();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الأدعية'), centerTitle: true),
        body: Column(
          children: [
            Padding(
              padding:  EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
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
              height: 44.h,
              child: ListView.separated(
                padding:  EdgeInsets.symmetric(horizontal: 16.w),
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.duasCategories.length,
                separatorBuilder: (_, _) =>  SizedBox(width: 8.w),
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
                    padding:  EdgeInsets.all(16.w),
                    itemCount: duas.length,
                    itemBuilder: (context, index) => DuaCard(dua: duas[index]),
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


