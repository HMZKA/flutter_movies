part of 'app_cubit.dart';

@immutable
abstract class AppState {}

class AppInitial extends AppState {}

class AnimateToPageState extends AppState {}

class ChangeViewState extends AppState {}

class LoadingMoviesState extends AppState {}

class GetMoviesSuccessState extends AppState {}

class GetMoviesErrorState extends AppState {}
