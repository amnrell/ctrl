# 🚀 CTRL App Publishing Guide

## 📋 Pre-Publishing Checklist

### ✅ Final UX Polish Recommendations

#### 1. **Bottom Navigation Enhancement**
- ✅ CTRL logo implemented in navigation
- ✅ All navigation items properly styled
- ✅ Active state indicators working

#### 2. **Analytics Dashboard Polish**
- ✅ Platform logos displayed correctly (Instagram, TikTok, X, YouTube, Facebook, Snapchat, Reddit)
- ✅ Social media tracking interface functional
- ✅ Chart data visualization working
- ⚠️ **IMPORTANT**: Update with real API integrations before launch (see SOCIAL_MEDIA_INTEGRATION_GUIDE.md)

#### 3. **Feedback System**
- ✅ In-app rating prompts configured
- ✅ Emoji reactions for quick feedback
- ✅ Comprehensive feedback form with categories
- ✅ Screenshot attachment capability
- ✅ Thank you flow implemented

#### 4. **User Experience Flow**
- ✅ Splash screen → Onboarding → Dashboard flow complete
- ✅ All navigation paths functional
- ✅ Settings panel fully configured
- ✅ Theme customization working

---

## 📱 App Store Submission (iOS)

### Step 1: Apple Developer Account Setup
1. **Enroll in Apple Developer Program** ($99/year)
   - Visit: https://developer.apple.com/programs/
   - Complete enrollment with business/individual details
   - Verify account (takes 24-48 hours)

2. **App Store Connect Setup**
   - Login: https://appstoreconnect.apple.com/
   - Create new app
   - Bundle ID: `com.ctrl.app` (must match project)
   - App Name: "CTRL - Digital Wellbeing"
   - SKU: `ctrl-wellbeing-001`

### Step 2: App Metadata Preparation

#### Required Assets
```
App Icon:
- 1024x1024px (PNG, no transparency)
- Must be unique and represent your brand

Screenshots (Required for iPhone):
- 6.7" Display (1290 x 2796px) - iPhone 15 Pro Max
- 6.5" Display (1284 x 2778px) - iPhone 14 Pro Max
- 5.5" Display (1242 x 2208px) - iPhone 8 Plus

Screenshots (Optional but Recommended):
- iPad Pro 12.9" (2048 x 2732px)
```

#### App Description Template
```
**Take Control of Your Digital Life**

CTRL helps you build healthier relationships with social media through:

🎯 Smart Vibe Management
Choose your mood and let CTRL optimize your digital experience

📊 Usage Analytics
Track time across Instagram, TikTok, X, YouTube, Facebook, Snapchat, and Reddit

🤖 AI-Powered Insights
Get personalized recommendations for better digital wellbeing

✨ Beautiful Design
Customizable themes that adapt to your preferences

🔐 Privacy First
Your data stays on your device - we never share or sell it

Perfect for anyone looking to:
- Reduce doom scrolling
- Build mindful social media habits
- Understand their digital patterns
- Take back control of their time

Download CTRL today and start your digital wellbeing journey!
```

#### Keywords (100 character limit)
```
digital wellbeing,social media,time tracking,mindfulness,productivity,focus,screen time,habits
```

#### App Categories
- Primary: Health & Fitness
- Secondary: Productivity

### Step 3: Build Configuration

#### Update Version & Build Numbers
In `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Format: version+build
```

#### iOS Build Settings
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner → Signing & Capabilities
3. Enable "Automatically manage signing"
4. Select your Apple Developer Team
5. Set Deployment Target: iOS 12.0+

#### Build Archive
```bash
# Clean build
flutter clean
flutter pub get

# Build iOS release
flutter build ios --release

# Or build IPA directly
flutter build ipa --release
```

### Step 4: TestFlight Beta Testing

#### Upload to TestFlight
1. Open Xcode
2. Product → Archive
3. Window → Organizer
4. Select latest archive
5. Click "Distribute App"
6. Choose "App Store Connect"
7. Upload

#### Add Beta Testers
1. Go to App Store Connect → TestFlight
2. Add Internal Testers (up to 100, instant access)
3. Add External Testers (public beta, requires Apple review)

#### Share TestFlight Link
```
https://testflight.apple.com/join/YOUR_CODE_HERE
```
Send this link to friends for alpha testing!

