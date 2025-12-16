import 'package:flutter/material.dart';
// Import 3 model Anda
import 'package:frontend/core/models/article_model.dart';
import 'package:frontend/core/models/video_model.dart';
import 'package:frontend/core/models/infographic_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KnowledgeProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  // ===== PRIVATE DATA =====
  List<Article> _articles = [];
  List<Video> _videos = [];
  List<Infographic> _infographics = [];

  // ===== PUBLIC GETTER (INI YANG KURANG) =====
  List<Article> get articles => _articles;
  List<Video> get videos => _videos;
  List<Infographic> get infographics => _infographics;

  bool _hasFetchedArticles = false;
  bool _hasFetchedVideos = false;
  bool _hasFetchedInfographics = false;

  int _selectedTab = 0;
  String _searchQuery = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ===== FETCH ARTICLES =====
  Future<void> fetchArticles() async {
    if (_hasFetchedArticles) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('knowledge_articles')
          .select()
          .order('created_at', ascending: false);

      _articles = response
          .map<Article>((item) => Article.fromJson(item))
          .toList();

      _hasFetchedArticles = true;
    } catch (e) {
      debugPrint('Error fetching articles: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ===== FETCH VIDEOS =====
  Future<void> fetchVideos() async {
    if (_hasFetchedVideos) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response =
      await _supabase.from('knowledge_videos').select();

      _videos =
          response.map<Video>((item) => Video.fromJson(item)).toList();

      _hasFetchedVideos = true;
    } catch (e) {
      debugPrint('Error fetching videos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ===== FETCH INFOGRAPHICS =====
  Future<void> fetchInfographics() async {
    if (_hasFetchedInfographics) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response =
      await _supabase.from('knowledge_infographics').select();

      _infographics = response
          .map<Infographic>((item) => Infographic.fromJson(item))
          .toList();

      _hasFetchedInfographics = true;
    } catch (e) {
      debugPrint('Error fetching infographics: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ===== FILTER =====
  void updateSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  List<dynamic> getFilteredList(int tabIndex) {
    List<dynamic> list;

    if (tabIndex == 0) {
      list = _articles;
    } else if (tabIndex == 1) {
      list = _infographics;
    } else {
      list = _videos;
    }

    if (_searchQuery.isEmpty) return list;

    return list.where((item) {
      return item.title.toLowerCase().contains(_searchQuery);
    }).toList();
  }
}
