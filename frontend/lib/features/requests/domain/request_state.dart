import 'package:equatable/equatable.dart';

abstract class RequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestLoaded extends RequestState {
  final List<dynamic> requests;
  RequestLoaded(this.requests);
  @override
  List<Object?> get props => [requests];
}

class RequestError extends RequestState {
  final String message;
  RequestError(this.message);
  @override
  List<Object?> get props => [message];
}
