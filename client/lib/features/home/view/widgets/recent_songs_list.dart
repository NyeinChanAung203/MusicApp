import 'package:client/features/home/view/widgets/recent_song_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodel/home_viewmodel.dart';

class RecentSongList extends ConsumerWidget {
  const RecentSongList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentlySongs =
        ref.watch(homeViewModelProvider.notifier).getRecentlyPlayedSongs();
    return SizedBox(
      height: 280,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: recentlySongs.length,
        itemBuilder: (context, index) {
          final song = recentlySongs[index];
          return RecentSongCard(song: song);
        },
      ),
    );
  }
}
