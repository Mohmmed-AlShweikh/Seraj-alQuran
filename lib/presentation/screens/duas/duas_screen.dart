import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

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
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأدعية'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.duasCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                  return const Center(child: Text('لا توجد أدعية في هذا القسم'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: duas.length,
                  itemBuilder: (context, index) => _DuaCard(dua: duas[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DuaCard extends StatelessWidget {
  final Dua dua;

  const _DuaCard({required this.dua});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              dua.text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.9),
            ),
            if (dua.reference != null) ...[
              const SizedBox(height: 12),
              Text(
                dua.reference!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
