# Social Media Integration Guide for CTRL App

## Overview
This guide provides comprehensive instructions for integrating social media platform tracking into your CTRL app for monitoring user activity across Instagram, TikTok, X (Twitter), YouTube, Facebook, Snapchat, and Reddit.

## 🎯 Pre-Publishing Checklist (15% Remaining to App Store)

### Required Implementations:
1. ✅ Social media platform tracking backend
2. ✅ API authentication and authorization
3. ✅ Data privacy compliance (GDPR, CCPA)
4. ✅ User consent management
5. ✅ Rate limiting and error handling
6. ✅ Secure credential storage
7. ✅ Analytics data aggregation

---

## 📱 Platform-by-Platform Integration

### 1. Instagram Integration

#### Required APIs:
- **Instagram Graph API** (Meta for Developers)
- **Instagram Basic Display API** (for personal accounts)

#### Setup Steps:
```
1. Create a Meta/Facebook Developer Account
   - Go to https://developers.facebook.com/
   - Create a new app
   - Add Instagram Graph API product

2. Required Permissions:
   - instagram_basic
   - instagram_manage_insights
   - instagram_manage_comments
   - pages_read_engagement
   - pages_show_list

3. Webhook Setup:
   - Configure webhooks for real-time updates
   - Subscribe to: comments, mentions, story_insights
```

#### Environment Variables:
```dart
INSTAGRAM_APP_ID=your_instagram_app_id
INSTAGRAM_APP_SECRET=your_instagram_app_secret
INSTAGRAM_ACCESS_TOKEN=user_access_token
```

#### Tracking Capabilities:
- **Comments**: `/me/media/{media-id}/comments`
- **Posts**: `/me/media`
- **Stories**: `/me/stories`
- **Insights**: `/me/insights`
- **Engagement**: likes, comments, shares, saves

#### Flutter Implementation:
```dart
class InstagramTracker {
  static const String baseUrl = 'https://graph.instagram.com';
  
  Future<Map<String, dynamic>> getRecentActivity() async {
    final token = String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');
    final response = await dio.get(
      '$baseUrl/me/media',
      queryParameters: {
        'fields': 'id,caption,media_type,timestamp,like_count,comments_count',
        'access_token': token,
      },
    );
    return response.data;
  }

  Future<List<Comment>> getComments(String mediaId) async {
    final token = String.fromEnvironment('INSTAGRAM_ACCESS_TOKEN');
    final response = await dio.get(
      '$baseUrl/$mediaId/comments',
      queryParameters: {
        'fields': 'text,username,timestamp',
        'access_token': token,
      },
    );
    return (response.data['data'] as List)
        .map((c) => Comment.fromJson(c))
        .toList();
  }
}
```

---

### 2. TikTok Integration

#### Required APIs:
- **TikTok for Developers API**
- **TikTok Login Kit**

#### Setup Steps:
```
1. Register at TikTok for Developers
   - Go to https://developers.tiktok.com/
   - Create an application
   - Enable required scopes

2. Required Scopes:
   - user.info.basic
   - video.list
   - video.insights
   - comment.list

3. OAuth 2.0 Setup:
   - Configure redirect URIs
   - Implement authorization flow
```

#### Environment Variables:
```dart
TIKTOK_CLIENT_KEY=your_tiktok_client_key
TIKTOK_CLIENT_SECRET=your_tiktok_client_secret
TIKTOK_REDIRECT_URI=your_app_redirect_uri
```

#### Tracking Capabilities:
- **Videos**: `/v2/video/list/`
- **Comments**: `/v2/comment/list/`
- **Insights**: `/v2/video/insights/`
- **User Info**: `/v2/user/info/`

#### Flutter Implementation:
```dart
class TikTokTracker {
  static const String baseUrl = 'https://open.tiktokapis.com';
  
  Future<List<TikTokVideo>> getUserVideos() async {
    final token = await _getAccessToken();
    final response = await dio.get(
      '$baseUrl/v2/video/list/',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {'fields': 'id,create_time,share_count,comment_count,like_count'},
    );
    return (response.data['data']['videos'] as List)
        .map((v) => TikTokVideo.fromJson(v))
        .toList();
  }

  Future<int> getScreenTimeEstimate() async {
    // TikTok doesn't provide direct screen time API
    // Implement estimation based on video views and average watch time
    final videos = await getUserVideos();
    return _calculateEstimatedTime(videos);
  }
}
```

