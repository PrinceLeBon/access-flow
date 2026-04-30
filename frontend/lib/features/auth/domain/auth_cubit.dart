import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../data/auth_repository.dart';
import '../../../core/storage/token_storage.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final data = await repository.login(email, password);
      emit(AuthAuthenticated(data['accessToken'], data['refreshToken']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final data = await repository.register(email, password, name);
      emit(AuthAuthenticated(data['accessToken'], data['refreshToken']));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> authenticate(String accessToken, String refreshToken) async {
    await TokenStorage.saveTokens(accessToken, refreshToken);
    emit(AuthAuthenticated(accessToken, refreshToken));
  }

  Future<void> logout() async {
    await TokenStorage.clearTokens();
    emit(AuthInitial());
  }
}
