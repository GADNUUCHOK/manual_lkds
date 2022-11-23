// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'dart:async';
import 'dart:io';

// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:manual_lkds/widgets/drawer_navigation.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);
  static const routeLibrary = '/library';

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool _isLoadingPDF = true;
  // late PDFDocument document;
  String? pathPDF = null;

  @override
  void initState() {
    super.initState();
    fromAsset('assets/docs/LNGS.465213.092-01_1 RE.pdf', 'LNGS.465213.092-01_1 RE.pdf').then((f) {
      setState(() {
        pathPDF = f.path;
        _isLoadingPDF = false;
      });
    });
    // loadDocument();
  }

  Future<File> fromAsset(String asset, String filename) async {
    // To open from assets, you can copy them to the app storage folder, and the access them "locally"
    Completer<File> completer = Completer();

    try {
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/$filename");
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  // loadDocument() async {
  //   // document = await PDFDocument.fromURL('http://lkds.ru/upload/docs/archive/voice/LNGS.465213.092-01_1%20RE.pdf');
  //   document = await PDFDocument.fromAsset('assets/docs/LNGS.465213.092-01_1 RE.pdf');
  //
  //   setState(() {
  //     _isLoadingPDF = false;
  //     print('_isLoadingPDF = false;');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LKDS Manual'),),
      drawer: const DrawerNavigation(),
      body: Center(child:
      _isLoadingPDF
          ? const Center(child: CircularProgressIndicator())
          : Center(child: PDFScreen(path: pathPDF))
      // SfPdfViewer.network("http://lkds.ru/upload/docs/archive/voice/LNGS.465213.092-01_1%20RE.pdf", key: _pdfViewerKey,)
      //     : PDFViewer(document: document, zoomSteps: 1,
      //   //uncomment below line to preload all pages
      //   lazyLoad: false,
      //   // uncomment below line to scroll vertically
      //   scrollDirection: Axis.vertical,
      //
      //   //uncomment below code to replace bottom navigation with your own
      //    navigationBuilder:
      //                     (context, page, totalPages, jumpToPage, animateToPage) {
      //                   return ButtonBar(
      //                     alignment: MainAxisAlignment.spaceEvenly,
      //                     children: <Widget>[
      //                       IconButton(
      //                         icon: Icon(Icons.first_page),
      //                         onPressed: () {
      //                           jumpToPage(page: 0);
      //                         },
      //                       ),
      //                       IconButton(
      //                         icon: Icon(Icons.arrow_back),
      //                         onPressed: () {
      //                           animateToPage(page: page! - 2);
      //                         },
      //                       ),
      //                       IconButton(
      //                         icon: Icon(Icons.arrow_forward),
      //                         onPressed: () {
      //                           animateToPage(page: page);
      //                         },
      //                       ),
      //                       IconButton(
      //                         icon: Icon(Icons.last_page),
      //                         onPressed: () {
      //                           jumpToPage(page: totalPages! - 1);
      //                         },
      //                       ),
      //                     ],
      //                   );
      //                 },
      // )
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
            false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
              ? Center(
            child: CircularProgressIndicator(),
          )
              : Container()
              : Center(
            child: Text(errorMessage),
          )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
