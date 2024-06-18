import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils.dart';
import '../../models/song_model.dart';

class RecentSongCard extends ConsumerWidget {
  const RecentSongCard({
    super.key,
    required this.song,
  });

  final SongModel song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final currentSong = ref.read(currentSongNotifierProvider);
        if (song.id != currentSong?.id) {
          await ref
              .read(currentSongNotifierProvider.notifier)
              .updateSong(song)
              .then((value) => goToSong(context));
        } else {
          goToSong(context);
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Pallete.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(song.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Flexible(
              child: Text(
                song.songName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Pallete.subtitleText,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
