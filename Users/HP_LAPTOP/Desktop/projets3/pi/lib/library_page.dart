// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// // ignore: unused_import
// // import 'sidebar.dart'; // Assurez-vous d'importer la Sidebar

// class BookData {
//   final String title;
//   final String imagePath;
//   final String pdfPath;

//   BookData({
//     required this.title,
//     required this.imagePath,
//     required this.pdfPath,
//   });
// }

// class LibraryPage extends StatefulWidget {
//   @override
//   _LibraryPageState createState() => _LibraryPageState();
// }

// class _LibraryPageState extends State<LibraryPage> {
//   bool _isOptionsVisible = false;
//   // ignore: unused_field
//   final PageController _pageController = PageController();

//   final List<BookData> books = [
//     BookData(
//       title: "كتاب 1",
//       imagePath: "assets/images/akh.jpg",
//       pdfPath: "assets/pdfs/akh.pdf",
//     ),
//     BookData(
//       title: "كتاب 2",
//       imagePath: "assets/images/bno.jpg",
//       pdfPath: "assets/pdfs/bno.pdf",
//     ),
//     BookData(
//       title: "كتاب 3",
//       imagePath: "assets/images/shlo.jpg",
//       pdfPath: "assets/pdfs/shlo.pdf",
//     ),
//     BookData(
//       title: "كتاب 4",
//       imagePath: "assets/images/iklil.jpg",
//       pdfPath: "assets/pdfs/iklil.pdf",
//     ),
//     BookData(
//       title: "كتاب 5",
//       imagePath: "assets/images/rasm.jpg",
//       pdfPath: "assets/pdfs/rasm.pdf",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("المكتبة"),
//         centerTitle: true,
//         backgroundColor: Color.fromARGB(255, 86, 86, 86),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.menu),
//             onPressed: () {
//               setState(() {
//                 _isOptionsVisible = !_isOptionsVisible;
//               });
//             },
//             iconSize: 20,
//             color: Colors.white,
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           GridView.builder(
//             padding: EdgeInsets.all(16),
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               childAspectRatio: 0.7,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//             ),
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               return BookCard(book: books[index]);
//             },
//           ),
//           // 
//                     AnimatedPositioned(
//             duration: Duration(milliseconds: 200),
//             curve: Curves.easeInOut,
//             right: _isOptionsVisible ? 0 : -200,
//             top: 0,
//             bottom: 0,
//             child: Container(
//               width: 180,
//               color: Color.fromARGB(255, 86, 86, 86).withOpacity(0.9),
//               child: Column(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 6),
//                     color: Color.fromARGB(255, 4, 62, 128),
//                   ),
//                   _buildOption(
//                     "الواجهة",
//                     Icons.home,
//                     onTap: () => Navigator.pushNamed(context, '/'),
//                   ),
//                   _buildOption(
//                     "المكتبة",
//                     Icons.library_books,
//                     onTap: () => Navigator.pushNamed(context, '/library'),
//                   ),
//                   _buildOption(
//                     "من نحن",
//                     Icons.info,
//                     onTap: () => Navigator.pushNamed(context, '/about'),
//                   ),
//                   _buildOption(
//                     "العلماء",
//                     Icons.people,
//                     onTap: () => Navigator.pushNamed(context, '/scholars'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOption(String title, IconData icon, {VoidCallback? onTap}) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white, size: 20),
//         title: Text(
//           title,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 12,
//             fontFamily: 'Cairo',
//             fontWeight: FontWeight.bold,
//           ),
//           textAlign: TextAlign.right,
//         ),
//         onTap: onTap ?? () {
//           print("تم اختيار: $title");
//         },
//       ),
//     );
//   }
// }

// class BookCard extends StatelessWidget {
//   final BookData book;

//   BookCard({required this.book});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => PDFViewerPage(book: book),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.3),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               flex: 4,
//               child: ClipRRect(
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
//                 child: Image.asset(
//                   book.imagePath,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             Expanded(
//               flex: 1,
//               child: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
//                 ),
//                 child: Text(
//                   book.title,
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Cairo',
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PDFViewerPage extends StatelessWidget {
//   final BookData book;

//   PDFViewerPage({required this.book});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(book.title),
//         centerTitle: true,
//       ),
//       body: SfPdfViewer.asset(book.pdfPath),
//     );
//   }
// }
























import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookData {
  final String title;
  final String imagePath;
  final String pdfPath;

  BookData({
    required this.title,
    required this.imagePath,
    required this.pdfPath,
  });
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool _isOptionsVisible = false;
  // ignore: unused_field
  final PageController _pageController = PageController();

  final List<BookData> books = [
    BookData(
      // title: "كتاب 1",
      title: "book1",
      imagePath: "assets/images/akh.jpg",
      pdfPath: "assets/pdfs/akh.pdf",
    ),
    BookData(
      title: "كتاب 2",
      imagePath: "assets/images/bno.jpg",
      pdfPath: "assets/pdfs/bno.pdf",
    ),
    BookData(
      title: "كتاب 3",
      imagePath: "assets/images/shlo.jpg",
      pdfPath: "assets/pdfs/shlo.pdf",
    ),
    BookData(
      title: "كتاب 4",
      imagePath: "assets/images/iklil.jpg",
      pdfPath: "assets/pdfs/iklil.pdf",
    ),
    BookData(
      title: "كتاب 5",
      imagePath: "assets/images/rasm.jpg",
      pdfPath: "assets/pdfs/rasm.pdf",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المكتبة"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _isOptionsVisible = !_isOptionsVisible;
              });
            },
            iconSize: 20,
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              return BookCard(book: books[index]);
            },
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            right: _isOptionsVisible ? 0 : -200,
            top: 0,
            bottom: 0,
            child: Container(
              width: 180,
              color: Colors.deepPurple.withOpacity(0.9),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    color: Colors.deepPurple,
                  ),
                  _buildOption(
                    "الواجهة",
                    Icons.home,
                    onTap: () => Navigator.pushNamed(context, '/'),
                  ),
                  _buildOption(
                    "المكتبة",
                    Icons.library_books,
                    onTap: () => Navigator.pushNamed(context, '/library'),
                  ),
                  _buildOption(
                    "من نحن",
                    Icons.info,
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                  _buildOption(
                    "العلماء",
                    Icons.people,
                    onTap: () => Navigator.pushNamed(context, '/scholars'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String title, IconData icon, {VoidCallback? onTap}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        onTap: onTap ?? () {
          print("تم اختيار: $title");
        },
      ),
    );
  }
}

