import 'package:flutter/material.dart';
import 'about_page.dart';
import 'library_page.dart';
import 'favorite.dart';
import 'video_player_page.dart';
import 'scholars_page.dart';
import 'download.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/about': (context) => const AboutPage(),
        '/library': (context) => const LibraryPage(),
        '/scholars': (context) => const ScholarsPage(),
        '/favorites': (context) => const FavoritesPage(),
        '/downloads': (context) => const DownloadsPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];

  final List<String> _books = ["كتاب 1", "كتاب 2", "كتاب 3"];
  final List<String> _videos = ["فيديو 1", "فيديو 2", "فيديو 3"];

  void _search(String query) {
    setState(() {
      _searchResults = [
        ..._books.map((book) => "كتاب: $book"),
        ..._videos.map((video) => "فيديو: $video"),
      ].where((item) => item.contains(query)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("كنوز المعرفة: علماء شنقيط"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن كتاب أو فيديو...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: _search,
            ),
          ),
          if (_searchResults.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white.withOpacity(0.9),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_searchResults[index]),
                      onTap: () {
                        if (_searchResults[index].startsWith("كتاب")) {
                          Navigator.pushNamed(context, '/library');
                        } else if (_searchResults[index].startsWith("فيديو")) {
                          Navigator.pushNamed(context, '/scholars');
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 40,
            mainAxisSpacing: 30,
            children: [
              _buildDashboardItem(
                title: 'الفيديوهات',
                icon: Icons.play_circle_fill,
                background: Colors.deepOrange,
                onTap: () {
                  Navigator.pushNamed(context, '/scholars');
                },
              ),
              _buildDashboardItem(
                title: 'المكتبة',
                icon: Icons.book,
                background: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/library');
                },
              ),
              _buildDashboardItem(
                title: 'من نحن',
                icon: Icons.info,
                background: Colors.green,
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
              ),
              _buildDashboardItem(
                title: 'المفضلة',
                icon: Icons.favorite,
                background: Colors.pinkAccent,
                onTap: () {
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
              _buildDashboardItem(
              title: 'التنزيلات',  // ✅ إضافة التنزيلات
              icon: Icons.download,
              background: Colors.green,
              onTap: () {
                Navigator.pushNamed(context, '/downloads');
              },
            ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardItem({required String title, required IconData icon, required Color background, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              color: Theme.of(context).primaryColor.withOpacity(.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
