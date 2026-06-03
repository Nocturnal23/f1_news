import 'package:carousel_slider/carousel_slider.dart';
import 'package:f1_news/widgets/racing/card_custom.dart';
import 'package:f1_news/widgets/common/countdown_race.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../controllers/auth_controller.dart';
import '../core/models/article.dart';
import '../core/navigation/routes.dart';
import '../core/providers/provider.dart';
import '../widgets/article_page.dart';
import '../widgets/common/error_retry.dart';
import '../widgets/navigation/app_bar_custom.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({super.key});

  @override
  ConsumerState<Homepage> createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => const Scaffold(body: Center(child: Text("Errore auth"))),
      data: (user) {
        return Scaffold(
          appBar: AppBarCustom(
            title: "F1 News",
          ),

          drawer: const DrawerApp(),

          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    authState.value != null
                      ? "PER TE"
                      : "Ultime notizie",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                _buildNewsCarousel(),
                const SizedBox(height: 50),
                _buildNextRace(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> signOut() async {
    await AuthController().signOut();
  }

  Widget _buildNextRace() {
    final nextRaceAsync = ref.watch(nextRaceProvider);
    return nextRaceAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.red),
            SizedBox(height: 16),
            Text("Caricamento evento...", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      error: (err, stack) => ErrorRetry(
        errorMessage: err.toString(),
        onRetry: () {
          ref.invalidate(calendarProvider);
          ref.invalidate(nextRaceProvider);
          ref.read(calendarProvider);
          ref.read(nextRaceProvider);
        }
      ),
      data: (nextRace) {
        if (nextRace == null) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_score, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "Nessuna gara in programma",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Torna a controllare più tardi per i prossimi eventi.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("EVENTO IN CALENDARIO", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CardCustom(item: nextRace),
              const SizedBox(height: 10),
              CountdownRace(fp1Start: nextRace.fp1StartDateTime, raceStart: nextRace.raceStartDateTime),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewsCarousel() {
    final newsAsync = ref.watch(featuredNewsProvider);

    return newsAsync.when(
      loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const SizedBox.shrink(),
      data: (articles) {
        if (articles.isEmpty) return const SizedBox.shrink();

        return CarouselSlider.builder(
          itemCount: articles.length + 1,
          itemBuilder: (context, index, realIndex) {
            if (index == articles.length) {
              return _buildSeeMoreCard();
            }
            return _buildNewsCard(articles[index]);
          },
          options: CarouselOptions(
            height: 250,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            autoPlay: articles.length > 1,
          ),
        );
      },
    );
  }

  Widget _buildNewsCard(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticlePage(
              title: article.title,
              url: article.link,
            ),
          ),
        );
      },

      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            article.imageUrl.isNotEmpty
                ? Image.network(article.imageUrl, fit: BoxFit.cover)
                : Image.asset("lib/assets/logos/f1.webp", fit: BoxFit.cover),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeeMoreCard() {
    return Card(
      color: Colors.red.shade900,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, Routes.news);
        },
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 40),
              SizedBox(height: 10),
              Text("Vedi tutte le news", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
