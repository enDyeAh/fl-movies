//proveedor de información provider
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '065619821767ad0a97a99e9bef99ca4a';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );
  final StreamController<List<Movie>> _suggestionsStreamController =
      new StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream =>
      this._suggestionsStreamController.stream;

  MoviesProvider() {
    print('MoviesProvider inicilizado');
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    //[] indica opcional y si no viene le asigna 1
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    //print(nowPlayingResponse.results[1].title);
    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners(); //todos los widget que esten escuchando este cambio, los redibuja
  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    //print(nowPlayingResponse.results[1].title);
    popularMovies = [
      ...popularMovies,
      ...popularResponse.results
    ]; //[...] permite desestructurar

    notifyListeners(); //todos los widget que esten escuchando este cambio, los redibuja
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId))
      return moviesCast[
          movieId]!; //solo permite hacer petición si no existe en moviecast
    print('pidiendo info al server - Cast. id : $movieId');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchmovieResponse = SearchmovieResponse.fromJson(response.body);

    return searchmovieResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //print('tenemos valor a buscar: $value');
      final results = await searchMovies(value);
      _suggestionsStreamController.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
