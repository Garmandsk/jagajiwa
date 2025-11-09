import 'package:flutter/material.dart';
// Import 3 model Anda
import 'package:frontend/core/models/article_model.dart';
import 'package:frontend/core/models/video_model.dart';
import 'package:frontend/core/models/infographic_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KnowledgeProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  // Tiga list data
  List<Article> _articles = [];
  List<Video> _videos = [];
  List<Infographic> _infographics = [];

  // "Penjaga" agar tidak fetch ulang
  bool _hasFetchedArticles = false;
  bool _hasFetchedVideos = false;
  bool _hasFetchedInfographics = false;
  
  // State untuk filter
  int _selectedTab = 0;
  String _searchQuery = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // --- FUNGSI FETCH (LAZY LOADING) ---

  Future<void> fetchArticles() async {
    if (_hasFetchedArticles) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabase.from('knowledge_articles').select();
      _articles = response.map((item) => Article.fromJson(item)).toList();
      _hasFetchedArticles = true;
    } catch (e) {
      print('Error fetching articles: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> fetchVideos() async {
    if (_hasFetchedVideos) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabase.from('knowledge_videos').select();
      _videos = response.map((item) => Video.fromJson(item)).toList();
      _hasFetchedVideos = true;
    } catch (e) {
      print('Error fetching videos: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> fetchInfographics() async {
    if (_hasFetchedInfographics) return;
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabase.from('knowledge_infographics').select();
      _infographics = response.map((item) => Infographic.fromJson(item)).toList();
      _hasFetchedInfographics = true;
    } catch (e) {
      print('Error fetching infographics: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  // --- FUNGSI UNTUK FILTER ---

  void updateSelectedTab(int index) {
    _selectedTab = index;
    notifyListeners(); // Panggil UI untuk memfilter ulang
  }

  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners(); // Panggil UI untuk memfilter ulang
  }

  // --- FUNGSI UTAMA: GETTER YANG DIFILTER ---
  List<dynamic> getFilteredList(int tabIndex) {
    List<dynamic> listToFilter;

    // 1. Pilih list mana yang akan ditampilkan
    if (tabIndex == 0) {
      listToFilter = _articles;
    } else if (tabIndex == 1) {
      listToFilter = _infographics;
    } else {
      listToFilter = _videos;
    }

    // 2. Jika tidak ada query pencarian, kembalikan list apa adanya
    if (_searchQuery.isEmpty) {
      return listToFilter;
    }

    // 3. Jika ada query pencarian, filter list tersebut
    return listToFilter.where((item) {
      // Kita asumsikan semua model punya properti 'title'
      return item.title.toLowerCase().contains(_searchQuery);
    }).toList();
  }
}