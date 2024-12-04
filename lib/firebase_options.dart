// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBDhXIkiOh6IutCeOTRpLZMEXDG6XLsndE',
    appId: '1:379645001228:web:c52356f819b436d885f829',
    messagingSenderId: '379645001228',
    projectId: 'parking-app-41b02',
    authDomain: 'parking-app-41b02.firebaseapp.com',
    storageBucket: 'parking-app-41b02.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAg82CbhRavT-3vvlvIkAaR5aQUF_VD2_Q',
    appId: '1:379645001228:android:92fda256eb181fee85f829',
    messagingSenderId: '379645001228',
    projectId: 'parking-app-41b02',
    storageBucket: 'parking-app-41b02.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA-wXKhPxApLg1ulhAHIER8kekWDZCLGck',
    appId: '1:379645001228:ios:08a0af2a3f58809985f829',
    messagingSenderId: '379645001228',
    projectId: 'parking-app-41b02',
    storageBucket: 'parking-app-41b02.firebasestorage.app',
    iosClientId: '379645001228-nclm6huva39i4anplmphg779g0li5346.apps.googleusercontent.com',
    iosBundleId: 'com.smartparking.smartParkingApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA-wXKhPxApLg1ulhAHIER8kekWDZCLGck',
    appId: '1:379645001228:ios:08a0af2a3f58809985f829',
    messagingSenderId: '379645001228',
    projectId: 'parking-app-41b02',
    storageBucket: 'parking-app-41b02.firebasestorage.app',
    iosClientId: '379645001228-nclm6huva39i4anplmphg779g0li5346.apps.googleusercontent.com',
    iosBundleId: 'com.smartparking.smartParkingApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBDhXIkiOh6IutCeOTRpLZMEXDG6XLsndE',
    appId: '1:379645001228:web:98eb0c830e443e6885f829',
    messagingSenderId: '379645001228',
    projectId: 'parking-app-41b02',
    authDomain: 'parking-app-41b02.firebaseapp.com',
    storageBucket: 'parking-app-41b02.firebasestorage.app',
  );
}