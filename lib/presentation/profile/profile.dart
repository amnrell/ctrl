import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../services/theme_manager_service.dart';
import '../../services/data_compliance_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/constant.dart';
import '../auth/SIgnin/signin.dart';
import '../main_dashboard/widgets/dynamic_background_widget.dart';
import '../settings_screen/settings_screen.dart';
import '../settings_screen/widgets/theme_customization_section_widget.dart';
import '../settings_screen/widgets/font_customization_section_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
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
  late TabController _tabController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Initialize services
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _themeManager.initialize(),
        _complianceService.initialize(),
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
    _tabController.dispose();
    _themeManager.removeListener(() {});
    super.dispose();
  }

  String formatDate(String isoDate) {
    DateTime dateTime = DateTime.parse(isoDate);
    return DateFormat('dd MMM yyyy').format(dateTime);
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
                                    onTap: () async {},
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all()),
                                        child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 0.0, bottom: 10),
                                    child: Text(
                                      "Jonh Den",
                                      style: const TextStyle(fontSize: 23),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 80,
                        left: 25,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.phone,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "+81 90-1234-5678",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "jonh@gmail.com",
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
                  SizedBox(height: phoneNo != "" ? 20 : 30),
                  // Tab Bar
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.15),
                      ),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelColor: primaryColor,
                      unselectedLabelColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      labelStyle: theme.textTheme.labelMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      unselectedLabelStyle: theme.textTheme.labelMedium,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Layers'),
                        Tab(text: 'Personalize'),
                        Tab(text: 'Goals'),
                        Tab(text: 'Data'),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Tab View - Calculate height based on screen size
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildLayersTab(theme),
                        _buildPersonalizeTab(theme),
                        _buildGoalsTab(theme),
                        _buildDataTab(theme),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.to(() => SettingsScreen());
                    },
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings,
                                size: 18,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Settings",
                                style: TextStyle(
                                  fontSize: 16,
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
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Delete Account",
                                style: TextStyle(
                                  fontSize: 16,
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
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Log out",
                                style: TextStyle(
                                  fontSize: 16,
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
        title: const Text("Alert !"),
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
        title: const Text("Alert !"),
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

  Widget _buildLayersTab(ThemeData theme) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        ],
      ),
    );
  }

  Widget _buildPersonalizeTab(ThemeData theme) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
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
        ],
      ),
    );
  }

  Widget _buildGoalsTab(ThemeData theme) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
         
        ],
      ),
    );
  }

  Widget _buildDataTab(ThemeData theme) {
    if (!_isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
      
        ],
      ),
    );
  }
}
