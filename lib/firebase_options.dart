import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.

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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyCoD9hFryUm82tq5TucCGqZ85x5U9HR58A',
    appId: '1:75045023000:web:1234567890abcdef',
    messagingSenderId: '75045023000',
    projectId: 'park-ease-421508',
    authDomain: 'park-ease-421508.firebaseapp.com',
    storageBucket: 'park-ease-421508.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCoD9hFryUm82tq5TucCGqZ85x5U9HR58A',
    appId: '1:75045023000:android:5715a63f327960928ac26d',
    messagingSenderId: '75045023000',
    projectId: 'park-ease-421508',
    storageBucket: 'park-ease-421508.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoD9hFryUm82tq5TucCGqZ85x5U9HR58A',
    appId: '1:75045023000:ios:1234567890abcdef',
    messagingSenderId: '75045023000',
    projectId: 'park-ease-421508',
    storageBucket: 'park-ease-421508.appspot.com',
    iosBundleId: 'com.example.applicationparck',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoD9hFryUm82tq5TucCGqZ85x5U9HR58A',
    appId: '1:75045023000:ios:1234567890abcdef',
    messagingSenderId: '75045023000',
    projectId: 'park-ease-421508',
    storageBucket: 'park-ease-421508.appspot.com',
    iosBundleId: 'com.example.applicationparck',
  );
}
