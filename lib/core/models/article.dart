import 'package:intl/intl.dart';
import 'package:rss_dart/dart_rss.dart';

class Article {
  final String title;
  final String publisher;
  final String description;
  final DateTime? pubDate;
  final String link;
  final String imageUrl;

  Article({
    required this.title,
    required this.publisher,
    required this.description,
    this.pubDate,
    required this.link,
    this.imageUrl = '',
  });

  factory Article.fromRssItem(RssItem item, String pub) {
    return Article(
      title: item.title ?? 'Senza Titolo',
      publisher: pub,
      description: _cleanHtml(item.description),
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

  static String _cleanHtml(String? rawString) {
    if (rawString == null || rawString.isEmpty) {
      return '';
    }

    final RegExp htmlTagsExp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    String cleanString = rawString.replaceAll(htmlTagsExp, ' ');

    cleanString = cleanString.replaceAll('&nbsp;', ' ');
    cleanString = cleanString.replaceAll('&quot;', '"');
    cleanString = cleanString.replaceAll('&apos;', "'");
    cleanString = cleanString.replaceAll('&amp;', '&');
    cleanString = cleanString.replaceAll('&lt;', '<');
    cleanString = cleanString.replaceAll('&gt;', '>');

    cleanString = cleanString.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleanString;
  }
}