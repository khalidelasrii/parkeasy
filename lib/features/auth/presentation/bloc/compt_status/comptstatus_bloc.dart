import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:parkeasy/features/auth/domain/usecases/get_account_status_use_case.dart';
import 'dart:async';

import '../../../../../core/constant/enum.dart';

part 'comptstatus_event.dart';
part 'comptstatus_state.dart';

class ComptstatusBloc extends Bloc<ComptstatusEvent, ComptstatusState> {
  final GetAccountStatusUseCase getAccountStatusUseCase;
  StreamSubscription<AccountStatus?>? _accountStatusSubscription;
  ComptstatusBloc({required this.getAccountStatusUseCase})
      : super(ComptstatusInitial()) {
    on<CheckComptStatusEvent>(_onCheckComptStatus);
    add(CheckComptStatusEvent());
  }
  void _onCheckComptStatus(
    CheckComptStatusEvent event,
    Emitter<ComptstatusState> emit,
  ) async {
    emit(ComptstatusLoading());

    await _accountStatusSubscription?.cancel();

    try {
      await for (final status in getAccountStatusUseCase()) {
        if (!emit.isDone) {
          if (status != null) {
            emit(ComptstatusLoaded(status: status));
          } else {
            emit(const ComptstatusError(error: "Account status is null"));
          }
        } else {
          break;
        }
      }
    } catch (e) {
      if (!emit.isDone) {
        emit(ComptstatusError(error: e.toString()));
      }
    }
  }

  @override
  Future<void> close() async {
    await _accountStatusSubscription?.cancel();
    return super.close();
  }
}
