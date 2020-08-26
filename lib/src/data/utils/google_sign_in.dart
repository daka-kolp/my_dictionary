import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';

final _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future<GoogleSignInAccount> getGoogleAccountData() async {
  final account = await _googleSignIn.signIn();
  final isSignedIn = await _googleSignIn.isSignedIn();
  if (isSignedIn) {
    await _googleSignIn.disconnect();
    return account;
  }

  throw GoogleLoginException();
}
