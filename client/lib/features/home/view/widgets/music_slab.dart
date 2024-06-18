// import 'dart:developer';

import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.watch(currentSongNotifierProvider.notifier);
    final favorites = ref
        .watch(currentUserNotifierProvider.select((value) => value?.favorites));
    if (currentSong == null) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: () {
        goToSong(context);
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(2),
            height: 66,
            decoration: BoxDecoration(
              color: hexToColor(currentSong.hexCode),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: '${currentSong.thumbnailUrl}i',
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 160,
                          child: Text(
                            currentSong.songName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: Text(
                            currentSong.artist,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async => await ref
                          .read(homeViewModelProvider.notifier)
                          .toggleFavorite(songId: currentSong.id),
                      icon: favorites!
                              .where(
                                  (element) => element.songId == currentSong.id)
                              .toList()
                              .isNotEmpty
                          ? const Icon(CupertinoIcons.heart_fill)
                          : const Icon(CupertinoIcons.heart),
                    ),
                    IconButton(
                      onPressed: songNotifier.playPause,
                      icon: songNotifier.isPlaying()
                          ? const Icon(CupertinoIcons.pause_fill)
                          : const Icon(CupertinoIcons.play_fill),
                    )
                  ],
                )
              ],
            ),
          ),
          Positioned(
            bottom: 2,
            left: 10,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          StreamBuilder(
              stream: songNotifier.audioPlayer()?.positionStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox();
                }
                final position = snapshot.data;
                final duration = songNotifier.audioPlayer()!.duration;
                double sliderValue = 0.0;
                if (position != null && duration != null) {
                  sliderValue =
                      position.inMilliseconds / duration.inMilliseconds;
                  // log(position.inMilliseconds.toString());
                  // log(duration.inMilliseconds.toString());
                  // log('------');
                }
                // log(sliderValue.toString());
                return Positioned(
                  bottom: 2,
                  left: 10,
                  child: Container(
                    height: 2,
                    width:
                        sliderValue * (MediaQuery.sizeOf(context).width - 32),
                    decoration: BoxDecoration(
                      color: Pallete.whiteColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