class BookCard extends StatelessWidget {
  final BookData book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFViewerPage(book: book),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  book.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Text(
                  book.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatefulWidget {
  final BookData book;

  const PDFViewerPage({super.key, required this.book});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  bool _isOptionsVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _isOptionsVisible = !_isOptionsVisible;
              });
            },
            iconSize: 20,
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer
          SfPdfViewer.asset(widget.book.pdfPath),

          // Menu latéral
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            right: _isOptionsVisible ? 0 : -200,
            top: 0,
            bottom: 0,
            child: Container(
              width: 180,
              color: Colors.deepPurple.withOpacity(0.9),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    color: Colors.deepPurple,
                  ),
                  _buildOption(
                    "الواجهة",
                    Icons.home,
                    onTap: () => Navigator.pushNamed(context, '/'),
                  ),
                  _buildOption(
                    "المكتبة",
                    Icons.library_books,
                    onTap: () => Navigator.pushNamed(context, '/library'),
                  ),
                  _buildOption(
                    "من نحن",
                    Icons.info,
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                  _buildOption(
                    "العلماء",
                    Icons.people,
                    onTap: () => Navigator.pushNamed(context, '/scholars'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(String title, IconData icon, {VoidCallback? onTap}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        onTap: onTap ?? () {
          print("تم اختيار: $title");
        },
      ),
    );
  }
}