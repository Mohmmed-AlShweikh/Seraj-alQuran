import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/core/constants/app_constants.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

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
    setState(() => _future = _load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأذكار'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
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
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: AppConstants.adhkarCategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
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
                  return const Center(child: Text('لا توجد أذكار في هذا القسم'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _DhikrCard(dhikr: items[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DhikrCard extends StatefulWidget {
  final Dhikr dhikr;

  const _DhikrCard({required this.dhikr});

  @override
  State<_DhikrCard> createState() => _DhikrCardState();
}

class _DhikrCardState extends State<_DhikrCard> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    final target = widget.dhikr.count <= 0 ? 1 : widget.dhikr.count;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.dhikr.text,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(height: 1.9),
            ),
            if (widget.dhikr.reference != null) ...[
              const SizedBox(height: 12),
              Text(
                widget.dhikr.reference!,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () => setState(() => _count = (_count + 1).clamp(0, target)),
                  icon: const Icon(Icons.add),
                  label: Text('$_count / $target'),
                ),
                const SizedBox(width: 8),
                IconButton.outlined(
                  tooltip: 'Reset',
                  onPressed: () => setState(() => _count = 0),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
