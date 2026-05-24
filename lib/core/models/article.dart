import 'package:intl/intl.dart';
import 'package:rss_dart/dart_rss.dart';

class Article {
  final String title;
  final String description;
  final DateTime? pubDate;
  final String link;
  final String imageUrl;

  Article({
    required this.title,
    required this.description,
    this.pubDate,
    required this.link,
    this.imageUrl = '',
  });

  factory Article.fromRssItem(RssItem item) {
    return Article(
      title: item.title ?? 'Senza Titolo',
      description: item.description ?? 'Nessuna descrizione disponibile',
      pubDate: _normalizzeDate(item.pubDate),
      link: item.link?.toString() ?? '',
      imageUrl: item.enclosure?.url ?? '',
    );
  }

  static DateTime? _normalizzeDate(String? date) {
    if (date == null || date.trim().isEmpty) return null;

    DateTime? parsedDate = DateTime.tryParse(date);
    if (parsedDate != null) {
      return parsedDate;
    }

    try {
      final format = DateFormat("EEE, dd MMM yyyy HH:mm:ss Z", "en_US");
      return format.parse(date);
    } catch (e) {
      print("Impossibile normalizzare la data: $date - Errore: $e");
      return null;
    }
  }
}