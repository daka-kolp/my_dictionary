import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import 'package:mydictionaryapp/src/data/utils/google_service.dart';
import 'package:mydictionaryapp/src/device/utils/store_interator.dart';
import 'package:mydictionaryapp/src/domain/repositories_contracts/auth_repository.dart';

class FirebaseAuthRepository extends AuthRepository {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late final _storeInteractor = GetIt.I<StoreInteractor>();
  late final _googleService = GetIt.I<GoogleService>();

  @override
  Future<String> get userId async => await _storeInteractor.getToken();

  @override
  Future<void> loginWith(LoginService service) async {
    try {
      final credential = await _getAuthCredential(service);
      final authResult = await _auth.signInWithCredential(credential);
      final token = authResult.user!.uid;
      await _storeInteractor.setToken(token);
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthCredential> _getAuthCredential(LoginService service) async {
    switch (service) {
      case LoginService.google:
        final googleAuthentication = await _googleService.getGoogleAuthData();
        return GoogleAuthProvider.credential(
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
