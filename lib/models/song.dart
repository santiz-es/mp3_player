class Song {
  final String id;      
  final String title;
  final String artist;
  final String duration;
  final String url;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.url,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),       
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      duration: json['duration'] ?? '',
      url: json['url'] ?? '',
    );
  }
}
