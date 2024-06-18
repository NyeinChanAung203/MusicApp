import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@riverpod
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository(
    sharedPreferences: ref.read(sharedPreferenceProvider),
  );
}

@riverpod
SharedPreferences sharedPreference(SharedPreferenceRef ref) {
  throw UnimplementedError();
}

class AuthLocalRepository {
  final SharedPreferences sharedPreferences;
  AuthLocalRepository({
    required this.sharedPreferences,
  });

  void setToken(String? token) async {
    if (token != null) {
      await sharedPreferences.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return sharedPreferences.getString('x-auth-token');
  }
}
