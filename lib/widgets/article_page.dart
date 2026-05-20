import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

//Classe creata per permettere l'apertura di una notizia in app sfruttando WebView.
class ArticlePage extends StatefulWidget {
  final String title;
  final String url;

  const ArticlePage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  //Controller WebView. Esegue ciò che serve per il funzionamento coretto della pagina.
  late final WebViewController controller;


  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      // Delegate = listener eventi webview
      ..loadRequest(Uri.parse(widget.url));//Conversione da String a URI.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: WebViewWidget(
      controller: controller,
      ),
    );
  }
}