import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/current_song_notifier.dart';
import '../../../../core/utils.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFavoriteSongsProvider).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const UploadSongPage(),
                      ));
                    },
                    leading: const Icon(CupertinoIcons.plus),
                    title: const Text("Upload New Song"),
                  );
                }
                final song = data[index];
                return ListTile(
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.thumbnailUrl),
                  ),
                  title: Text(song.songName),
                  subtitle: Text(song.artist),
                );
              },
            );
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Loader(),
        );
  }
}
