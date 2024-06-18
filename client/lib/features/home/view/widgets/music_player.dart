import 'package:client/core/providers/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_user_notifier.dart';

class MusicPlayer extends ConsumerWidget {
  const MusicPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongNotifierProvider);
    final songNotifier = ref.watch(currentSongNotifierProvider.notifier);
    final favorites = ref
        .watch(currentUserNotifierProvider.select((value) => value?.favorites));
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dy >= 200) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              stops: const [0.1, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                hexToColor(currentSong!.hexCode),
                Pallete.backgroundColor,
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset(
                  'assets/images/pull-down-arrow.png',
                  color: Pallete.whiteColor,
                )),
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: currentSong.thumbnailUrl,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(currentSong.thumbnailUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.songName,
                                  style: const TextStyle(
                                    color: Pallete.whiteColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  currentSong.artist,
                                  style: const TextStyle(
                                    color: Pallete.subtitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () async => await ref
                                  .read(homeViewModelProvider.notifier)
                                  .toggleFavorite(songId: currentSong.id),
                              icon: favorites!
                                      .where((element) =>
                                          element.songId == currentSong.id)
                                      .toList()
                                      .isNotEmpty
                                  ? const Icon(CupertinoIcons.heart_fill)
                                  : const Icon(CupertinoIcons.heart),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        StreamBuilder(
                          stream: songNotifier.audioPlayer()!.positionStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            }
                            final position = snapshot.data;
                            final duration =
                                songNotifier.audioPlayer()!.duration;
                            double sliderValue = 0.0;
                            if (position != null && duration != null) {
                              sliderValue = position.inMilliseconds /
                                  duration.inMilliseconds;
                            }
                            return StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderThemeData(
                                        activeTrackColor: Pallete.whiteColor,
                                        inactiveTrackColor: Pallete.whiteColor
                                            .withOpacity(0.111),
                                        thumbColor: Pallete.whiteColor,
                                        trackHeight: 4,
                                        overlayShape:
                                            SliderComponentShape.noOverlay,
                                      ),
                                      child: Slider(
                                        value: sliderValue,
                                        onChanged: (v) {
                                          setState(() {
                                            sliderValue = v;
                                          });
                                        },
                                        onChangeEnd: songNotifier.seek,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${position?.inMinutes.toString().padLeft(2, '0')}:${(position!.inSeconds % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: Pallete.subtitleText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        Text(
                                          '${duration?.inMinutes.toString().padLeft(2, '0')}:${(duration!.inMinutes % 60).toString().padLeft(2, '0')}',
                                          style: const TextStyle(
                                            color: Pallete.subtitleText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/shuffle.png',
                              color: Pallete.whiteColor,
                            ),
                            Image.asset(
                              'assets/images/previus-song.png',
                              color: Pallete.whiteColor,
                            ),
                            IconButton(
                                onPressed: songNotifier.playPause,
                                icon: songNotifier.isPlaying()
                                    ? const Icon(
                                        CupertinoIcons.pause_circle_fill,
                                        color: Pallete.whiteColor,
                                        size: 80,
                                      )
                                    : const Icon(
                                        CupertinoIcons.play_circle_fill,
                                        color: Pallete.whiteColor,
                                        size: 80,
                                      )),
                            Image.asset(
                              'assets/images/next-song.png',
                              color: Pallete.whiteColor,
                            ),
                            Image.asset(
                              'assets/images/repeat.png',
                              color: Pallete.whiteColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              'assets/images/connect-device.png',
                              color: Pallete.whiteColor,
                            ),
                            Image.asset(
                              'assets/images/playlist.png',
                              color: Pallete.whiteColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
