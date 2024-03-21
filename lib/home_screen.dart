import 'dart:ui';
import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movies/cubit/app_cubit.dart';
import 'package:flutter_movies/main.dart';
import 'package:flutter_movies/movie_detail_screen.dart';
import 'package:flutter_movies/movie_model.dart';
import 'package:flutter_movies/test_screen.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController listController = ScrollController();
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var movies = AppCubit().get(context).movieModel;
        var cubit = AppCubit().get(context);

        return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            floatingActionButton: FloatingActionButton(onPressed: () {
              MyApp.isGrid = !MyApp.isGrid;
              MyApp.isGrid
                  ? MyApp.gridController = ScrollController(
                      initialScrollOffset: listController.offset / 3)
                  : null;
              Navigator.of(context)
                  .pushReplacement(_createRoute(const HomeScreen()));
            }),
            body: BuildCondition(
              condition: movies != null,
              builder: (context) {
                return BuildCondition(
                  condition: MyApp.isGrid,
                  builder: (context) => gridView(movies!),
                  fallback: (context) => listView(cubit, movies, context),
                );
              },
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ));
      },
    );
  }

  Stack listView(AppCubit cubit, MovieModel? movies, BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        LiquidSwipe(
            enableSideReveal: true,
            disableUserGesture: true,
            waveType: WaveType.circularReveal,
            liquidController: cubit.liquidController,
            initialPage: 0,
            pages: List.generate(
              movies!.results.length,
              (index) => Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500${movies.results[index].backdropPath}"))),
              ),
            )),
        BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: ScrollSnapList(
                listController: listController,
                itemBuilder: (context, index) {
                  return buildMovieList(context, movies, index);
                },
                dynamicItemSize: true,
                initialIndex: 0,
                itemCount: movies.results.length,
                scrollDirection: Axis.horizontal,
                itemSize: MediaQuery.of(context).size.width / 1.7,
                focusOnItemTap: true,
                onItemFocus: (index) {
                  print(currentIndex);
                  print(index);
                  currentIndex - index == 1 || currentIndex - index == -1
                      ? cubit.animatetoPage(index)
                      : cubit.jumptoPage(index);
                  currentIndex = index;
                },
                scrollPhysics: const BouncingScrollPhysics(),
                curve: Curves.easeOut,
              ),
            )),
      ],
    );
  }

  Route _createRoute(Widget destination) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          destination,
      transitionDuration: const Duration(milliseconds: 1200),
      reverseTransitionDuration: const Duration(milliseconds: 1200),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeOutCirc.flipped),
          child: child,
        );
      },
    );
  }

  GridView gridView(MovieModel movies) {
    return GridView.builder(
      controller: MyApp.gridController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 5.0),
      itemCount: movies.results.length,
      itemBuilder: (context, index) => buildMovieList(context, movies, index),
    );
  }

  Widget buildMovieList(context, MovieModel movies, index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MovieDetailScreen(
            movieModel: movies.results[index],
          ),
        ));
      },
      child: Hero(
        tag: movies.results[index].id!,
        createRectTween: (begin, end) {
          return CustomRectTween(a: begin!, b: end!);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width / 1.7,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500${movies.results[index].posterPath}")),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(5, 5),
                    blurRadius: 3,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.normal),
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(-3, -3),
                    blurRadius: 3,
                    spreadRadius: 0,
                    blurStyle: BlurStyle.normal),
              ]),
        ),
      ),
    );
  }
}