---

### 3. X (Twitter) Integration

#### Required APIs:
- **X API v2** (formerly Twitter API)
- **OAuth 2.0 with PKCE**

#### Setup Steps:
```
1. Create X Developer Account
   - Go to https://developer.x.com/
   - Create a project and app
   - Generate API keys and bearer token

2. Required Permissions:
   - tweet.read
   - users.read
   - follows.read
   - like.read
   - offline.access

3. Rate Limits:
   - Free tier: 1,500 tweets/month
   - Basic tier: 10,000 tweets/month
   - Consider rate limit handling
```

#### Environment Variables:
```dart
X_API_KEY=your_x_api_key
X_API_SECRET=your_x_api_secret
X_BEARER_TOKEN=your_bearer_token
X_ACCESS_TOKEN=user_access_token
```

#### Tracking Capabilities:
- **Tweets**: `/2/tweets`
- **Mentions**: `/2/users/:id/mentions`
- **Likes**: `/2/users/:id/liked_tweets`
- **Retweets**: `/2/tweets/:id/retweeted_by`

#### Flutter Implementation:
```dart
class XTwitterTracker {
  static const String baseUrl = 'https://api.x.com';
  
  Future<List<Tweet>> getUserTweets(String userId) async {
    final token = String.fromEnvironment('X_BEARER_TOKEN');
    final response = await dio.get(
      '$baseUrl/2/users/$userId/tweets',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {
        'tweet.fields': 'created_at,public_metrics,text',
        'max_results': 100,
      },
    );
    return (response.data['data'] as List)
        .map((t) => Tweet.fromJson(t))
        .toList();
  }

  Future<List<String>> getRetweets(String tweetId) async {
    final token = String.fromEnvironment('X_BEARER_TOKEN');
    final response = await dio.get(
      '$baseUrl/2/tweets/$tweetId/retweeted_by',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data['data'] as List)
        .map((u) => u['username'] as String)
        .toList();
  }
}
```

---

### 4. YouTube Integration

#### Required APIs:
- **YouTube Data API v3**
- **YouTube Analytics API**

#### Setup Steps:
```
1. Create Google Cloud Project
   - Go to https://console.cloud.google.com/
   - Enable YouTube Data API v3
   - Enable YouTube Analytics API
   - Create OAuth 2.0 credentials

2. Required Scopes:
   - https://www.googleapis.com/auth/youtube.readonly
   - https://www.googleapis.com/auth/yt-analytics.readonly
   - https://www.googleapis.com/auth/youtube.force-ssl

3. Quota Management:
   - Default quota: 10,000 units/day
   - Optimize queries to minimize quota usage
```

#### Environment Variables:
```dart
YOUTUBE_API_KEY=your_youtube_api_key
YOUTUBE_CLIENT_ID=your_client_id
YOUTUBE_CLIENT_SECRET=your_client_secret
```

#### Tracking Capabilities:
- **Watch History**: Via OAuth with user consent
- **Subscriptions**: `/youtube/v3/subscriptions`
- **Comments**: `/youtube/v3/commentThreads`
- **Analytics**: `/youtube/analytics/v2/reports`

#### Flutter Implementation:
```dart
class YouTubeTracker {
  static const String baseUrl = 'https://www.googleapis.com/youtube/v3';
  
  Future<List<VideoActivity>> getWatchHistory() async {
    final token = await _getOAuthToken();
    final response = await dio.get(
      '$baseUrl/activities',
      queryParameters: {
        'part': 'snippet,contentDetails',
        'mine': 'true',
        'maxResults': 50,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return (response.data['items'] as List)
        .map((item) => VideoActivity.fromJson(item))
        .toList();
  }

  Future<Map<String, int>> getEngagementStats() async {
    final token = await _getOAuthToken();
    final response = await dio.get(
      'https://youtubeanalytics.googleapis.com/v2/reports',
      queryParameters: {
        'ids': 'channel==MINE',
        'metrics': 'views,comments,likes,shares',
        'dimensions': 'day',
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return _parseEngagementData(response.data);
  }
}
```

---

### 5. Facebook Integration

#### Required APIs:
- **Facebook Graph API**
- **Facebook Login**

#### Setup Steps:
```
1. Use Same Meta Developer Account as Instagram
   - Add Facebook Login product
   - Configure OAuth redirect URIs

2. Required Permissions:
   - public_profile
   - user_posts
   - user_likes
   - user_friends
   - read_insights

3. Review Process:
   - Submit for App Review for advanced permissions
   - Provide detailed use case documentation
```

