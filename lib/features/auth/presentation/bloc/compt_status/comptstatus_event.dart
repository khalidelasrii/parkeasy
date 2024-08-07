part of 'comptstatus_bloc.dart';

abstract class ComptstatusEvent extends Equatable {
  const ComptstatusEvent();

  @override
  List<Object> get props => [];
}

class CheckComptStatusEvent extends ComptstatusEvent {}
