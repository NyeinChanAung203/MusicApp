import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/models/user_model.dart';
import 'package:client/features/auth/repositories/auth_local_repository.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late final AuthRemoteRepository _authRemoteRepository;
  late final AuthLocalRepository _authLocalRepository;
  late final CurrentUserNotifier _currentUserNotifier;

  @override
  AsyncValue<UserModel>? build() {
    _authRemoteRepository = ref.watch(authRemoteRepositoryProvider);
    _authLocalRepository = ref.watch(authLocalRepositoryProvider);
    _currentUserNotifier = ref.watch(currentUserNotifierProvider.notifier);
    return null;
  }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final res = await _authRemoteRepository.signUp(
        name: name, email: email, password: password);
    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncData(r),
    };
    debugPrint(val.toString());
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    final res =
        await _authRemoteRepository.login(email: email, password: password);
    final val = switch (res) {
      Left(value: final l) => state = AsyncError(l.message, StackTrace.current),
      Right(value: final r) => _loginSuccess(r),
    };
    debugPrint(val.toString());
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel userModel) {
    _authLocalRepository.setToken(userModel.token);
    _currentUserNotifier.addUser(userModel);
    return state = AsyncData(userModel);
  }

  Future<UserModel?> getData() async {
    state = const AsyncLoading();
    final token = _authLocalRepository.getToken();
    if (token != null) {
      final res = await _authRemoteRepository.getCurrentUser(token: token);
      final val = switch (res) {
        Left(value: final l) => state =
            AsyncError(l.message, StackTrace.current),
        Right(value: final r) => _getUserDataSuccess(r),
      };
      return val.value;
    }
    return null;
  }

  AsyncValue<UserModel> _getUserDataSuccess(UserModel userModel) {
    _currentUserNotifier.addUser(userModel);
    return state = AsyncValue.data(userModel);
  }
}
