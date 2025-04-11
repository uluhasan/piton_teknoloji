import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/podcast.dart';

class PodcastService {
  final List<Podcast> _podcasts = [
    Podcast(
      id: '1',
      title: 'Sezen Aksu - Gülümse',
      author: 'Sezen Aksu',
      imageUrl: 'assets/images/sezen_aksu.jpg',
      category: 'Life',
      duration: const Duration(minutes: 4, seconds: 15),
      audioUrl: 'assets/mp3/sezen_aksu.mp3',
    ),
    Podcast(
      id: '2',
      title: 'Tarkan - Kuzu Kuzu',
      author: 'Tarkan',
      imageUrl: 'assets/images/tarkan.jpeg',
      category: 'Comedy',
      duration: const Duration(minutes: 3, seconds: 55),
      audioUrl: 'assets/mp3/tarkan.mp3',
    ),
    Podcast(
      id: '3',
      title: 'Hadise - Farkımız Var',
      author: 'Hadise',
      imageUrl: 'assets/images/hadise.jpg',
      category: 'Tech',
      duration: const Duration(minutes: 3, seconds: 48),
      audioUrl: 'assets/mp3/hadise.mp3',
    ),
    Podcast(
      id: '4',
      title: 'Mabel Matiz - Öyle Kolaysa',
      author: 'Mabel Matiz',
      imageUrl: 'assets/images/mabel_matiz.jpeg',
      category: 'Life',
      duration: const Duration(minutes: 4, seconds: 25),
      audioUrl: 'assets/mp3/mabel_matiz.mp3',
    ),
    Podcast(
      id: '5',
      title: 'Kenan Doğulu - Çakkıdı',
      author: 'Kenan Doğulu',
      imageUrl: 'assets/images/kenan_dogulu.jpg',
      category: 'Comedy',
      duration: const Duration(minutes: 3, seconds: 35),
      audioUrl: 'assets/mp3/kenan_dogulu.mp3',
    ),
    Podcast(
      id: '6',
      title: 'Yıldız Tilbe - Delikanlım',
      author: 'Yıldız Tilbe',
      imageUrl: 'assets/images/yildiz_tilbe.png', 
      category: 'Tech',
      duration: const Duration(minutes: 4, seconds: 12),
      audioUrl: 'assets/mp3/yildiz_tilbe.mp3'
    ),
  ];

  Future<List<Podcast>> getTrendingPodcasts() async {
    return _podcasts;
  }

  Future<List<Podcast>> getPodcastsByCategory(String category) async {
    if (category.toLowerCase() == 'all') {
      return _podcasts;
    }
    return _podcasts
        .where((podcast) => podcast.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  Future<List<Podcast>> searchPodcasts(String query) async {
    return _podcasts
        .where((podcast) =>
            podcast.title.toLowerCase().contains(query.toLowerCase()) ||
            podcast.author.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<Podcast?> getPodcastById(String id) async {
    try {
      return _podcasts.firstWhere((podcast) => podcast.id == id);
    } catch (e) {
      return null;
    }
  }
} 