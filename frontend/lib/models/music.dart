/// Represents a Music object with details such as title, artist, album, duration, album cover URL, and audio URL.
class Music {
  final String title; // Title of the song
  final String artist; // Artist of the song
  final String? album; // Album the song belongs to (nullable)
  final String? duration; // Duration of the song (nullable)
  final String? albumCoverUrl; // URL for the album cover image (nullable)
  final String? audioUrl; // URL for the audio file (nullable)

  /// Creates a [Music] instance with required [title], [artist], and optional [album], [duration], [albumCoverUrl], and [audioUrl].
  Music({
    required this.title,
    required this.artist,
    this.album,
    this.duration,
    this.albumCoverUrl,
    this.audioUrl, // Include audioUrl in the constructor
  });

  /// Creates a [Music] instance from a JSON object.
  /// Throws a FormatException if the JSON structure is invalid.
  factory Music.fromJson(Map<String, dynamic> json) {
    if (json['title'] == null || json['artist'] == null) {
      throw const FormatException("Invalid JSON structure for Music");
    }

    return Music(
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      duration: json['duration'],
      albumCoverUrl: json['albumCoverUrl'], // Ensure this matches your API's response
      audioUrl: json['audioUrl'], // Add audioUrl to the parsing
    );
  }

  /// Converts the [Music] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'albumCoverUrl': albumCoverUrl,
      'audioUrl': audioUrl, // Include audio URL in the JSON
    };
  }
}