#### Environment Variables:
```dart
FACEBOOK_APP_ID=your_facebook_app_id
FACEBOOK_APP_SECRET=your_facebook_app_secret
FACEBOOK_ACCESS_TOKEN=user_access_token
```

#### Tracking Capabilities:
- **Posts**: `/me/posts`
- **Reactions**: `/me/reactions`
- **Comments**: `/{post-id}/comments`
- **Shares**: `/{post-id}/sharedposts`

#### Flutter Implementation:
```dart
class FacebookTracker {
  static const String baseUrl = 'https://graph.facebook.com/v18.0';
  
  Future<List<Post>> getUserPosts() async {
    final token = String.fromEnvironment('FACEBOOK_ACCESS_TOKEN');
    final response = await dio.get(
      '$baseUrl/me/posts',
      queryParameters: {
        'fields': 'id,message,created_time,likes.summary(true),comments.summary(true)',
        'access_token': token,
      },
    );
    return (response.data['data'] as List)
        .map((p) => Post.fromJson(p))
        .toList();
  }

  Future<int> getTotalEngagement() async {
    final posts = await getUserPosts();
    return posts.fold(0, (sum, post) => sum + post.likesCount + post.commentsCount);
  }
}
```

---

### 6. Snapchat Integration

#### Required APIs:
- **Snap Kit**
- **Login Kit**
- **Creative Kit** (for sharing)

#### Setup Steps:
```
1. Register at Snap Kit Developer Portal
   - Go to https://kit.snapchat.com/
   - Create an application
   - Configure OAuth settings

2. Required Scopes:
   - https://auth.snapchat.com/oauth2/api/user.display_name
   - https://auth.snapchat.com/oauth2/api/user.bitmoji.avatar

3. Limitations:
   - Snapchat doesn't provide detailed analytics API
   - Focus on authentication and basic profile data
   - Use device-level tracking for screen time
```

#### Environment Variables:
```dart
SNAPCHAT_CLIENT_ID=your_snapchat_client_id
SNAPCHAT_CLIENT_SECRET=your_snapchat_client_secret
SNAPCHAT_REDIRECT_URI=your_redirect_uri
```

#### Flutter Implementation:
```dart
class SnapchatTracker {
  static const String baseUrl = 'https://kit.snapchat.com';
  
  // Note: Snapchat has limited API access
  // Most tracking will rely on device-level permissions
  
  Future<SnapchatProfile> getUserProfile() async {
    final token = await _getAccessToken();
    final response = await dio.get(
      '$baseUrl/v1/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return SnapchatProfile.fromJson(response.data);
  }

  // For screen time tracking, use device usage stats APIs
  Future<Duration> getAppUsageTime() async {
    // iOS: Use Screen Time API (requires user permission)
    // Android: Use UsageStatsManager
    return await _getDeviceUsageStats('com.snapchat.android');
  }
}
```

---

### 7. Reddit Integration

#### Required APIs:
- **Reddit API**
- **OAuth 2.0**

#### Setup Steps:
```
1. Create Reddit App
   - Go to https://www.reddit.com/prefs/apps
   - Create a new application (script type for personal use)
   - Note your client_id and client_secret

2. Required Scopes:
   - identity
   - read
   - history
   - mysubreddits
   - vote

3. Rate Limits:
   - 60 requests per minute
   - Implement proper rate limiting
```

#### Environment Variables:
```dart
REDDIT_CLIENT_ID=your_reddit_client_id
REDDIT_CLIENT_SECRET=your_reddit_client_secret
REDDIT_USERNAME=user_reddit_username
REDDIT_PASSWORD=user_reddit_password
```

#### Tracking Capabilities:
- **Posts**: `/user/{username}/submitted`
- **Comments**: `/user/{username}/comments`
- **Votes**: `/api/vote`
- **Subreddits**: `/subreddits/mine/subscriber`

