import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'scholars_page.dart';

const String apiUrl = "http://10.0.2.2:8000/api/"; // تحديث حسب عنوان السيرفر

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Scholar> scholarsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScholars(); // ✅ تحميل قائمة العلماء عند تشغيل الصفحة
  }

  Future<void> fetchScholars() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}scholars/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['scholars'];
        setState(() {
          scholarsList = data.map((json) {
            List<PlayList> playlists = (json['playlists'] as List).map((playlist) {
              List<Video> videos = (playlist['videos'] as List).map((videoJson) {
                return Video(
                  title: videoJson['title'],
                  videoId: videoJson['video_id'],
                  downloadUrl: videoJson['download_url'] ?? '',
                  isFavorite: videoJson['is_favorite'] ?? false,
                );
              }).toList();
              return PlayList(title: playlist['title'], videos: videos);
            }).toList();

            return Scholar(
              name: json['name'],
              imagePath: json['imagePath'],
              playlists: playlists,
            );
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('⚠ حدث خطأ أثناء تحميل العلماء.');
      }
    } catch (e) {
      print('❌ خطأ في جلب العلماء: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("المفضلة"), backgroundColor: Colors.deepPurple),
        body: const Center(child: CircularProgressIndicator()), // ✅ عرض مؤشر تحميل حتى يتم تحميل العلماء
      );
    }

    List<Video> favoriteVideos = scholarsList.expand((scholar) {
      return scholar.playlists.expand((playlist) {
        return playlist.videos.where((video) => video.isFavorite && video.localPath != null);
      }).toList();
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("المفضلة"), backgroundColor: Colors.deepPurple),
      body: favoriteVideos.isEmpty
          ? const Center(child: Text("لا يوجد فيديوهات مفضلة بعد!"))
          : ListView.builder(
              itemCount: favoriteVideos.length,
              itemBuilder: (context, index) {
                Video video = favoriteVideos[index];
                return ListTile(
                  title: Text(video.title),
                  leading: (video.localPath != null && video.localPath!.isNotEmpty)
                      ? const Icon(Icons.download_done, color: Colors.green)
                      : const Icon(Icons.download, color: Colors.grey),
                  onTap: () {
                    if (video.localPath != null && video.localPath!.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OfflineVideoPlayer(videoPath: video.localPath!),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("⚠ لا يوجد مسار فيديو محلي متاح!")),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

class OfflineVideoPlayer extends StatefulWidget {
  final String videoPath;

  const OfflineVideoPlayer({super.key, required this.videoPath});

  @override
  _OfflineVideoPlayerState createState() => _OfflineVideoPlayerState();
}

class _OfflineVideoPlayerState extends State<OfflineVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("تشغيل الفيديو")),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isInitialized) {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            }
          });
        },
        child: Icon(_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }
}
