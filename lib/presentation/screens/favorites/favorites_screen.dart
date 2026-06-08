import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seraj_quran/domain/entities/entities.dart';
import 'package:seraj_quran/presentation/providers/app/app_repository_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<FavoriteItem>> _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future = context
        .read<AppRepositoryProvider>()
        .favoritesRepository
        .getAllFavorites();
  }

  Future<void> _remove(String id) async {
    await context.read<AppRepositoryProvider>().favoritesRepository.removeFavorite(id);
    setState(() {
      _future = context.read<AppRepositoryProvider>().favoritesRepository.getAllFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة'), centerTitle: true),
      body: FutureBuilder<List<FavoriteItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final favorites = snapshot.data!;
          if (favorites.isEmpty) {
            return const Center(child: Text('لا توجد عناصر مفضلة بعد'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return Card(
                child: ListTile(
                  title: Text(
                    item.content,
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(item.metadata ?? item.type),
                  trailing: IconButton(
                    tooltip: 'Remove',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _remove(item.id),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
