import 'package:http/http.dart' as http;
import 'package:rss_dart/dart_rss.dart';

import '../common/rss_list.dart';
import '../models/article.dart';

class RssService {
  Future<List<Article>> fetchAllNews() async {
    List<Article> allArticles = [];

    for (var url in RssList.feedUrls.values) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final feed = RssFeed.parse(response.body);

          for (var item in feed.items ?? []) {
            allArticles.add(Article.fromRssItem(item));
          }
        } else {
          print('Errore del server: ${response.statusCode} per $url');
        }
      } catch (e) {
        print('Errore durante il fetch di $url: $e');
      }
    }

    return allArticles;
  }
}