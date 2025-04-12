class Podcast {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final String category;
  final Duration duration;
  final String audioUrl;

  Podcast({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.category,
    required this.duration,
    required this.audioUrl,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      category: json['category'] ?? '',
      duration: Duration(seconds: json['duration'] ?? 0),
      audioUrl: json['audioUrl'] ?? '',
    );
  }
}
