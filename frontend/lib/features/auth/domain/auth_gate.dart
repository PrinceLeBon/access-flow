import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/storage/token_storage.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';
import '../presentation/login_screen.dart';

class AuthGate extends StatefulWidget {
  final Widget dashboard;
  const AuthGate({super.key, required this.dashboard});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final accessToken = await TokenStorage.getAccessToken();
    final refreshToken = await TokenStorage.getRefreshToken();
    if (accessToken != null && context.mounted) {
      context.read<AuthCubit>().authenticate(accessToken, refreshToken ?? '');
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return widget.dashboard;
        }
        return const LoginScreen();
      },
    );
  }
}