### Step 5: App Review Submission

#### Privacy Policy (REQUIRED)
Host a privacy policy at: `https://yourwebsite.com/privacy`

Template: https://www.privacypolicygenerator.info/

#### App Review Information
- Demo Account: Create test credentials if login required
- Notes: "This app requires iOS 12.0+. Social media tracking features require user permissions."
- Contact Email: your.support@email.com
- Contact Phone: Your phone number

#### Submit for Review
1. Complete all metadata
2. Upload all required screenshots
3. Set pricing (Free)
4. Submit for review
5. Review time: 24-48 hours typically

---

## 🤖 Google Play Store (Android)

### Step 1: Google Play Console Setup
1. **Create Developer Account** ($25 one-time fee)
   - Visit: https://play.google.com/console
   - Pay registration fee
   - Complete account verification

2. **Create New App**
   - App name: "CTRL - Digital Wellbeing"
   - Default language: English
   - App type: Free
   - Category: Health & Fitness

### Step 2: App Metadata

#### Required Assets
```
App Icon:
- 512x512px (PNG, 32-bit with transparency)

Feature Graphic:
- 1024x500px (PNG or JPG)

Screenshots:
- Phone: At least 2 (min 320px, max 3840px)
- 7-inch Tablet: Optional
- 10-inch Tablet: Optional
```

#### Store Listing
- Short Description (80 chars): "Take control of your digital life with smart social media tracking"
- Full Description (4000 chars): Use same template as iOS
- App Category: Health & Fitness
- Content Rating: Everyone

### Step 3: Android Build Configuration

#### Update Build Settings
In `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        versionCode 1
        versionName "1.0.0"
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

#### Generate Signing Key
```bash
keytool -genkey -v -keystore ~/ctrl-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ctrl
```

#### Configure Signing
Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=ctrl
storeFile=../ctrl-release-key.jks
```

Add to `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### Build Release APK/AAB
```bash
# Build App Bundle (recommended)
flutter build appbundle --release

