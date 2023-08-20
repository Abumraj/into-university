import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PdfReader extends StatefulWidget {
  const PdfReader({Key? key, this.file, this.title}) : super(key: key);
  final String? file;
  final String? title;
  @override
  State<PdfReader> createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  @override
  void initState() {
    super.initState();
  }

  readPdf() async {}
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title!),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            PDFView(
              filePath: widget.file!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageFling: false,
              pageSnap: false,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
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
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
              },
              // onViewCreated: (PDFViewController pdfViewController) {
              //   _controller.complete(pdfViewController);
              // },
              onLinkHandler: (String? uri) {},
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page;
                });
              },
            ),
          ],
        ));
  }
}
