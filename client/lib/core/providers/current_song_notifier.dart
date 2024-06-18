import 'package:client/features/home/models/song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  late HomeLocalRepository _homeLocalRepository;
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;
  @override
  SongModel? build() {
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  bool isPlaying() => _isPlaying;
  AudioPlayer? audioPlayer() => _audioPlayer;

  Future<void> updateSong(SongModel songModel) async {
    await _audioPlayer?.stop();
    _audioPlayer = AudioPlayer();

    final audioSource = AudioSource.uri(
      Uri.parse(songModel.songUrl),
      tag: MediaItem(
        id: songModel.id,
        title: songModel.songName,
        artist: songModel.artist,
        artUri: Uri.parse(songModel.thumbnailUrl),
      ),
    );
    await _audioPlayer!.setAudioSource(audioSource);
    _audioPlayer!.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        _audioPlayer!.seek(Duration.zero);
        _audioPlayer!.pause();
        _isPlaying = false;
        state = state?.copyWith(hexCode: state?.hexCode);
      }
    });
    _audioPlayer!.play();
    _homeLocalRepository.uploadLocalSong(songModel);
    _isPlaying = true;
    state = songModel;
  }

  void playPause() {
    if (_isPlaying) {
      _audioPlayer?.pause();
    } else {
      _audioPlayer?.play();
    }
    _isPlaying = !_isPlaying;
    state = state?.copyWith(hexCode: state?.hexCode);
  }

  void seek(double value) {
    _audioPlayer!.seek(Duration(
        milliseconds:
            (value * _audioPlayer!.duration!.inMilliseconds).toInt()));
  }
}
