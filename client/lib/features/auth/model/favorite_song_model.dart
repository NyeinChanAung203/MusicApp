// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FavoriteSongModel {
  final String id;
  final String songId;
  final String userId;
  FavoriteSongModel({
    required this.id,
    required this.songId,
    required this.userId,
  });

  FavoriteSongModel copyWith({
    String? id,
    String? songId,
    String? userId,
  }) {
    return FavoriteSongModel(
      id: id ?? this.id,
      songId: songId ?? this.songId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_id': songId,
      'user_id': userId,
    };
  }

  factory FavoriteSongModel.fromMap(Map<String, dynamic> map) {
    return FavoriteSongModel(
      id: map['id'] as String,
      songId: map['song_id'] as String,
      userId: map['user_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteSongModel.fromJson(String source) =>
      FavoriteSongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FavoriteSongModel(id: $id, song_id: $songId, user_id: $userId)';

  @override
  bool operator ==(covariant FavoriteSongModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.songId == songId && other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ songId.hashCode ^ userId.hashCode;
}