#### Flutter Implementation:
```dart
class RedditTracker {
  static const String baseUrl = 'https://oauth.reddit.com';
  
  Future<List<RedditPost>> getUserPosts(String username) async {
    final token = await _getAccessToken();
    final response = await dio.get(
      '$baseUrl/user/$username/submitted',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {'limit': 100},
    );
    return (response.data['data']['children'] as List)
        .map((item) => RedditPost.fromJson(item['data']))
        .toList();
  }

  Future<List<RedditComment>> getUserComments(String username) async {
    final token = await _getAccessToken();
    final response = await dio.get(
      '$baseUrl/user/$username/comments',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
      queryParameters: {'limit': 100},
    );
    return (response.data['data']['children'] as List)
        .map((item) => RedditComment.fromJson(item['data']))
        .toList();
  }
}
```

---

## 🔄 Scrolling and Screen Time Tracking

### Platform-Specific Approaches:

#### iOS (Screen Time API):
```dart
// Requires Family Sharing API and user permission
import 'package:screen_time/screen_time.dart';

class IOSScreenTimeTracker {
  Future<Map<String, Duration>> getAppUsageTimes() async {
    // Request Screen Time permission
    final granted = await ScreenTime.requestAuthorization();
    
    if (granted) {
      final apps = [
        'com.instagram.app',
        'com.zhiliaoapp.musically', // TikTok
        'com.twitter.twitter',
        'com.google.ios.youtube',
        'com.facebook.Facebook',
        'com.snapchat.snapchat',
        'com.reddit.Reddit',
      ];
      
      final usageStats = await ScreenTime.getUsageStats(apps);
      return usageStats;
    }
    
    return {};
  }
}
```

#### Android (UsageStatsManager):
```dart
import 'package:usage_stats/usage_stats.dart';

class AndroidUsageTracker {
  Future<Map<String, Duration>> getAppUsageTimes() async {
    // Request usage access permission
    final granted = await UsageStats.checkUsagePermission();
    
    if (!granted) {
      await UsageStats.grantUsagePermission();
    }
    
    final endTime = DateTime.now();
    final startTime = endTime.subtract(const Duration(days: 1));
    
    final stats = await UsageStats.queryUsageStats(
      startTime.millisecondsSinceEpoch,
      endTime.millisecondsSinceEpoch,
    );
    
    final packageNames = {
      'com.instagram.android': 'Instagram',
      'com.zhiliaoapp.musically': 'TikTok',
      'com.twitter.android': 'X',
      'com.google.android.youtube': 'YouTube',
      'com.facebook.katana': 'Facebook',
      'com.snapchat.android': 'Snapchat',
      'com.reddit.frontpage': 'Reddit',
    };
    
    final Map<String, Duration> usageTimes = {};
    
    for (final stat in stats) {
      final appName = packageNames[stat.packageName];
      if (appName != null) {
        usageTimes[appName] = Duration(
          milliseconds: int.parse(stat.totalTimeInForeground ?? '0'),
        );
      }
    }
    
    return usageTimes;
  }
}
```

---

## 📊 Data Aggregation Service

### Create a unified tracking service:

```dart
class SocialMediaAggregator {
  final InstagramTracker instagram;
  final TikTokTracker tiktok;
  final XTwitterTracker xTwitter;
  final YouTubeTracker youtube;
  final FacebookTracker facebook;
  final SnapchatTracker snapchat;
  final RedditTracker reddit;
  
  SocialMediaAggregator({
    required this.instagram,
    required this.tiktok,
    required this.xTwitter,
    required this.youtube,
    required this.facebook,
    required this.snapchat,
    required this.reddit,
  });
  
  Future<UnifiedSocialStats> aggregateAllPlatforms() async {
    final results = await Future.wait([
      instagram.getRecentActivity(),
      tiktok.getUserVideos(),
      xTwitter.getUserTweets('user_id'),
      youtube.getWatchHistory(),
      facebook.getUserPosts(),
      snapchat.getUserProfile(),
      reddit.getUserPosts('username'),
    ]);
    
    return UnifiedSocialStats(
      totalPosts: _calculateTotalPosts(results),
      totalComments: _calculateTotalComments(results),
      totalShares: _calculateTotalShares(results),
      screenTime: await _calculateTotalScreenTime(),
      engagementRate: _calculateEngagementRate(results),
    );
  }
  
  Future<Duration> _calculateTotalScreenTime() async {
    if (Platform.isIOS) {
      final tracker = IOSScreenTimeTracker();
      final times = await tracker.getAppUsageTimes();
      return times.values.fold(Duration.zero, (sum, time) => sum + time);
    } else if (Platform.isAndroid) {
      final tracker = AndroidUsageTracker();
      final times = await tracker.getAppUsageTimes();
      return times.values.fold(Duration.zero, (sum, time) => sum + time);
    }
    return Duration.zero;
  }
}
```

