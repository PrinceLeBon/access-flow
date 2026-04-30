import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/domain/auth_cubit.dart';
import 'features/auth/domain/auth_gate.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/auth/presentation/register_screen.dart';
import 'features/requests/data/request_repository.dart';
import 'features/requests/domain/request_cubit.dart';
import 'features/requests/presentation/request_list_screen.dart';
import 'features/requests/presentation/create_request_screen.dart';
import 'features/dashboard/presentation/dashboard_screen.dart';
import 'features/admin/data/admin_repository.dart';
import 'features/admin/domain/admin_cubit.dart';
import 'features/admin/presentation/admin_panel_screen.dart';

void main() {
  runApp(const AccessFlowApp());
}

class AccessFlowApp extends StatelessWidget {
  const AccessFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthRepository()),
        ),
        BlocProvider<RequestCubit>(
          create: (_) => RequestCubit(RequestRepository()),
        ),
        BlocProvider<AdminCubit>(
          create: (_) => AdminCubit(AdminRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'AccessFlow',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const AuthGate(dashboard: DashboardScreen()),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/requests': (context) => const RequestListScreen(),
          '/create-request': (context) => const CreateRequestScreen(),
          '/admin': (context) => const AdminPanelScreen(),
        },
      ),
    );
  }
}
