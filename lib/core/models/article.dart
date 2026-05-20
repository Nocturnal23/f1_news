import 'package:rss_dart/dart_rss.dart';

class Article {
  final String title;
  final String description;
  final String pubDate;
  final String link;
  final String imageUrl;

  Article({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.link,
    this.imageUrl = '',
  });

  factory Article.fromRssItem(RssItem item) {
    return Article(
      title: item.title ?? 'Senza Titolo',
      description: item.description ?? 'Nessuna descrizione disponibile',
      pubDate: item.pubDate?.toString() ?? '',
      link: item.link?.toString() ?? '',
      imageUrl: item.enclosure?.url ?? '',
    );
  }
}