import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/request_cubit.dart';
import '../domain/request_state.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'WITHDRAW';
  String _reason = '';
  String? _resource;
  double? _amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Request')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'WITHDRAW', child: Text('Withdraw')),
                  DropdownMenuItem(value: 'DEPOSIT', child: Text('Deposit')),
                  DropdownMenuItem(value: 'ACCESS', child: Text('Access')),
                ],
                onChanged: (v) => setState(() => _type = v!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 16),
              if (_type == 'WITHDRAW' || _type == 'DEPOSIT')
                TextFormField(
                  initialValue: _amount?.toString(),
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => _amount = double.tryParse(v),
                  validator: (v) =>
                      _type != 'ACCESS' && (v == null || v.isEmpty)
                          ? 'Amount required'
                          : null,
                ),
              if (_type == 'ACCESS')
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Resource'),
                  onChanged: (v) => _resource = v,
                  validator: (v) =>
                      _type == 'ACCESS' && (v == null || v.isEmpty)
                          ? 'Resource required'
                          : null,
                ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason'),
                onChanged: (v) => _reason = v,
                validator: (v) =>
                    v != null && v.length >= 5 ? null : 'Min 5 chars',
              ),
              const SizedBox(height: 24),
              BlocBuilder<RequestCubit, RequestState>(
                builder: (context, state) {
                  if (state is RequestLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is RequestError) {
                    return Text(state.message,
                        style: const TextStyle(color: Colors.red));
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final data = {
                            'type': _type,
                            'reason': _reason,
                            if (_type == 'WITHDRAW' || _type == 'DEPOSIT')
                              'amount': _amount,
                            if (_type == 'ACCESS') 'resource': _resource,
                          };
                          context.read<RequestCubit>().createRequest(data);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
