import 'package:f1_news/core/repository/rss_repository.dart';
import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';

import '../../controllers/news_filter_controller.dart';
import '../../widgets/common/error_retry.dart';
import '../../widgets/racing/news_card.dart';

class NewsList extends StatefulWidget {
  const NewsList({super.key});

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final RssRepository _repository = RssRepository();
  final NewsFilterController _controller = NewsFilterController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await _repository.fetchAllNews();
      _controller.setArticles(articles);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCustom(title: "Ultime notizie"),
      drawer: const DrawerApp(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return ErrorRetry(
        errorMessage: _errorMessage!,
        onRetry: _fetchData,
      );
    }

    //Questo reagisce ai notyfi.
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {

        if (!_controller.hasArticles) {
          return const Center(child: Text('Nessuna notizia trovata.'));
        }

        return Column(
          children: [

            _buildNewsList(),
            _buildNavigation(),
          ],
        );
      },
    );
  }

  Widget _buildNewsList() {
    final pageArticles = _controller.currentPageArticles;

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

  Widget _buildNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _controller.currentPage > 1
                ? () {
              _controller.previousPage();
              _scrollToTop();
            }
                : null,
            child: const Text('Indietro'),
          ),

          Text(
            'Pagina ${_controller.currentPage} di ${_controller.totalPages}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          ElevatedButton(
            onPressed: _controller.currentPage < _controller.totalPages
                ? () {
              _controller.nextPage();
              _scrollToTop();
            }
                : null,
            child: const Text('Avanti'),
          ),
        ],
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
