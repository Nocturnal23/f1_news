import 'package:f1_news/widgets/navigation/app_bar_custom.dart';
import 'package:f1_news/widgets/navigation/drawer_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/news_filter_controller.dart';
import '../../core/providers/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/common/error_retry.dart';
import '../../widgets/common/filter_bar.dart';
import '../../widgets/racing/news_card.dart';

class NewsList extends ConsumerStatefulWidget {
  const NewsList({super.key});

  @override
  ConsumerState<NewsList> createState() => _NewsListState();
}

class _NewsListState extends ConsumerState<NewsList> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsAsync = ref.watch(newsProvider);
    final filterController = ref.watch(newsFilterProvider);

    ref.listen(newsProvider, (previous, next) {
      next.whenData((articles) {
        filterController.setArticles(articles);
      });
    });

    return Scaffold(
      appBar: AppBarCustom(title: l10n.lastNews),
      drawer: const DrawerApp(),
      body: newsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => ErrorRetry(
          errorMessage: err.toString(),
          onRetry: () => ref.invalidate(newsProvider),
        ),
        data: (articles) {
          if (!filterController.hasArticles && articles.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              filterController.setArticles(articles);
            });
          }
          return _buildBody(filterController);
        },
      ),
    );
  }

  Widget _buildBody(NewsFilterController filterController) {
    return ListenableBuilder(
      listenable: filterController,
      builder: (context, child) {
        return Column(
          children: [
            FilterBar(filterController: filterController),

            if (!filterController.hasArticles)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(newsProvider);
                    await ref.read(newsProvider.future);
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.newspaper_rounded,
                                  size: 56,
                                  color: Colors.grey.shade600,
                                ),

                                const SizedBox(height: 16),

                                Text(
                                  l10n.noNewsFound,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  l10n.changeFilter,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              _buildNewsList(filterController),
              _buildNavigation(filterController),
            ],
          ],
        );
      },
    );
  }

  Widget _buildNewsList(NewsFilterController filterController) {
    final pageArticles = filterController.currentPageArticles;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(newsProvider);
          await ref.read(newsProvider.future);
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
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
      ),
    );
  }

  Widget _buildNavigation(NewsFilterController filterController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: filterController.currentPage > 1
                ? () {
                    filterController.previousPage();
                    _scrollToTop();
                  }
                : null,
            child: Text(l10n.forward),
          ),

          Text(
            'Pagina ${filterController.currentPage} di ${filterController.totalPages}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          ElevatedButton(
            onPressed:
                filterController.currentPage < filterController.totalPages
                ? () {
                    filterController.nextPage();
                    _scrollToTop();
                  }
                : null,
            child: Text(l10n.backward),
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
