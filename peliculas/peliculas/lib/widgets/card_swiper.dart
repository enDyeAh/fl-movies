import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class CardSwiperScreen extends StatelessWidget {
  final List<Movie> movies;

  const CardSwiperScreen({Key? key, required this.movies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context)
        .size; //obtiene el tamaño de la pantalla del dispositivo

    if (movies.length == 0) {
      return Container(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      height: size.height *
          0.5, //se multiplica por el porcentaje que quiera ocupar en pantalla, en este caso 50%
      //color: Colors.red,
      child: Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];
          print(movie.fullPosterImg);

          movie.heroId = 'swiper-${movie.id}';
          //siempre que existe un builder, quiere decir que es algo que se ejecutará en algún momento.
          return GestureDetector(
            //widget GestureDetector permite agregar evento ontap
            onTap: () => Navigator.pushNamed(context,
                'details', //permite navegar por las pantallas al hacer push sobre el elemento
                arguments: movie),
            child: Hero(
              tag: movie
                  .heroId!, //debe ser único, ya que puede haber solo uno por pantalla
              child: ClipRRect(
                //ClipRRect permite agregar borderradius
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
