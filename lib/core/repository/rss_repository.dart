import 'package:f1_news/core/services/rss_service.dart';
import 'package:rss_dart/domain/rss_feed.dart';

import '../common/rss_list.dart';
import '../models/article.dart';

class RssRepository {
  final RssService _apiClient = RssService();

  Future<List<Article>> fetchAllNews() async {
    List<Article> allArticles = [];

    for (var url in RssList.feedUrls.values) {
      try {
        final rawXml = await _apiClient.fetchRawXml(url);
        final feed = RssFeed.parse(rawXml);

        for (var item in feed.items) {
          allArticles.add(Article.fromRssItem(item));
        }
      } catch (e) {
        print('Errore durante il fetch o parsing di $url: $e');
      }
    }

    allArticles.sort((a, b) {
      if (a.pubDate == null && b.pubDate == null) return 0;
      if (a.pubDate == null) return 1;
      if (b.pubDate == null) return -1;
      return b.pubDate!.compareTo(a.pubDate!);
    });

    return allArticles;
  }
}