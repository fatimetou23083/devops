import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'scholars_page.dart';

class VideoPlayerPage extends StatefulWidget {
  final Video video;
  final PlayList playlist;

  const VideoPlayerPage({
    super.key,
    required this.video,
    required this.playlist,
  });

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _youtubeController;
  VideoPlayerController? _offlineController;
  bool isOffline = false;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      if (widget.video.localPath != null && File(widget.video.localPath!).existsSync()) {
        isOffline = true;
        _offlineController = VideoPlayerController.file(File(widget.video.localPath!));
        await _offlineController!.initialize();
        setState(() => isLoading = false);
      } else if (widget.video.videoId.isNotEmpty) {
        _youtubeController = YoutubePlayerController(
  initialVideoId: YoutubePlayer.convertUrlToId(widget.video.downloadUrl) ?? '',
  flags: const YoutubePlayerFlags(
    autoPlay: true,
    mute: false,
    enableCaption: true,
    forceHD: false,  // جرّب تغيير هذا إلى false
  ),
);

        setState(() => isLoading = false);
      } else {
        setState(() {
          errorMessage = 'عذراً، لا يمكن تشغيل هذا الفيديو';
          isLoading = false;
        });
      }
    } catch (e) {
      print('خطأ في تهيئة مشغل الفيديو: $e');
      setState(() {
        errorMessage = 'حدث خطأ أثناء تحميل الفيديو';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.video.title,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.red,
                      fontFamily: 'Arial',
                    ),
                  ),
                )
              : Column(
                  children: [
                    if (isOffline && _offlineController != null)
                      AspectRatio(
                        aspectRatio: _offlineController!.value.aspectRatio,
                        child: VideoPlayer(_offlineController!),
                      )
                    else if (!isOffline)
                      YoutubePlayer(
                        controller: _youtubeController,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.deepPurple,
                        progressColors: const ProgressBarColors(
                          playedColor: Colors.deepPurple,
                          handleColor: Colors.deepPurpleAccent,
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.video.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),
                    ),
                    if (isOffline)
                      FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            _offlineController!.value.isPlaying
                                ? _offlineController!.pause()
                                : _offlineController!.play();
                          });
                        },
                        child: Icon(
                          _offlineController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                  ],
                ),
    );
  }

  @override
  void dispose() {
    if (isOffline && _offlineController != null) {
      _offlineController!.dispose();
    } else if (!isOffline) {
      _youtubeController.dispose();
    }
    super.dispose();
  }
}