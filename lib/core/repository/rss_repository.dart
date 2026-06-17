import 'dart:io';

import 'package:f1_news/core/services/rss_service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rss_dart/domain/rss_feed.dart';

import '../common/rss_list.dart';
import '../models/article.dart';

class RssRepository {
  final RssService _apiClient;

  static List<Article>? _cachedArticles;
  static DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);
  String? _cachedLanguageCode;

  RssRepository(this._apiClient);

  Future<List<Article>> fetchAllNews({required String languageCode, bool forceRefresh = false}) async {
    final connected = await InternetConnection().hasInternetAccess;

    if (!connected) {
      throw const SocketException(
        'Nessuna connessione a Internet',
      );
    }

    final now = DateTime.now();

    final isCacheValid = _lastFetchTime != null &&
        now.difference(_lastFetchTime!) < _cacheDuration &&
        _cachedLanguageCode == languageCode;

    if (!forceRefresh && _cachedArticles != null && isCacheValid) {
      return _cachedArticles!;
    }

    List<Article> allArticles = [];
    bool hasError = false;

    final targetFeeds = languageCode == 'en' ? RssList.feedUrlsEN : RssList.feedUrls;

    print("FETCH NEWS START");
    for (var entry in targetFeeds.entries) {
      final key = entry.key;
      final url = entry.value;
      print("START FEED ${entry.key}");

      try {
        final rawXml = await _apiClient.fetchRawXml(url);
        final feed = RssFeed.parse(rawXml);

        for (var item in feed.items) {
          allArticles.add(Article.fromRssItem(item, key));
        }
        print("END FEED ${entry.key}");
      } catch (e) {
        print("ERROR FEED ${entry.key}: $e");
        hasError = true;
        print('Errore durante il fetch o parsing di $url: $e');
      }
    }
    print("FETCH NEWS END");

    if (allArticles.isEmpty && hasError) {
      throw Exception('Nessuna connessione o impossibile recuperare le notizie.');
    }

    allArticles.sort((a, b) {
      if (a.pubDate == null && b.pubDate == null) return 0;
      if (a.pubDate == null) return 1;
      if (b.pubDate == null) return -1;
      return b.pubDate!.compareTo(a.pubDate!);
    });

    _cachedArticles = allArticles;
    _lastFetchTime = now;
    _cachedLanguageCode = languageCode;

    return allArticles;
  }
}