import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('أسماء الله الحسنى'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                hintText: 'ابحث في الأسماء',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AsmaName>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final names = snapshot.data!;
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.25,
                  ),
                  itemCount: names.length,
                  itemBuilder: (context, index) => _NameCard(name: names[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  final AsmaName name;

  const _NameCard({required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${name.number}',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const Spacer(),
            Text(
              name.nameArabic,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              name.nameTransliteration,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              name.meaning,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
