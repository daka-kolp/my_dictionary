import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:mydictionaryapp/src/data/utils/google_sign_in.dart';
import 'package:mydictionaryapp/src/data/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StoreInteractor _storeInteractor;



  FirebaseAuthRepository() : _storeInteractor = GetIt.I<StoreInteractor>() {
    _auth.onAuthStateChanged.listen((event) {

    });
  }

  @override
  Future<bool> get isLoggedIn async {
    final currentUser = await _auth.currentUser();
    final token = await _storeInteractor.getToken();
    return currentUser != null && token != null;
  }

  @override
  Future<void> loginWith(String service) async {
    try {
//      final credential = await _auth.signInWithCredential(
//        await _getAuthCredential(service),
//      );
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult = await _auth.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
//
//      final token = await authResult.user.getIdToken();
//      await _storeInteractor.setToken(token.token);


    } catch (e) {
      rethrow;
    }
  }

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<AuthCredential> _getAuthCredential(String service) async {
    switch (service) {
      case GOOGLE:
        final googleSignInAccount = await getGoogleAccountData();
        final googleSignInAuthentication = await googleSignInAccount.authentication;
        return GoogleAuthProvider.getCredential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
      default:
        throw AssertionError('Wrong service: $service');
    }
  }

  @override
  Future<bool> logOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    return await _storeInteractor.clear();
  }
}
