import 'dart:convert';
import 'dart:io';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/home/models/song_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required File selectedImage,
    required File selectedAudio,
    required String hexCode,
    required String songName,
    required String artist,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${ServerConstants.serverUrl}/song/upload'));

      request
        ..files.addAll([
          await http.MultipartFile.fromPath('song', selectedAudio.path),
          await http.MultipartFile.fromPath('thumbnail', selectedImage.path),
        ])
        ..fields.addAll({
          'artist': artist,
          'song_name': songName,
          'hex_code': hexCode,
        })
        ..headers.addAll({'x-auth-token': token});

      final res = await request.send();
      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllSongs({
    required String token,
  }) async {
    try {
      final res = await http
          .get(Uri.parse('${ServerConstants.serverUrl}/song/list'), headers: {
        'Content-Type': 'application/json',
        'charset': 'utf-8',
        'x-auth-token': token,
      });
      var resBodyMap = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;
      return Right(resBodyMap.map((e) => SongModel.fromMap(e)).toList());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, bool>> favorite(
      {required String token, required String songId}) async {
    try {
      final res = await http.post(
          Uri.parse('${ServerConstants.serverUrl}/song/favorite'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          },
          body: jsonEncode({
            "song_id": songId,
          }));
      var resBodyMap = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as Map<String, dynamic>;
      return Right(resBodyMap['message']);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<SongModel>>> getAllFavoriteSongs({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse('${ServerConstants.serverUrl}/song/list/favorite'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(utf8.decode(res.bodyBytes));
      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;
      return Right(
          resBodyMap.map((e) => SongModel.fromMap(e['song'])).toList());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
