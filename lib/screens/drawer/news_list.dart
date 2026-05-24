import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';

import '../../core/models/article.dart';
import '../../core/services/rss_service.dart';
import '../../widgets/common/error_retry.dart';
import '../../widgets/racing/news_card.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final RssService _rssService = RssService();
  late Future<List<Article>> _futureArticles;

  int _currentPage = 1;
  final int _itemsPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      _futureArticles = _rssService.fetchAllNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: "Ultime notizie"),

      drawer: DrawerApp(),

      body: _buildList(_futureArticles),
    );
  }

  Widget? _buildList(Future<List<Article>> futureArticles) {
    return FutureBuilder<List<Article>>(
        future: _futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorRetry(
              errorMessage: snapshot.error.toString(),
              onRetry: _fetchData,
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nessuna notizia trovata.'));
          }

          final articles = snapshot.data!; //Tutti gli articoli.
          final totalPages = (articles.length / _itemsPage).ceil(); //Il numero di pagine basato sul numero di articoli suddivisi.
          final startIndex = (_currentPage - 1) * _itemsPage; //Gli indici per capire quando è il momento di fermare la lista in quella pagina.
          int endIndex = startIndex + _itemsPage;
          //Controllo per evitare che l'indice vada oltre il numero di articoli.
          if (endIndex > articles.length) {
            endIndex = articles.length;
          }
          final pageArticles = articles.sublist(startIndex, endIndex); //Estrazione delle notizie per questa pagina.

          return Column(
            children: [
              ?_buildNewsList(pageArticles),
              ?_buildNavigation(totalPages),
            ],
          );
        }
    );
  }

  Widget? _buildNewsList(List<Article> pageArticles) {
    return Expanded(
      child: ListView.builder(
        itemCount: pageArticles.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          final article = pageArticles[index];
          return NewsCard(
            title: article.title,
            description: article.description,
            pubDate: article.pubDate,
            link: article.link,
            imageUrl: article.imageUrl,
          );
        },
      ),
    );
  }

  Widget? _buildNavigation(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1
                ? () {
              setState(() {
                _currentPage--;
              });
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
                : null,
            child: const Text('Indietro'),
          ),

          Text(
            'Pagina $_currentPage di $totalPages',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () {
              setState(() {
                _currentPage++;
              });
              _scrollController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
                : null,
            child: const Text('Avanti'),
          ),
        ],
      ),
    );
  }
}
