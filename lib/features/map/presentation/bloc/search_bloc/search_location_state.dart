part of 'search_location_bloc.dart';

sealed class SearchLocationState extends Equatable {
  const SearchLocationState();

  @override
  List<Object> get props => [];
}

final class SearchLocationInitial extends SearchLocationState {}

class SearchParking extends SearchLocationState {}
