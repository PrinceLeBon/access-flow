import 'package:flutter_bloc/flutter_bloc.dart';
import 'request_state.dart';
import '../data/request_repository.dart';

class RequestCubit extends Cubit<RequestState> {
  final RequestRepository repository;
  RequestCubit(this.repository) : super(RequestInitial());

  Future<void> fetchMyRequests() async {
    emit(RequestLoading());
    try {
      final requests = await repository.getMyRequests();
      emit(RequestLoaded(requests));
    } catch (e) {
      emit(RequestError(e.toString()));
    }
  }

  Future<void> createRequest(Map<String, dynamic> data) async {
    emit(RequestLoading());
    try {
      await repository.createRequest(data);
      await fetchMyRequests();
    } catch (e) {
      emit(RequestError(e.toString()));
    }
  }
}
