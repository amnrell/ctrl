import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../services/theme_manager_service.dart';
import '../../services/data_compliance_service.dart';
import '../../services/profile_preferences_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/constant.dart';
import '../auth/SIgnin/signin.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';
import '../settings_screen/settings_screen.dart';
import '../settings_screen/widgets/theme_customization_section_widget.dart';
import '../settings_screen/widgets/font_customization_section_widget.dart';
import 'widgets/regulation_layers_widget.dart';
import 'widgets/vibe_mood_explanation_widget.dart';
import 'widgets/regulation_style_widget.dart';
import 'widgets/identity_settings_widget.dart';
import 'widgets/personal_goals_widget.dart';
import 'widgets/data_transparency_widget.dart';
import 'widgets/premium_ai_learning_widget.dart';
import 'edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedRoll = "",
      userName = "",
      email = "",
      subscription = "",
      subscriptionEnd = "",
      phoneNo = "",
      userImage = "";
  final _googleSignIn = GoogleSignIn();
  Color _currentVibeColor = AppTheme.primaryZen;
  final ThemeManagerService _themeManager = ThemeManagerService();
  final DataComplianceService _complianceService = DataComplianceService();
  final ProfilePreferencesService _preferencesService =
      ProfilePreferencesService();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    getUserData();
    // Initialize services and load user data
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _themeManager.initialize(),
        _complianceService.initialize(),
        _preferencesService.initialize(),
      ]);

      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
          _isInitialized = true;
        });
      }
    });

    // Listen to theme changes
    _themeManager.addListener(() {
      if (mounted) {
        setState(() {
          _currentVibeColor = _themeManager.primaryVibeColor;
        });
      }
    });
  }

  @override
  void dispose() {
    _themeManager.removeListener(() {});
    super.dispose();
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  getUserData() async {
    final user = getStorage.read('user');
    if (user != null) {
      setState(() {
        userName = user.displayName ?? '';
        email = user.email ?? '';
        phoneNo = user.phoneNumber ?? '';
        userImage = user.photoURL ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = _currentVibeColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(),
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Get.to(() => SettingsScreen());
            },
            child: Icon(
              Icons.settings,
              size: 21,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DynamicBackgroundWidget(
              primaryColor: _currentVibeColor,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: Get.width,
                        height: 130,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          gradient: LinearGradient(
                            colors: [primaryColor, Colors.black],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfileScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0.0, bottom: 10),
                                    child: Text(
                                      userName.isNotEmpty
                                          ? userName
                                          : "John Doe",
                                      style: const TextStyle(
                                          fontSize: 17, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 60,
                        left: 25,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: userImage != ""
                                ? Image.network(
                                    userImage,
                                    fit: BoxFit.cover,
                                    height: 110,
                                    width: 110,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        "assets/images/blank_profile.png",
                                        fit: BoxFit.cover,
                                        height: 110,
                                        width: 110,
                                      );
                                    },
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return SizedBox(
                                        height: 110,
                                        width: 110,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    "assets/images/blank_profile.png",
                                    fit: BoxFit.cover,
                                    height: 110,
                                    width: 110,
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 28.0, top: 10),
                        child: Column(
                          children: [
                            // ignore: unnecessary_null_comparison
                            if (phoneNo.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    phoneNo,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            if (email.isNotEmpty)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: phoneNo != "" ? 30 : 30),
                  // Profile Options List
                  _buildProfileOptionsList(theme, primaryColor),
                  SizedBox(height: 2.h),

                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: deleteAccountConfirmationDialog,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(18, 0, 17, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.delete_outline_outlined,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Delete Account",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: logoutConfirmationDialog,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(18, 0, 17, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.logout,
                                size: 18,
                                color: Colors.red,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Log out",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  logoutConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Alert !",
          style: TextStyle(color: Colors.red),
        ),
        elevation: 5,
        titleTextStyle: const TextStyle(fontSize: 18),
        content: const Text("Are you sure want to logout?"),
        contentPadding: const EdgeInsets.only(left: 25, top: 10),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              _googleSignIn.disconnect();
              await getStorage.write('isLogin', 0);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
                (route) => false,
              );
            },
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'No',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  deleteAccountConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Alert !",
          style: TextStyle(color: Colors.red),
        ),
        elevation: 5,
        titleTextStyle: const TextStyle(fontSize: 18),
        content: const Text("Are you sure want to Delete\naccount?"),
        contentPadding: const EdgeInsets.only(left: 25, top: 10),
        actions: <Widget>[
          TextButton(
            onPressed: () async {},
            child: const Text(
              'Yes',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text(
              'No',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  details(String text, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(
            fontSize: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptionsList(ThemeData theme, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          children: [
            _buildProfileOptionItem(
              context,
              theme,
              primaryColor,
              'Regulation Layers',
              'Control which regulation tools are active',
              Icons.layers_outlined,
              () => _showLayersBottomSheet(context),
            ),
            _buildDivider(theme),
            _buildProfileOptionItem(
              context,
              theme,
              primaryColor,
              'Personalize',
              'Vibe themes, regulation style, and identity',
              Icons.person_outline,
              () => _showPersonalizeBottomSheet(context),
            ),
            _buildDivider(theme),
            _buildProfileOptionItem(
              context,
              theme,
              primaryColor,
              'Personal Goals',
              'Set and track your digital wellness goals',
              Icons.flag_outlined,
              () => _showGoalsBottomSheet(context),
            ),
            _buildDivider(theme),
            _buildProfileOptionItem(
              context,
              theme,
              primaryColor,
              'Data & Privacy',
              'Control your data and privacy settings',
              Icons.shield_outlined,
              () => _showDataBottomSheet(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOptionItem(
    BuildContext context,
    ThemeData theme,
    Color primaryColor,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: primaryColor,
                size: 24,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 0.3.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20.w,
      color: theme.colorScheme.outline.withValues(alpha: 0.15),
    );
  }

  void _showLayersBottomSheet(BuildContext context) {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading...')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Regulation Layers',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: RegulationLayersWidget(
                  preferencesService: _preferencesService,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPersonalizeBottomSheet(BuildContext context) {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading...')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Personalize',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    VibeMoodExplanationWidget(
                      themeManager: _themeManager,
                    ),
                    SizedBox(height: 2.h),
                    RegulationStyleWidget(
                      preferencesService: _preferencesService,
                    ),
                    SizedBox(height: 2.h),
                    IdentitySettingsWidget(
                      preferencesService: _preferencesService,
                    ),
                    SizedBox(height: 2.h),
                    PremiumAILearningWidget(
                      preferencesService: _preferencesService,
                    ),
                    SizedBox(height: 2.h),
                    ThemeCustomizationSectionWidget(
                      themeManager: _themeManager,
                      onThemeChanged: () => setState(() {}),
                    ),
                    SizedBox(height: 2.h),
                    FontCustomizationSectionWidget(
                      themeManager: _themeManager,
                      onFontChanged: () => setState(() {}),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalsBottomSheet(BuildContext context) {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading...')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Personal Goals',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: PersonalGoalsWidget(
                  preferencesService: _preferencesService,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDataBottomSheet(BuildContext context) {
    if (!_isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loading...')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Text(
                    'Data & Privacy',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: DataTransparencyWidget(
                  complianceService: _complianceService,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