---

## 🔐 Security and Privacy Considerations

### 1. Secure Credential Storage:
```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCredentialManager {
  static const _storage = FlutterSecureStorage();
  
  Future<void> storeAccessToken(String platform, String token) async {
    await _storage.write(key: '${platform}_access_token', value: token);
  }
  
  Future<String?> getAccessToken(String platform) async {
    return await _storage.read(key: '${platform}_access_token');
  }
  
  Future<void> deleteAccessToken(String platform) async {
    await _storage.delete(key: '${platform}_access_token');
  }
}
```

### 2. User Consent Management:
```dart
class ConsentManager {
  Future<bool> requestPlatformConsent(String platform) async {
    // Show consent dialog explaining data usage
    final consent = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect $platform'),
        content: Text(
          'CTRL needs access to your $platform account to track:\n\n'
          '• Posts and comments you make\n'
          '• Time spent on the platform\n'
          '• Engagement metrics\n\n'
          'Your data is stored securely and never shared.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Decline'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    
    if (consent == true) {
      await _storage.write(key: '${platform}_consent', value: 'true');
    }
    
    return consent ?? false;
  }
}
```

### 3. Rate Limiting:
```dart
class RateLimiter {
  final Map<String, List<DateTime>> _requestTimestamps = {};
  
  Future<bool> canMakeRequest(String platform, int maxRequests, Duration window) async {
    final now = DateTime.now();
    final timestamps = _requestTimestamps[platform] ?? [];
    
    // Remove timestamps outside the window
    timestamps.removeWhere((time) => now.difference(time) > window);
    
    if (timestamps.length >= maxRequests) {
      return false;
    }
    
    timestamps.add(now);
    _requestTimestamps[platform] = timestamps;
    return true;
  }
}
```

---

## 📦 Required Flutter Packages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  dio: ^5.7.0
  flutter_secure_storage: ^9.0.0
  usage_stats: ^2.0.0  # Android only
  # screen_time: ^1.0.0  # iOS only (if available)
  shared_preferences: ^2.2.2
  connectivity_plus: ^5.0.2
  
  # OAuth and authentication
  oauth2: ^2.0.2
  url_launcher: ^6.2.2
  
  # Local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
```

---

## 🚀 Implementation Roadmap (Final 15%)

### Week 1-2: API Integration
- [ ] Set up developer accounts for all platforms
- [ ] Implement OAuth flows
- [ ] Test API connections
- [ ] Handle error cases

### Week 3: Data Collection
- [ ] Implement tracking services for each platform
- [ ] Set up local data storage
- [ ] Create aggregation service
- [ ] Test data accuracy

### Week 4: Privacy & Security
- [ ] Implement secure credential storage
- [ ] Add user consent flows
- [ ] Create privacy policy
- [ ] GDPR/CCPA compliance checks

### Week 5: Testing & Polish
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] UI/UX refinements
- [ ] App Store submission preparation

---

## 📝 App Store Submission Requirements

### Privacy Declarations:
- Data collection disclosure
- Third-party SDK disclosure
- User data retention policies
- Right to deletion implementation

### Required Documentation:
- Privacy Policy URL
- Terms of Service URL
- Support email/website
- App review notes explaining social media tracking

---

## ⚠️ Important Notes

1. **API Costs**: Most social media APIs have free tiers, but monitor usage to avoid unexpected charges
2. **Rate Limits**: Implement proper rate limiting to avoid API throttling
3. **Token Refresh**: Implement automatic token refresh for long-lived sessions
4. **Offline Support**: Cache data locally for offline viewing
5. **Error Handling**: Gracefully handle API failures and network issues
6. **User Privacy**: Always obtain explicit consent before tracking
7. **Data Retention**: Implement data deletion after reasonable periods

---

## 🔗 Useful Resources

- [Meta for Developers](https://developers.facebook.com/)
- [TikTok for Developers](https://developers.tiktok.com/)
- [X Developer Platform](https://developer.x.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Snap Kit](https://kit.snapchat.com/)
- [Reddit API Documentation](https://www.reddit.com/dev/api/)

---

## Support

For implementation help:
1. Check platform-specific documentation
2. Review code examples in this guide
3. Test with sandbox/development accounts first
4. Monitor API usage and costs
5. Implement comprehensive error logging

Good luck with your app store submission! 🚀