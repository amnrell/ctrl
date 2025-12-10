import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../services/bigquery_data_service.dart';
import '../../services/social_media_oauth_service.dart';
import '../../widgets/custom_app_bar.dart';
import './widgets/connection_status_widget.dart';
import './widgets/platform_card_widget.dart';
import './widgets/privacy_controls_widget.dart';

/// Social Media OAuth Connection Screen
/// Enables secure platform authentication through OAuth flows
class SocialMediaOAuthConnection extends StatefulWidget {
  const SocialMediaOAuthConnection({super.key});

  @override
  State<SocialMediaOAuthConnection> createState() =>
      _SocialMediaOAuthConnectionState();
}

class _SocialMediaOAuthConnectionState
    extends State<SocialMediaOAuthConnection> {
  final SocialMediaOAuthService _oauthService = SocialMediaOAuthService();
  final BigQueryDataService _bigQueryService = BigQueryDataService();

  Map<String, bool> _connectionStatuses = {};
  bool _isLoading = true;
  bool _bigQueryEnabled = false;
  bool _analyticsEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    setState(() => _isLoading = true);

    try {
      await _bigQueryService.initialize();

      final statuses = await _oauthService.getAllConnectionStatuses();

      setState(() {
        _connectionStatuses = statuses;
        _bigQueryEnabled = _bigQueryService.isConfigured();
        _isLoading = false;
      });
    } catch (e) {
      print('Error initializing services: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _connectPlatform(String platformKey) async {
    HapticFeedback.mediumImpact();

    setState(() => _isLoading = true);

    try {
      final success = await _oauthService.authenticate(platformKey);

      if (success && mounted) {
        final statuses = await _oauthService.getAllConnectionStatuses();
        setState(() {
          _connectionStatuses = statuses;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_oauthService.getPlatformName(platformKey)} connected successfully',
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Log connection event to BigQuery
        if (_bigQueryEnabled && _analyticsEnabled) {
          await _bigQueryService.sendUsageData({
            'event_type': 'platform_connected',
            'platform': platformKey,
            'timestamp': DateTime.now().toIso8601String(),
          });
        }
      } else if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Connection failed. Please check credentials and try again.',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Connection error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _disconnectPlatform(String platformKey) async {
    HapticFeedback.lightImpact();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text('Disconnect ${_oauthService.getPlatformName(platformKey)}?'),
        content: const Text(
          'This will remove access to your account data. You can reconnect anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      final success = await _oauthService.disconnect(platformKey);

      if (success && mounted) {
        final statuses = await _oauthService.getAllConnectionStatuses();
        setState(() {
          _connectionStatuses = statuses;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${_oauthService.getPlatformName(platformKey)} disconnected',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Connect Social Media',
        variant: CustomAppBarVariant.withBack,
        onLeadingPressed: () => Navigator.pop(context),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderSection(theme),
                      SizedBox(height: 3.h),
                      ConnectionStatusWidget(
                        connectionStatuses: _connectionStatuses,
                      ),
                      SizedBox(height: 3.h),
                      _buildSectionTitle(theme, 'Available Platforms'),
                      SizedBox(height: 2.h),
                      _buildPlatformsList(theme),
                      SizedBox(height: 3.h),
                      PrivacyControlsWidget(
                        bigQueryEnabled: _bigQueryEnabled,
                        analyticsEnabled: _analyticsEnabled,
                        onAnalyticsToggle: (value) {
                          setState(() => _analyticsEnabled = value);
                        },
                      ),
                      SizedBox(height: 3.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.security,
                color: theme.colorScheme.primary,
                size: 28,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Secure OAuth Connection',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.5.h),
          Text(
            'Connect your social media accounts securely using industry-standard OAuth 2.0 authentication. Your credentials are never stored.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildPlatformsList(ThemeData theme) {
    final platforms = _oauthService.getAvailablePlatforms();

    return Column(
      children: platforms.map((platformKey) {
        final isConnected = _connectionStatuses[platformKey] ?? false;

        return Padding(
          padding: EdgeInsets.only(bottom: 2.h),
          child: PlatformCardWidget(
            platformKey: platformKey,
            platformName: _oauthService.getPlatformName(platformKey),
            platformIcon: _oauthService.getPlatformIcon(platformKey),
            isConnected: isConnected,
            onConnect: () => _connectPlatform(platformKey),
            onDisconnect: () => _disconnectPlatform(platformKey),
            oauthService: _oauthService,
          ),
        );
      }).toList(),
    );
  }
}
