import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import 'anonymous_auth_service.dart';

@LazySingleton(as: AnonymousAuthService)
class FirebaseAnonymousAuthService
    implements AnonymousAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAnonymousAuthService(this._firebaseAuth);

  @override
  Future<String> ensureSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;

    if (currentUser != null) {
      return currentUser.uid;
    }

    final credential =
    await _firebaseAuth.signInAnonymously();

    final user = credential.user;

    if (user == null) {
      throw StateError('Anonymous sign-in failed');
    }

    return user.uid;
  }
}