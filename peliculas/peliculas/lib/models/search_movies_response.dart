// To parse this JSON data, do
//
//     final searchmovieResponse = searchmovieResponseFromMap(jsonString);

import 'dart:convert';
import 'package:peliculas/models/models.dart';

class SearchmovieResponse {
  SearchmovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  int page;
  List<Movie> results;
  int totalPages;
  int totalResults;

  factory SearchmovieResponse.fromJson(String str) =>
      SearchmovieResponse.fromMap(json.decode(str));

  factory SearchmovieResponse.fromMap(Map<String, dynamic> json) =>
      SearchmovieResponse(
        page: json["page"],
        results: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
