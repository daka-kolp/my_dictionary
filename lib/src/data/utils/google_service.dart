import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';

class GoogleService {
  final _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  GoogleSignInAccount? _account;

  Future<GoogleSignInAuthentication> getGoogleAuthData() async {
    _account = await _googleSignIn.signIn();
    final isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      try {
        return await _account!.authentication;
      } finally {
        await _googleSignIn.disconnect();
      }
    }
    throw GoogleLoginException();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}