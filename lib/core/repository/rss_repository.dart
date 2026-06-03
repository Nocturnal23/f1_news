import 'package:f1_news/core/services/rss_service.dart';
import 'package:rss_dart/domain/rss_feed.dart';

import '../common/rss_list.dart';
import '../models/article.dart';

class RssRepository {
  final RssService _apiClient;

  static List<Article>? _cachedArticles;
  static DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  RssRepository(this._apiClient);

  Future<List<Article>> fetchAllNews({bool forceRefresh = false}) async {
    final now = DateTime.now();
    final isCacheValid = _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _cacheDuration;

    if (!forceRefresh && _cachedArticles != null && isCacheValid) {
      return _cachedArticles!;
    }

    List<Article> allArticles = [];

    for (var entry in RssList.feedUrls.entries) {
      final key = entry.key;
      final url = entry.value;

      try {
        final rawXml = await _apiClient.fetchRawXml(url);
        final feed = RssFeed.parse(rawXml);

        for (var item in feed.items) {
          allArticles.add(Article.fromRssItem(item, key));
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

    _cachedArticles = allArticles;
    _lastFetchTime = now;

    return allArticles;
  }
}