import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/request_cubit.dart';
import '../domain/request_state.dart';

class RequestListScreen extends StatelessWidget {
  const RequestListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: BlocBuilder<RequestCubit, RequestState>(
        builder: (context, state) {
          if (state is RequestLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is RequestError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }
          if (state is RequestLoaded) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('No requests found.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final req = state.requests[i];
                return ListTile(
                  title: Text('${req['type']} - ${req['status']}'),
                  subtitle: Text(req['reason'] ?? ''),
                  trailing:
                      Text(req['createdAt']?.toString().substring(0, 10) ?? ''),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/create-request');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
