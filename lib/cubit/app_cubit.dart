import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movies/dio_helper.dart';
import 'package:flutter_movies/movie_model.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  AppCubit get(context) => BlocProvider.of(context);
  LiquidController liquidController = LiquidController();
  animatetoPage(index) {
    liquidController.animateToPage(page: index);
    emit(AnimateToPageState());
  }

  jumptoPage(index) {
    liquidController.jumpToPage(page: index);
    emit(AnimateToPageState());
  }

  bool isGrid = true;
  switchView() {
    isGrid = !isGrid;
    emit(ChangeViewState());
  }

  MovieModel? movieModel;
  getMovies() {
    emit(LoadingMoviesState());
    DioHelper.get(
            path: "discover/movie",
            queryParameters: {"api_key": "291cd483af6adc79c896abacafb5045c"})
        .then((value) {
      movieModel = MovieModel.fromJson(value?.data);
      emit(GetMoviesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMoviesErrorState());
    });
  }
}
