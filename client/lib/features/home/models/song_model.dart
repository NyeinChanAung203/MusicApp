import 'dart:convert';

class SongModel {
  final String id;
  final String songName;
  final String artist;
  final String thumbnailUrl;
  final String songUrl;
  final String hexCode;
  SongModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.thumbnailUrl,
    required this.songUrl,
    required this.hexCode,
  });

  SongModel copyWith({
    String? id,
    String? songName,
    String? artist,
    String? thumbnailUrl,
    String? songUrl,
    String? hexCode,
  }) {
    return SongModel(
      id: id ?? this.id,
      songName: songName ?? this.songName,
      artist: artist ?? this.artist,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      songUrl: songUrl ?? this.songUrl,
      hexCode: hexCode ?? this.hexCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'song_name': songName,
      'artist': artist,
      'thumbnail_url': thumbnailUrl,
      'song_url': songUrl,
      'hex_code': hexCode,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map) {
    return SongModel(
      id: map['id'] ?? '',
      songName: map['song_name'] ?? '',
      artist: map['artist'] ?? '',
      thumbnailUrl: map['thumbnail_url'] ?? '',
      songUrl: map['song_url'] ?? '',
      hexCode: map['hex_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SongModel.fromJson(String source) =>
      SongModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SongModel(id: $id, songName: $songName, artist: $artist, thumbnailUrl: $thumbnailUrl, songUrl: $songUrl, hexCode: $hexCode)';
  }

  @override
  bool operator ==(covariant SongModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.songName == songName &&
        other.artist == artist &&
        other.thumbnailUrl == thumbnailUrl &&
        other.songUrl == songUrl &&
        other.hexCode == hexCode;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        songName.hashCode ^
        artist.hashCode ^
        thumbnailUrl.hashCode ^
        songUrl.hashCode ^
        hexCode.hashCode;
  }
}
