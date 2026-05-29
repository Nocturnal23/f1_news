import 'package:flutter/foundation.dart';

import '../core/models/article.dart';

class NewsFilterController extends ChangeNotifier {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];

  //Gestione filtri.
  String _searchQuery = "";
  String? _selectedDriver;
  String? _selectedConstructor;
  String? _selectedPublisher;

  //Gestione pagine.
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  void setArticles(List<Article> articles) {
    _allArticles = articles;
    _applyFilters();
  }

  //Set dei filtri.
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void updateDriver(String? driver) {
    _selectedDriver = driver;
    _applyFilters();
  }

  void updateConstructor(String? constructor) {
    _selectedConstructor = constructor;
    _applyFilters();
  }

  void updatePublisher(String? publisher) {
    _selectedPublisher = publisher;
    _applyFilters();
  }

  void _applyFilters() {
    List<Article> result = List.from(_allArticles);

    if (_selectedPublisher != null && _selectedPublisher!.isNotEmpty) {
      result = result.where((a) => a.publisher == _selectedPublisher).toList();
    }

    if (_selectedDriver != null && _selectedDriver!.isNotEmpty) {
      final pilotLower = _selectedDriver!.toLowerCase();
      result = result.where((a) => _containsKeyword(a, pilotLower)).toList();
    }

    if (_selectedConstructor != null && _selectedConstructor!.isNotEmpty) {
      result = result.where((a) => _matchTeamName(a, _selectedConstructor!)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      result = result.where((a) => _containsKeyword(a, queryLower)).toList();
    }

    _filteredArticles = result;
    _currentPage = 1;

    notifyListeners();
  }

  bool _containsKeyword(Article article, String keyword) {
    final titleMatch = article.title.toLowerCase().contains(keyword);
    final descMatch = article.description.toLowerCase().contains(keyword);
    //NOTA: RAGIONARE SE AGGIUNGERE CATEGORY.
    return titleMatch || descMatch;
  }

  List<Article> get currentPageArticles {
    if (_filteredArticles.isEmpty) return [];

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    int endIndex = startIndex + _itemsPerPage;

    if (endIndex > _filteredArticles.length) {
      endIndex = _filteredArticles.length;
    }

    return _filteredArticles.sublist(startIndex, endIndex);
  }

  int get currentPage => _currentPage;

  int get totalPages => (_filteredArticles.length / _itemsPerPage).ceil();

  bool get hasArticles => _filteredArticles.isNotEmpty;

  void nextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  bool _matchTeamName(Article article, String officialConstructorName) {
    final stopWords = [
      'f1', 'team', 'scuderia', 'racing', 'motorsport',
      'bwt', 'aramco', 'hp', 'mastercard', 'petronas', 'oracle', 'visa', 'cash', 'app'
    ];

    final rawWords = officialConstructorName.toLowerCase().split(RegExp(r'\s+'));

    final meaningfulWords = rawWords.where((word) => !stopWords.contains(word)).toList();

    if (meaningfulWords.isEmpty) return false;

    final titleLower = article.title.toLowerCase();
    final descLower = article.description.toLowerCase();

    for (final word in meaningfulWords) {
      if (titleLower.contains(word) || descLower.contains(word)) {
        return true;
      }
    }

    return false;
  }
}