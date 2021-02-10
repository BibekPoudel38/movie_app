import 'package:http/http.dart' as http;
import 'package:movie_app/model/movielistmodel.dart';
import 'package:movie_app/model/singleMovieModel.dart';

class Resources {
  static var client = http.Client();

  static Future<MovieListModel> fetchTrendingMovies() async {
    var url =
        "https://yts.mx/api/v2/list_movies.json?limit=20&sort_by=download_count";
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return movieListModelFromJson(jsonString);
    } else {
      return null;
    }
  }

  static Future<MovieListModel> fetchMovies(int page,
      [String query, String genre]) async {
    print("pg : " + page.toString());
    var url;
    if (query == null) {
      print("query is null $genre");
      if (genre != null) {
        print("loading from genre");
        url =
            "https://yts.mx/api/v2/list_movies.json?genre=$genre&page=${page.toString()}";
      } else {
        url = "https://yts.mx/api/v2/list_movies.json?page=${page.toString()}";
      }
    } else if (genre == null) {
      if (query != null) {
        url =
            "https://yts.mx/api/v2/list_movies.json?query_term=$query&page=${page.toString()}";
      } else {
        url = "https://yts.mx/api/v2/list_movies.json?page=${page.toString()}";
      }
    } else {
      url = "https://yts.mx/api/v2/list_movies.json?page=${page.toString()}";
    }
    print(url);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var jsonString = response.body;
      return movieListModelFromJson(jsonString);
    } else {
      return null;
    }
  }

  static Future<SingleMovieModel> fetchSingleMovie(String id) async {
    var url =
        "https://yts.mx/api/v2/movie_details.json?movie_id=$id&with_images=true&with_cast=true";
    var response = await client.get(url);
    if (response.statusCode == 200) {
      print(url);
      var jsonString = response.body;
      return singleMovieModelFromJson(jsonString);
    } else {
      return null;
    }
  }
}