# Or build APK
flutter build apk --release --split-per-abi
```

Output location: `build/app/outputs/bundle/release/app-release.aab`

### Step 4: Internal Testing Track

1. Go to Play Console → Testing → Internal testing
2. Create new release
3. Upload AAB file
4. Add release notes
5. Add testers via email lists
6. Save and publish to internal testing

#### Share Internal Testing Link
Testers can install via:
```
https://play.google.com/apps/internaltest/YOUR_APP_ID
```

### Step 5: Production Release

#### Content Rating Questionnaire
1. Complete IARC questionnaire
2. Questions about violence, language, etc.
3. For CTRL: Should get "Everyone" rating

#### Privacy Policy
- Must host privacy policy URL
- Required for all apps

#### Submit for Review
1. Production → Create new release
2. Upload AAB
3. Add release notes
4. Set rollout percentage (start with 20%)
5. Review and rollout
6. Review time: 2-7 days typically

---

## 🧪 Alpha Testing Distribution Methods

### Method 1: TestFlight (iOS) - RECOMMENDED
**Pros:**
- Official Apple distribution
- Up to 10,000 external testers
- Automatic updates
- Crash reporting included

**Setup:**
1. Upload build to App Store Connect
2. Go to TestFlight tab
3. Add testers by email
4. They receive invitation email
5. Install TestFlight app
6. Download CTRL from TestFlight

### Method 2: Internal Testing (Android) - RECOMMENDED
**Pros:**
- Official Google distribution
- Quick setup
- Up to 100 testers
- Automatic updates

**Setup:**
1. Upload AAB to Play Console
2. Internal Testing → Add testers
3. Share opt-in URL
4. Testers click link to join
5. Download from Play Store

### Method 3: Ad Hoc Distribution (iOS)
**Pros:**
- No TestFlight required
- Direct IPA distribution

**Cons:**
- Requires UDID registration
- Max 100 devices per year
- Manual updates

**Setup:**
1. Get tester UDIDs
2. Add to Provisioning Profile
3. Build with ad hoc profile
4. Distribute IPA via email/website
5. Install via iTunes or Apple Configurator

### Method 4: APK Direct Distribution (Android)
**Pros:**
- Instant distribution
- No store registration needed

**Cons:**
- Manual updates
- Security warnings for users
- No automatic crash reports

**Setup:**
1. Build release APK
2. Host on website or send via email
3. Users must enable "Install from Unknown Sources"
4. Install APK directly

---

## 📊 App Analytics Setup (Optional but Recommended)

### Firebase Analytics (FREE)
1. Create Firebase project: https://console.firebase.google.com
2. Add iOS and Android apps
3. Download `GoogleService-Info.plist` (iOS)
4. Download `google-services.json` (Android)
5. Follow Firebase setup instructions
6. Track: installs, active users, retention, crashes

### App Store Connect Analytics (Built-in)
- Automatic metrics: impressions, downloads, ratings
- Available in App Store Connect dashboard

### Google Play Console Analytics (Built-in)
- Automatic metrics: installs, crashes, ratings
- Available in Play Console dashboard

---

## 🎯 Launch Checklist

### Before Submission
- [ ] All screens tested on both iOS and Android
- [ ] Navigation flows complete
- [ ] Error handling implemented
- [ ] Privacy policy created and hosted
- [ ] App icon finalized (1024x1024)
- [ ] Screenshots captured (all required sizes)
- [ ] App description written
- [ ] Keywords researched and selected
- [ ] Support email configured
- [ ] Terms of service created (if required)

### iOS Specific
- [ ] Bundle ID matches (`com.ctrl.app`)
- [ ] Signing certificates configured
- [ ] App Store Connect metadata complete
- [ ] TestFlight build uploaded
- [ ] Beta testers invited
- [ ] App Review information complete

### Android Specific
- [ ] Package name matches (`com.ctrl.app`)
- [ ] Signing key generated and secured
- [ ] Google Play metadata complete
- [ ] Internal testing track configured
- [ ] Content rating completed
- [ ] Target API level 34 (Android 14)

### Post-Launch
- [ ] Monitor crash reports
- [ ] Respond to user reviews
- [ ] Track analytics metrics
- [ ] Plan update schedule
- [ ] Collect user feedback
- [ ] Implement feature requests

---

## 🆘 Common Issues & Solutions

### iOS Build Errors
**Error:** "Provisioning profile doesn't include signing certificate"
- Solution: Xcode → Preferences → Accounts → Download Manual Profiles

**Error:** "Code signing entitlements error"
- Solution: Clean build folder, delete DerivedData, rebuild

### Android Build Errors
**Error:** "Unable to find bundletool.jar"
- Solution: Update Android SDK tools, accept licenses

**Error:** "Gradle build failed"
- Solution: Update gradle version in `android/gradle/wrapper/gradle-wrapper.properties`

### TestFlight Issues
**Problem:** Build stuck "Processing"
- Wait 10-30 minutes, Apple's processing time

**Problem:** External testing requires review
- First external build always reviewed (24-48 hours)

### Play Console Issues
**Problem:** "APK signature error"
- Ensure proper signing configuration
- Use same keystore for updates

**Problem:** "This release is not compliant with Google Play policies"
- Check target API level (must be 33+)
- Review policy violations in email

---

## 📞 Support Resources

### Apple
- Developer Support: https://developer.apple.com/support/
- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/
- TestFlight Documentation: https://developer.apple.com/testflight/

### Google
- Play Console Help: https://support.google.com/googleplay/android-developer/
- Play Store Policies: https://play.google.com/about/developer-content-policy/
- Internal Testing Guide: https://support.google.com/googleplay/android-developer/answer/9845334

### Flutter
- Building iOS Apps: https://docs.flutter.dev/deployment/ios
- Building Android Apps: https://docs.flutter.dev/deployment/android
- Flutter DevTools: https://docs.flutter.dev/development/tools/devtools

---

## 🎉 You're Ready to Launch!

Once you've completed the checklist above, you're ready to submit CTRL to both app stores. Remember:

1. **Start with Beta Testing** - TestFlight and Internal Testing are your friends
2. **Gather Feedback Early** - Your alpha testers will find issues you missed
3. **Iterate Quickly** - Use beta periods to fix bugs before public launch
4. **Monitor Analytics** - Track what users do and don't like
5. **Respond to Reviews** - Engage with your users on both stores

Good luck with your launch! 🚀