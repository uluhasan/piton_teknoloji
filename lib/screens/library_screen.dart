import 'package:flutter/material.dart';
import 'package:piton_teknoloji/widgets/custom_text.dart';
import '../models/podcast.dart';
import '../services/podcast_service.dart';
import 'now_playing_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final PodcastService _podcastService = PodcastService();
  List<Podcast> _savedPodcasts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPodcasts();
  }

  Future<void> _loadSavedPodcasts() async {
    final podcasts = await _podcastService.getTrendingPodcasts();
    setState(() {
      _savedPodcasts = podcasts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const CustomText(
          text: "Kitaplığım",
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedPodcasts.isEmpty
              ? const Center(
                  child: CustomText(
                    text: "Henüz kaydedilmiş podcast yok.",
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _savedPodcasts.length,
                  itemBuilder: (context, index) {
                    final podcast = _savedPodcasts[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NowPlayingScreen(podcast: podcast),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                podcast.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: podcast.title,
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text: podcast.author,
                                    color: Colors.grey[400] ?? Colors.green,
                                    fontSize: 14,
                                  ),
                                  const SizedBox(height: 4),
                                  CustomText(
                                    text:
                                        '${podcast.duration.inMinutes}:${(podcast.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                    color: Colors.grey[400] ?? Colors.green,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.play_circle_filled,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NowPlayingScreen(podcast: podcast),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
