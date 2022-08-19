import 'package:flutter/material.dart';
import '../models/models.dart';

class MovieSliderScreen extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  MovieSliderScreen({
    Key? key,
    required this.movies,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<MovieSliderScreen> createState() => _MovieSliderScreenState();
}

class _MovieSliderScreenState extends State<MovieSliderScreen> {
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    //permite cargar contenido la primera vez que cargue
    super.initState();
    scrollController.addListener(() {
      //obtiene la posición del scroll horizontal cada vez que se mueve
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        //print(scrollController.position.pixels); //posición actual
        //print(scrollController.position.maxScrollExtent); //posición máxima
        widget.onNextPage();
        //print('Obtener siguiente página');
      }
    });
  }

  @override
  void dispose() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 260,
      //color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(widget.title!,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.movies.length,
                itemBuilder: (BuildContext context, int index) => _MoviePoster(
                    widget.movies[index],
                    '${widget.title}-$index-${widget.movies[index].id}')),
          )
        ],
      ),
    );
  }
}

//_ indica que es privado. solo vive en este archivo
class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;

  const _MoviePoster(this.movie, this.heroId);

  @override
  Widget build(BuildContext context) {
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context,
              'details', //permite navegar por las pantallas al hacer push sobre el elemento
              arguments: movie),
          child: Hero(
            tag: heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                width: 130,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
