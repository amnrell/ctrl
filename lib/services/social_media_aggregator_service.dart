import './bigquery_service.dart';
import './social_media_trackers/facebook_tracker.dart';
import './social_media_trackers/instagram_tracker.dart';
import './social_media_trackers/reddit_tracker.dart';
import './social_media_trackers/snapchat_tracker.dart';
import './social_media_trackers/tiktok_tracker.dart';
import './social_media_trackers/x_twitter_tracker.dart';
import './social_media_trackers/youtube_tracker.dart';

/// Unified social media aggregation service
/// Coordinates data collection across all platforms and sends to BigQuery
class SocialMediaAggregatorService {
  static final SocialMediaAggregatorService _instance =
      SocialMediaAggregatorService._internal();

  final InstagramTracker _instagramTracker = InstagramTracker();
  final TikTokTracker _tiktokTracker = TikTokTracker();
  final XTwitterTracker _xTwitterTracker = XTwitterTracker();
  final YouTubeTracker _youtubeTracker = YouTubeTracker();
  final FacebookTracker _facebookTracker = FacebookTracker();
  final SnapchatTracker _snapchatTracker = SnapchatTracker();
  final RedditTracker _redditTracker = RedditTracker();
  final BigQueryService _bigQueryService = BigQueryService();

  factory SocialMediaAggregatorService() {
    return _instance;
  }

  SocialMediaAggregatorService._internal();

  /// Aggregate data from all connected social media platforms
  Future<Map<String, dynamic>> aggregateAllPlatforms(String userId) async {
    try {
      final results = await Future.wait([
        _instagramTracker.getRecentActivity().catchError((_) => {}),
        _tiktokTracker.getUserVideos().catchError((_) => []),
        _xTwitterTracker.getUserTweets(userId).catchError((_) => []),
        _youtubeTracker.getWatchHistory().catchError((_) => []),
        _facebookTracker.getUserPosts().catchError((_) => []),
        _snapchatTracker.getUserProfile().catchError((_) => {}),
        _redditTracker.getUserPosts(userId).catchError((_) => []),
      ]);

      final aggregatedData = {
        'instagram': results[0],
        'tiktok': results[1],
        'x_twitter': results[2],
        'youtube': results[3],
        'facebook': results[4],
        'snapchat': results[5],
        'reddit': results[6],
      };

      // Stream aggregated data to BigQuery for analysis
      await _streamToBigQuery(userId, aggregatedData);

      return aggregatedData;
    } catch (e) {
      throw Exception('Failed to aggregate platform data: $e');
    }
  }

  /// Stream collected data to BigQuery for training and analytics
  Future<void> _streamToBigQuery(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      final events = <Map<String, dynamic>>[];

      // Convert aggregated data to BigQuery event format
      data.forEach((platform, platformData) {
        if (platformData != null && platformData is Map) {
          events.add({
            'userId': userId,
            'platform': platform,
            'eventType': 'data_sync',
            'data': platformData,
          });
        }
      });

      await _bigQueryService.streamSocialMediaData(events);
    } catch (e) {
      print('Failed to stream data to BigQuery: $e');
    }
  }

  /// Get unified statistics across all platforms
  Future<Map<String, dynamic>> getUnifiedStatistics(String userId) async {
    try {
      final data = await aggregateAllPlatforms(userId);

      return {
        'total_posts': _calculateTotalPosts(data),
        'total_comments': _calculateTotalComments(data),
        'total_shares': _calculateTotalShares(data),
        'total_engagement': _calculateTotalEngagement(data),
        'screen_time_hours': 0, // Will be populated from device tracking
        'platforms_connected': _countConnectedPlatforms(data),
      };
    } catch (e) {
      throw Exception('Failed to calculate unified statistics: $e');
    }
  }

  int _calculateTotalPosts(Map<String, dynamic> data) {
    // Logic to count posts across platforms
    return 0; // Placeholder
  }

  int _calculateTotalComments(Map<String, dynamic> data) {
    // Logic to count comments across platforms
    return 0; // Placeholder
  }

  int _calculateTotalShares(Map<String, dynamic> data) {
    // Logic to count shares across platforms
    return 0; // Placeholder
  }

  int _calculateTotalEngagement(Map<String, dynamic> data) {
    // Logic to calculate total engagement
    return 0; // Placeholder
  }

  int _countConnectedPlatforms(Map<String, dynamic> data) {
    return data.values.where((v) => v != null && v != {} && v != []).length;
  }
}
