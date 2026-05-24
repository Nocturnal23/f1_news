import 'package:flutter/material.dart';

import '../article_page.dart';

class NewsCard extends StatelessWidget {
  final String title;
  final String description;
  final String pubDate;
  final String link;
  final String imageUrl;

  const NewsCard({
    super.key,
    required this.title,
    required this.description,
    required this.pubDate,
    required this.link,
    this.imageUrl = ''
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(imageUrl)
                : SizedBox.shrink(),

            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    pubDate,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticlePage(
              title: title,
              url: link,
            ),
          ),
        );
      },
    );
  }
}
