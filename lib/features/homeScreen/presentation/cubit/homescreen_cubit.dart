import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'homescreen_state.dart';

class HomescreenCubit extends Cubit<HomescreenState> {
  HomescreenCubit() : super(HomescreenInitial());
}
