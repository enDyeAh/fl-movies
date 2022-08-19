import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context,
        listen:
            true); //si no encuentra instacia creada, crea una nueva. listen en true indica que redibuja cuando detecte cambio. Por defecto es true

    return Scaffold(
        appBar: AppBar(
          title: const Text('Peliculas de cines'),
          elevation: 0,
          actions: [
            IconButton(
                icon: const Icon(Icons.search_outlined),
                onPressed: () => showSearch(
                    context: context, delegate: MovieSearchDelegate())),
          ],
        ),
        body: SingleChildScrollView(
          //SingleChildScrollView permite agregar scroll si es que algún widget se pasará de los margenes de las columnas
          child: Column(children: [
            //Tarjetas principales
            CardSwiperScreen(movies: moviesProvider.onDisplayMovies),
            //Slider de películas
            MovieSliderScreen(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(), //opcional
            ),
          ]),
        ));
  }
}
