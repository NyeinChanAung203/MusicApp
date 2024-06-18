import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/utils.dart';
import 'package:client/features/auth/model/favorite_song_model.dart';
import 'package:client/features/home/repositories/home_local_repository.dart';
import 'package:client/features/home/repositories/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/song_model.dart';

part 'home_viewmodel.g.dart';

@riverpod
FutureOr<List<SongModel>> getAllSongs(GetAllSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((value) => value!.token));
  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token: token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
FutureOr<List<SongModel>> getFavoriteSongs(GetFavoriteSongsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((value) => value!.token));
  final res =
      await ref.watch(homeRepositoryProvider).getAllFavoriteSongs(token: token);
  // print('res $res');
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  late HomeLocalRepository _homeLocalRepository;
  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    _homeLocalRepository = ref.watch(homeLocalRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File thumbnail,
    required File song,
    required String songName,
    required String artist,
    required Color color,
  }) async {
    state = const AsyncLoading();

    final res = await _homeRepository.uploadSong(
      selectedImage: thumbnail,
      selectedAudio: song,
      artist: artist,
      songName: songName,
      hexCode: rbgToHex(color),
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };

    debugPrint('val $val');
  }

  List<SongModel> getRecentlyPlayedSongs() {
    return _homeLocalRepository.loadSongs();
  }

  Future<void> toggleFavorite({
    required String songId,
  }) async {
    state = const AsyncLoading();

    final res = await _homeRepository.favorite(
      songId: songId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => _favSongSuccess(r, songId),
    };

    debugPrint('val $val');
  }

  AsyncValue _favSongSuccess(bool isFavorited, String songId) {
    final userNotifier = ref.read(currentUserNotifierProvider.notifier);
    if (isFavorited) {
      userNotifier
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
        ...ref.read(currentUserNotifierProvider)!.favorites,
        FavoriteSongModel(id: '', songId: songId, userId: ''),
      ]));
    } else {
      userNotifier
          .addUser(ref.read(currentUserNotifierProvider)!.copyWith(favorites: [
        ...ref
            .read(currentUserNotifierProvider)!
            .favorites
            .where((element) => element.songId != songId),
      ]));
    }
    ref.invalidate(getFavoriteSongsProvider);
    return state = AsyncData(isFavorited);
  }
}
