import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:shared_preferences/shared_preferences.dart';

/// Social media platform configuration
class PlatformConfig {
  final String name;
  final String clientId;
  final String clientSecret;
  final String authorizationEndpoint;
  final String tokenEndpoint;
  final List<String> scopes;
  final String redirectUri;

  PlatformConfig({
    required this.name,
    required this.clientId,
    required this.clientSecret,
    required this.authorizationEndpoint,
    required this.tokenEndpoint,
    required this.scopes,
    required this.redirectUri,
  });
}

/// Service for managing social media OAuth connections
class SocialMediaOAuthService {
  static final SocialMediaOAuthService _instance =
      SocialMediaOAuthService._internal();
  factory SocialMediaOAuthService() => _instance;
  SocialMediaOAuthService._internal();

  // Platform configurations - These need to be set with your actual credentials
  final Map<String, PlatformConfig> _platformConfigs = {
    'twitter': PlatformConfig(
      name: 'X (Twitter)',
      clientId: const String.fromEnvironment('TWITTER_CLIENT_ID'),
      clientSecret: const String.fromEnvironment('TWITTER_CLIENT_SECRET'),
      authorizationEndpoint: 'https://twitter.com/i/oauth2/authorize',
      tokenEndpoint: 'https://api.twitter.com/2/oauth2/token',
      scopes: ['tweet.read', 'users.read', 'offline.access'],
      redirectUri: 'ctrlapp://oauth-callback',
    ),
    'instagram': PlatformConfig(
      name: 'Instagram',
      clientId: const String.fromEnvironment('INSTAGRAM_CLIENT_ID'),
      clientSecret: const String.fromEnvironment('INSTAGRAM_CLIENT_SECRET'),
      authorizationEndpoint: 'https://api.instagram.com/oauth/authorize',
      tokenEndpoint: 'https://api.instagram.com/oauth/access_token',
      scopes: ['user_profile', 'user_media'],
      redirectUri: 'ctrlapp://oauth-callback',
    ),
    'facebook': PlatformConfig(
      name: 'Facebook',
      clientId: const String.fromEnvironment('FACEBOOK_CLIENT_ID'),
      clientSecret: const String.fromEnvironment('FACEBOOK_CLIENT_SECRET'),
      authorizationEndpoint: 'https://www.facebook.com/v18.0/dialog/oauth',
      tokenEndpoint: 'https://graph.facebook.com/v18.0/oauth/access_token',
      scopes: ['public_profile', 'email', 'user_posts'],
      redirectUri: 'ctrlapp://oauth-callback',
    ),
    'tiktok': PlatformConfig(
      name: 'TikTok',
      clientId: const String.fromEnvironment('TIKTOK_CLIENT_ID'),
      clientSecret: const String.fromEnvironment('TIKTOK_CLIENT_SECRET'),
      authorizationEndpoint: 'https://www.tiktok.com/v2/auth/authorize',
      tokenEndpoint: 'https://open.tiktokapis.com/v2/oauth/token/',
      scopes: ['user.info.basic', 'video.list'],
      redirectUri: 'ctrlapp://oauth-callback',
    ),
    'reddit': PlatformConfig(
      name: 'Reddit',
      clientId: const String.fromEnvironment('REDDIT_CLIENT_ID'),
      clientSecret: const String.fromEnvironment('REDDIT_CLIENT_SECRET'),
      authorizationEndpoint: 'https://www.reddit.com/api/v1/authorize',
      tokenEndpoint: 'https://www.reddit.com/api/v1/access_token',
      scopes: ['identity', 'read', 'history'],
      redirectUri: 'ctrlapp://oauth-callback',
    ),
  };

  /// Check if platform is connected
  Future<bool> isConnected(String platformKey) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('${platformKey}_access_token');
    return token != null && token.isNotEmpty;
  }

  /// Get connection status for all platforms
  Future<Map<String, bool>> getAllConnectionStatuses() async {
    Map<String, bool> statuses = {};
    for (String key in _platformConfigs.keys) {
      statuses[key] = await isConnected(key);
    }
    return statuses;
  }

  /// Authenticate with social media platform
  Future<bool> authenticate(String platformKey) async {
    try {
      final config = _platformConfigs[platformKey];
      if (config == null) {
        throw Exception('Platform configuration not found');
      }

      // Validate credentials are configured
      if (config.clientId.isEmpty || config.clientSecret.isEmpty) {
        throw Exception(
            'OAuth credentials not configured for ${config.name}. Please add credentials to environment variables.');
      }

      // Create OAuth2 grant
      final grant = oauth2.AuthorizationCodeGrant(
        config.clientId,
        Uri.parse(config.authorizationEndpoint),
        Uri.parse(config.tokenEndpoint),
        secret: config.clientSecret,
      );

      // Build authorization URL
      final authorizationUrl = grant.getAuthorizationUrl(
        Uri.parse(config.redirectUri),
        scopes: config.scopes,
      );

      // Launch web authentication
      final result = await FlutterWebAuth2.authenticate(
        url: authorizationUrl.toString(),
        callbackUrlScheme: 'ctrlapp',
      );

      // Extract authorization code
      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) {
        throw Exception('Authorization code not received');
      }

      // Exchange code for access token
      final client = await grant.handleAuthorizationResponse(
        Uri.parse(result).queryParameters,
      );

      // Store credentials
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '${platformKey}_access_token',
        client.credentials.accessToken,
      );
      if (client.credentials.refreshToken != null) {
        await prefs.setString(
          '${platformKey}_refresh_token',
          client.credentials.refreshToken!,
        );
      }

      // Store connection timestamp
      await prefs.setString(
        '${platformKey}_connected_at',
        DateTime.now().toIso8601String(),
      );

      return true;
    } catch (e) {
      print('OAuth authentication error for $platformKey: $e');
      return false;
    }
  }

  /// Disconnect platform
  Future<bool> disconnect(String platformKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('${platformKey}_access_token');
      await prefs.remove('${platformKey}_refresh_token');
      await prefs.remove('${platformKey}_connected_at');
      return true;
    } catch (e) {
      print('Error disconnecting $platformKey: $e');
      return false;
    }
  }

  /// Get last sync timestamp
  Future<DateTime?> getLastSyncTime(String platformKey) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString('${platformKey}_connected_at');
    if (timestamp != null) {
      return DateTime.parse(timestamp);
    }
    return null;
  }

  /// Get platform display name
  String getPlatformName(String platformKey) {
    return _platformConfigs[platformKey]?.name ?? platformKey;
  }

  /// Get all available platforms
  List<String> getAvailablePlatforms() {
    return _platformConfigs.keys.toList();
  }

  /// Get platform icon name
  String getPlatformIcon(String platformKey) {
    switch (platformKey) {
      case 'twitter':
        return 'X';
      case 'instagram':
        return 'IG';
      case 'facebook':
        return 'FB';
      case 'tiktok':
        return 'TT';
      case 'reddit':
        return 'R';
      default:
        return platformKey.substring(0, 2).toUpperCase();
    }
  }
}
