# AdMob Setup Guide

## Android Setup

1. **Add App ID to AndroidManifest.xml**
   ```xml
   <manifest>
       <application>
           <meta-data
               android:name="com.google.android.gms.ads.APPLICATION_ID"
               android:value="ca-app-pub-3940256099942544~3347511713"/>
       </application>
   </manifest>
   ```

2. **Add Internet Permission** (if not already present)
   ```xml
   <uses-permission android:name="android.permission.INTERNET"/>
   <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
   ```

3. **Update build.gradle**
   ```gradle
   dependencies {
       implementation 'com.google.android.gms:play-services-ads:22.6.0'
   }
   ```

## iOS Setup

1. **Add App ID to Info.plist**
   ```xml
   <key>GADApplicationIdentifier</key>
   <string>ca-app-pub-3940256099942544~3347511713</string>
   ```

2. **Update Podfile**
   ```ruby
   pod 'Google-Mobile-Ads-SDK'
   ```

3. **Run pod install**
   ```bash
   cd ios
   pod install
   ```

## Web Setup

1. **Add AdMob Script** to `web/index.html`
   ```html
   <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-app-pub-xxxxx"
        crossorigin="anonymous"></script>
   ```

## Test Ad Units

The template uses Google's test ad units by default:
- App ID: `ca-app-pub-3940256099942544~3347511713`
- Banner: `ca-app-pub-3940256099942544/6300978111`
- Interstitial: `ca-app-pub-3940256099942544/1033173712`

## Production

1. Create your own ad units in AdMob Console
2. Update `lib/core/config/app_config.dart` with your ad unit IDs
3. Update AndroidManifest.xml and Info.plist with your App ID
4. Test thoroughly before publishing

## AdMob Policies

- Ensure your app complies with AdMob policies
- Don't click your own ads
- Provide proper ad placement
- Follow content policies

