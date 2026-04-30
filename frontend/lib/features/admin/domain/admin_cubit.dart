import 'package:flutter_bloc/flutter_bloc.dart';
import 'admin_state.dart';
import '../data/admin_repository.dart';

class AdminCubit extends Cubit<AdminState> {
  final AdminRepository repository;
  AdminCubit(this.repository) : super(AdminInitial());

  Future<void> fetchAllRequests() async {
    emit(AdminLoading());
    try {
      final requests = await repository.getAllRequests();
      emit(AdminLoaded(requests));
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  Future<void> updateRequest(String id, Map<String, dynamic> data) async {
    emit(AdminLoading());
    try {
      await repository.updateRequest(id, data);
      await fetchAllRequests();
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }
}
