import 'music.dart'; // Ensure the Music model is imported

/// Represents a Playlist containing a list of songs (Music objects).
class Playlist {
  final int id; // ID of the playlist (assuming it's an integer)
  final String name; // Name of the playlist
  final List<Music> songs; // List of songs in the playlist
  final String? description; // Optional description of the playlist

  /// Creates a [Playlist] instance with required [id], [name], [songs], and an optional [description].
  Playlist({
    required this.id, // Include ID in the constructor
    required this.name,
    required this.songs,
    this.description, // Optional field
  });

  /// Creates a [Playlist] instance from a JSON object.
  /// Throws a FormatException if the JSON structure is invalid.
  factory Playlist.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null || json['songs'] == null) {
      throw FormatException("Invalid JSON structure for Playlist: ${json.toString()}");
    }

    // Check if id is an integer and songs is a list
    if (json['id'] is! int) {
      throw FormatException("ID must be an integer: ${json['id']}");
    }

    return Playlist(
      id: json['id'], // Parse the ID from JSON
      name: json['name'],
      songs: (json['songs'] as List)
          .map((songJson) => Music.fromJson(songJson)) // Ensure Music.fromJson is correctly defined
          .toList(),
      description: json['description'], // Include optional description
    );
  }

  /// Converts the [Playlist] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include ID in the JSON
      'name': name,
      'songs': songs.map((song) => song.toJson()).toList(),
      'description': description, // Include optional description
    };
  }
}
