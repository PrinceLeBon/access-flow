import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/admin_cubit.dart';
import '../domain/admin_state.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().fetchAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AdminError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }
          if (state is AdminLoaded) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('No requests found.'));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.requests.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final req = state.requests[i];
                return Card(
                  child: ListTile(
                    title: Text('${req['type']} - ${req['status']}'),
                    subtitle: Text(req['reason'] ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (req['status'] == 'PENDING') ...[
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () {
                              context.read<AdminCubit>().updateRequest(
                                  req['id'], {'status': 'APPROVED'});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () async {
                              final reason = await showDialog<String>(
                                context: context,
                                builder: (context) {
                                  String rejectionReason = '';
                                  return AlertDialog(
                                    title: const Text('Rejection Reason'),
                                    content: TextField(
                                      onChanged: (v) => rejectionReason = v,
                                      decoration: const InputDecoration(
                                          labelText: 'Reason'),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(
                                            context, rejectionReason),
                                        child: const Text('Reject'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (reason != null && reason.isNotEmpty) {
                                context.read<AdminCubit>().updateRequest(
                                    req['id'], {
                                  'status': 'REJECTED',
                                  'rejectionReason': reason
                                });
                              }
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
