import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils.dart';
import '../../models/song_model.dart';

class SongCard extends ConsumerWidget {
  const SongCard({
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
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                  image: NetworkImage(song.thumbnailUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 180,
              child: Text(
                song.songName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 180,
              child: Text(
                song.artist,
                style: const TextStyle(
                  color: Pallete.subtitleText,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
