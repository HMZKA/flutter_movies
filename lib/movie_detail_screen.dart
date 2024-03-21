import 'package:flutter/material.dart';
import 'package:flutter_movies/constants.dart';
import 'package:flutter_movies/movie_model.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieModel});
  final Results movieModel;
  @override
  Widget build(BuildContext context) {
    String geners = "";
    movieModel.geners.forEach((element) {
      geners += "${genresMap[element]!},";
    });

    return Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Hero(
                tag: movieModel.id!,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500${movieModel.posterPath}",
                        )),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.85, 1],
                    colors: [Colors.black.withAlpha(200), Colors.transparent]),
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        movieModel.title!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${movieModel.releaseDate!.split('-').first} ",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          geners.substring(0, geners.length - 1),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${movieModel.voteAverage}",
                          style: const TextStyle(
                              color: Colors.amber, fontSize: 18),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        RatingStars(
                          starColor: Colors.amber,
                          starSize: 16,
                          valueLabelVisibility: false,
                          maxValue: 10.0,
                          value: movieModel.voteAverage!,
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        movieModel.overview!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
