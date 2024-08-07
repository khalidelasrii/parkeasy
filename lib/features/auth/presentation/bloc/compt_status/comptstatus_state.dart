part of 'comptstatus_bloc.dart';

abstract class ComptstatusState extends Equatable {
  const ComptstatusState();
  
  @override
  List<Object> get props => [];
}

class ComptstatusInitial extends ComptstatusState {}

class ComptstatusLoading extends ComptstatusState {}

class ComptstatusLoaded extends ComptstatusState {
  final AccountStatus status;

  const ComptstatusLoaded({required this.status});

  @override
  List<Object> get props => [status];
}

class ComptstatusError extends ComptstatusState {
  final String error;

  const ComptstatusError({required this.error});

  @override
  List<Object> get props => [error];
}