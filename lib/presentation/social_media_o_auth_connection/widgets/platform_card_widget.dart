import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

import '../../../services/social_media_oauth_service.dart';

/// Platform card widget for OAuth connection
class PlatformCardWidget extends StatelessWidget {
  final String platformKey;
  final String platformName;
  final String platformIcon;
  final bool isConnected;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;
  final SocialMediaOAuthService oauthService;

  const PlatformCardWidget({
    super.key,
    required this.platformKey,
    required this.platformName,
    required this.platformIcon,
    required this.isConnected,
    required this.onConnect,
    required this.onDisconnect,
    required this.oauthService,
  });

  Color _getPlatformColor() {
    switch (platformKey) {
      case 'twitter':
        return Colors.black;
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'tiktok':
        return Colors.black;
      case 'reddit':
        return const Color(0xFFFF4500);
      default:
        return Colors.grey;
    }
  }

  List<String> _getRequiredPermissions() {
    switch (platformKey) {
      case 'twitter':
        return ['Read tweets', 'User profile', 'Engagement metrics'];
      case 'instagram':
        return ['User profile', 'Media content', 'Insights'];
      case 'facebook':
        return ['Public profile', 'Posts', 'User data'];
      case 'tiktok':
        return ['User info', 'Video list', 'Statistics'];
      case 'reddit':
        return ['Identity', 'Read posts', 'History'];
      default:
        return ['Basic profile', 'Content access'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platformColor = _getPlatformColor();

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected
              ? platformColor.withValues(alpha: 0.3)
              : theme.colorScheme.outline.withValues(alpha: 0.2),
          width: isConnected ? 2 : 1,
        ),
        boxShadow: isConnected
            ? [
                BoxShadow(
                  color: platformColor.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isConnected ? null : onConnect,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildPlatformIcon(theme, platformColor),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            platformName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          _buildConnectionStatus(theme, platformColor),
                        ],
                      ),
                    ),
                    _buildActionButton(theme, platformColor),
                  ],
                ),
                if (isConnected) ...[
                  SizedBox(height: 2.h),
                  _buildLastSyncInfo(theme),
                ],
                SizedBox(height: 2.h),
                _buildPermissionsList(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformIcon(ThemeData theme, Color platformColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: platformColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: platformColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Center(
        child: Text(
          platformIcon,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: platformColor,
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(ThemeData theme, Color platformColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: isConnected ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          isConnected ? 'Connected' : 'Not Connected',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isConnected
                ? Colors.green
                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(ThemeData theme, Color platformColor) {
    return ElevatedButton(
      onPressed: isConnected ? onDisconnect : onConnect,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isConnected ? Colors.red.withValues(alpha: 0.1) : platformColor,
        foregroundColor: isConnected ? Colors.red : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isConnected
              ? BorderSide(color: Colors.red.withValues(alpha: 0.3))
              : BorderSide.none,
        ),
        elevation: 0,
      ),
      child: Text(
        isConnected ? 'Disconnect' : 'Connect',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLastSyncInfo(ThemeData theme) {
    return FutureBuilder<DateTime?>(
      future: oauthService.getLastSyncTime(platformKey),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final lastSync = snapshot.data!;
          final formatter = DateFormat('MMM d, y • h:mm a');

          return Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Last synced: ${formatter.format(lastSync)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildPermissionsList(ThemeData theme) {
    final permissions = _getRequiredPermissions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Required Permissions:',
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 1.h),
        ...permissions.map((permission) => Padding(
              padding: EdgeInsets.only(bottom: 0.5.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    permission,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
