import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';
import 'package:seraj_quran/presentation/widgets/roqiaCard.dart';


class RoqiaScreen extends StatefulWidget {
  const RoqiaScreen({super.key});

  @override
  State<RoqiaScreen> createState() => _RoqiaScreenState();
}

class _RoqiaScreenState extends State<RoqiaScreen> {
  late Future<List<Dhikr>> _future;
  String _query = '';
  @override
  void initState() {
    super.initState();
    _future = Future.microtask(() => _load());
  }

  Future<List<Dhikr>> _load() {
    final repo = context.read<AppRepositoryProvider>().roqiaRepository;
    if (_query.trim().isNotEmpty) {
      return repo.searchRoqia(_query.trim());
    }
    return repo.getAllRoqia();
  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('الرقية الشرعية'), centerTitle: true),
        body: Column(
          children: [
          
            Expanded(
              child: FutureBuilder<List<Dhikr>>(
                future: _future,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                 final items = [...snapshot.data!]
  ..sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
                  if (items.isEmpty) {
                    return const Center(
                      child: Text('لا توجد رقية شرعية في هذه الصفحة'),
                    );
                  }
                  return ListView.builder(
                    padding:  EdgeInsets.all(16.w),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        RoqiaCard(dhikr: items[index]),
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

