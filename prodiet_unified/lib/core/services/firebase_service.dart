import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  FirebaseApp get app => Firebase.app();
  FirebaseCrashlytics get crashlytics => FirebaseCrashlytics.instance;
  FirebaseMessaging get messaging => FirebaseMessaging.instance;

  // Add more Firebase services as needed (Firestore, Auth if used alongside Supabase, etc.)
}

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});
