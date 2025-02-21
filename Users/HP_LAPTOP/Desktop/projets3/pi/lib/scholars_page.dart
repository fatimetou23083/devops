import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart'; // إضافة مكتبة path_provider
import 'video_player_page.dart';

const String apiUrl = "http://10.0.2.2:8000/api/";

class Video {
  final String title;
  final String videoId;
  bool isFavorite;
  final String downloadUrl;
  String? localPath;

  Video({
    required this.title,
    required this.videoId,
    required this.downloadUrl,
    this.isFavorite = false,
    this.localPath,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      title: json['title'],
      videoId: json['video_id'],
      downloadUrl: json['download_url'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      localPath: json['local_path'],
    );
  }
}

class PlayList {
  final String title;
  final List<Video> videos;

  PlayList({required this.title, required this.videos});
}

class Scholar {
  final String name;
  final String imagePath;
  final List<PlayList> playlists;

  Scholar({required this.name, required this.imagePath, required this.playlists});
}

class ScholarsPage extends StatefulWidget {
  const ScholarsPage({super.key});

  @override
  _ScholarsPageState createState() => _ScholarsPageState();
}

class _ScholarsPageState extends State<ScholarsPage> {
  List<Scholar> scholarsList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchScholars();
  }

  Future<void> fetchScholars() async {
    try {
      final response = await http.get(Uri.parse('${apiUrl}scholars/'));
      print('استجابة الخادم: ${response.statusCode}');
      print('محتوى الاستجابة: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['scholars'];
        setState(() {
          scholarsList = data.map((scholarData) {
            List<PlayList> playlists = (scholarData['playlists'] as List).map((playlistData) {
              List<Video> videos = (playlistData['videos'] as List)
                  .map((videoData) => Video.fromJson(videoData))
                  .toList();
              return PlayList(title: playlistData['title'], videos: videos);
            }).toList();

            return Scholar(
              name: scholarData['name'],
              imagePath: scholarData['imagePath'],
              playlists: playlists,
            );
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('فشل في تحميل بيانات العلماء');
      }
    } catch (e) {
      print('خطأ: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء تحميل بيانات العلماء')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة العلماء', style: TextStyle(fontFamily: 'Arial')),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : scholarsList.isEmpty
              ? const Center(
                  child: Text(
                    'لا يوجد علماء متوفرين حالياً',
                    style: TextStyle(fontSize: 18, fontFamily: 'Arial'),
                  ),
                )
              : ListView.builder(
                  itemCount: scholarsList.length,
                  itemBuilder: (context, index) {
                    final scholar = scholarsList[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      elevation: 3,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(scholar.imagePath),
                          onBackgroundImageError: (_, __) => const Icon(Icons.person),
                        ),
                        title: Text(
                          scholar.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial',
                          ),
                        ),
                        subtitle: Text(
                          'عدد قوائم التشغيل: ${scholar.playlists.length}',
                          style: const TextStyle(fontFamily: 'Arial'),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ScholarDetailsPage(scholar: scholar),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}

class ScholarDetailsPage extends StatefulWidget {
  final Scholar scholar;

  const ScholarDetailsPage({super.key, required this.scholar});

  @override
  _ScholarDetailsPageState createState() => _ScholarDetailsPageState();
}

class _ScholarDetailsPageState extends State<ScholarDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.scholar.name, style: const TextStyle(fontFamily: 'Arial')),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: widget.scholar.playlists.isEmpty
          ? const Center(
              child: Text(
                'لا توجد قوائم تشغيل متوفرة',
                style: TextStyle(fontSize: 18, fontFamily: 'Arial'),
              ),
            )
          : ListView.builder(
              itemCount: widget.scholar.playlists.length,
              itemBuilder: (context, index) {
                final playlist = widget.scholar.playlists[index];
                return ExpansionTile(
                  title: Text(
                    playlist.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Arial',
                    ),
                  ),
                  children: playlist.videos.isEmpty
                      ? [
                          const ListTile(
                            title: Text(
                              'لا توجد فيديوهات في هذه القائمة',
                              style: TextStyle(fontFamily: 'Arial'),
                            ),
                          ),
                        ]
                      : playlist.videos
                          .map((video) => VideoListItem(
                                video: video,
                                playlist: playlist,
                                onFavoriteToggle: () {
                                  setState(() {
                                    video.isFavorite = !video.isFavorite;
                                  });
                                },
                                onDownload: () async {
                                  final directory = await getApplicationDocumentsDirectory();
                                  final filePath = '${directory.path}/${video.videoId}.mp4';
                                  final file = File(filePath);
                                  final response = await http.get(Uri.parse(video.downloadUrl));
                                  await file.writeAsBytes(response.bodyBytes);
                                  setState(() {
                                    video.localPath = filePath;
                                  });
                                },
                              ))
                          .toList(),
                );
              },
            ),
    );
  }
}

class VideoListItem extends StatelessWidget {
  final Video video;
  final PlayList playlist;
  final VoidCallback onFavoriteToggle;
  final Future<void> Function() onDownload;

  const VideoListItem({
    super.key,
    required this.video,
    required this.playlist,
    required this.onFavoriteToggle,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: const Icon(Icons.play_circle_outline, color: Colors.deepPurple),
        title: Text(
          video.title,
          style: const TextStyle(fontFamily: 'Arial'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                video.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: video.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
            IconButton(
              icon: Icon(
                video.localPath != null ? Icons.download_done : Icons.download,
                color: video.localPath != null ? Colors.green : Colors.grey,
              ),
              onPressed: onDownload,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoPlayerPage(
                video: video,
                playlist: playlist,
              ),
            ),
          );
        },
      ),
    );
  }
}