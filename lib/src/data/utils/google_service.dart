import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mydictionaryapp/src/device/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/entities/exceptions.dart';
import 'package:mydictionaryapp/src/domain/entities/user.dart';

class GoogleService {
  late final _storeInteractor = GetIt.I<StoreInteractor>();
  late final _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  Future<GoogleSignInAuthentication> getGoogleAuthData() async {
    GoogleSignInAccount? _account = await _googleSignIn.signIn();
    final isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn && _account != null) {
      try {
        _storeInteractor.setUserData(
          UserData(_account.displayName ?? '', _account.email),
        );
        return await _account.authentication;
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