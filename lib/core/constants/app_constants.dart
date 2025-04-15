import 'dart:developer';


class AppConstants {
  static const String newsApiBaseUrl = 'https://newsapi.org/v2';
  static const int pageSize = 10;
  static const String defaultQuery = 'technology'; // Default search on startup
  static const int maxCachedSearches = 5; // For bonus
  static const String cachedSearchTermsKey = 'CACHED_SEARCH_TERMS';


}