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
    apiKey: 'AIzaSyBfoBkasjCMdl-GNk__XVNyzKggZsJTL-Y',
    appId: '1:328204242966:web:375e0c6bfdb85e95372537',
    messagingSenderId: '328204242966',
    projectId: 'pdpppms',
    authDomain: 'pdpppms.firebaseapp.com',
    storageBucket: 'pdpppms.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCwpP3saKG-eI0jUwX15IpshmQsf4tCcxU',
    appId: '1:328204242966:android:dc558ba00b146ef4372537',
    messagingSenderId: '328204242966',
    projectId: 'pdpppms',
    storageBucket: 'pdpppms.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJu-eWRl4nXxc1hENc4SRNqyCnTU6u8LY',
    appId: '1:328204242966:ios:14a9a61e5e329709372537',
    messagingSenderId: '328204242966',
    projectId: 'pdpppms',
    storageBucket: 'pdpppms.appspot.com',
    iosBundleId: 'com.tf.pdpppms.tfPdpppms',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJu-eWRl4nXxc1hENc4SRNqyCnTU6u8LY',
    appId: '1:328204242966:ios:14a9a61e5e329709372537',
    messagingSenderId: '328204242966',
    projectId: 'pdpppms',
    storageBucket: 'pdpppms.appspot.com',
    iosBundleId: 'com.tf.pdpppms.tfPdpppms',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBfoBkasjCMdl-GNk__XVNyzKggZsJTL-Y',
    appId: '1:328204242966:web:45b8bae5b96fd358372537',
    messagingSenderId: '328204242966',
    projectId: 'pdpppms',
    authDomain: 'pdpppms.firebaseapp.com',
    storageBucket: 'pdpppms.appspot.com',
  );

}