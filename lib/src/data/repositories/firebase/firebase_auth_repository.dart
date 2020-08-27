import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/utils/google_service.dart';
import 'package:mydictionaryapp/src/data/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final StoreInteractor _storeInteractor;
  final GoogleService _googleService;

  FirebaseAuthRepository()
      : _storeInteractor = GetIt.I<StoreInteractor>(),
        _googleService = GetIt.I<GoogleService>();

  @override
  Future<bool> get isLoggedIn async {
    final currentUser = await _auth.currentUser();
    final token = await _storeInteractor.getToken();
    return currentUser != null && token != null;
  }

  @override
  Future<void> loginWith(String service) async {
    try {
      final credential = await _getAuthCredential(service);
      final AuthResult authResult =
          await _auth.signInWithCredential(credential);

      final token = authResult.user.uid;
      await _storeInteractor.setToken(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthCredential> _getAuthCredential(String service) async {
    switch (service) {
      case GOOGLE:
        final googleAuthentication = await _googleService.getGoogleAuthData();

        return GoogleAuthProvider.getCredential(
          accessToken: googleAuthentication.accessToken,
          idToken: googleAuthentication.idToken,
        );
      default:
        throw AssertionError('Wrong service: $service');
    }
  }

  @override
  Future<bool> logOut() async {
    await _auth.signOut();
    await _googleService.signOut();
    return await _storeInteractor.clear();
  }
}
