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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDAxbQkxPKTk3RB5TpcbnYn-pgimpkchqI',
    appId: '1:708822716512:web:7ccb9a18a920976cfa7305',
    messagingSenderId: '708822716512',
    projectId: 'whatsapp-clone-e2c6e',
    authDomain: 'whatsapp-clone-e2c6e.firebaseapp.com',
    storageBucket: 'whatsapp-clone-e2c6e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyActX2fr7suQUz_l-HHDhxGXB4agTTNOAY',
    appId: '1:708822716512:android:7e3346ac0939372ffa7305',
    messagingSenderId: '708822716512',
    projectId: 'whatsapp-clone-e2c6e',
    storageBucket: 'whatsapp-clone-e2c6e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBj8aIUa0wxWEFsh1fKOmaNNoPStTKRhrw',
    appId: '1:708822716512:ios:29145f12b850ad2efa7305',
    messagingSenderId: '708822716512',
    projectId: 'whatsapp-clone-e2c6e',
    storageBucket: 'whatsapp-clone-e2c6e.appspot.com',
    iosClientId: '708822716512-p6kssf1k45lcn52svv16egqai76vfmlb.apps.googleusercontent.com',
    iosBundleId: 'com.example.socialMedia',
  );
}
