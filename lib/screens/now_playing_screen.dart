import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import '../models/podcast.dart';
import '../widgets/custom_text.dart'; // CustomText widget'ını içe aktar

class NowPlayingScreen extends StatefulWidget {
  final Podcast podcast;

  const NowPlayingScreen({
    super.key,
    required this.podcast,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _currentPosition = 0.0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      await _audioPlayer.setAsset(widget.podcast.audioUrl);
      _duration = _audioPlayer.duration ?? Duration.zero;

      _audioPlayer.positionStream.listen((position) {
        if (mounted) {
          setState(() {
            _position = position;
            _currentPosition = position.inSeconds / _duration.inSeconds;
          });
        }
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted) {
          setState(() {
            _isPlaying = playerState.playing;
          });
        }
      });
    } catch (e) {
      logger.e("Error log", error: 'Test Error');
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1B1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const CustomText(
          text: 'Now Playing',
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Podcast Cover Image
            Expanded(
              flex: 3,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: AssetImage(widget.podcast.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Title and Author
            CustomText(
              text: widget.podcast.title,
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: widget.podcast.author,
              color: Colors.grey[400]!,
              fontSize: 16,
            ),
            const SizedBox(height: 32),

            // Progress Bar
            Column(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.purple,
                    inactiveTrackColor: Colors.grey[800],
                    thumbColor: Colors.purple,
                    trackHeight: 4.0,
                  ),
                  child: Slider(
                    value: _currentPosition.isNaN ? 0.0 : _currentPosition,
                    onChanged: (value) {
                      setState(() {
                        _currentPosition = value;
                        final newPosition = Duration(
                            seconds: (value * _duration.inSeconds).toInt());
                        _audioPlayer.seek(newPosition);
                      });
                    },
                    min: 0.0,
                    max: 1.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: _formatDuration(_position),
                        color: Colors.grey[400]!,
                        fontSize: 14,
                      ),
                      CustomText(
                        text: _formatDuration(_duration),
                        color: Colors.grey[400]!,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous,
                      color: Colors.white, size: 36),
                  onPressed: () {
                    _audioPlayer.seek(Duration.zero);
                  },
                ),
                IconButton(
                  icon: Icon(
                    _isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.purple,
                    size: 64,
                  ),
                  onPressed: () {
                    if (_isPlaying) {
                      _audioPlayer.pause();
                    } else {
                      _audioPlayer.play();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next,
                      color: Colors.white, size: 36),
                  onPressed: () {
                    _audioPlayer.seek(_duration);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
