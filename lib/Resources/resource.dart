import 'package:http/http.dart' as http;
import 'package:movie_app/model/movielistmodel.dart';
import 'package:movie_app/model/singleMovieModel.dart';

class Resources {
  static var client = http.Client();

  static Future<MovieListModel> fetchMovies(int page) async {
    print("pg : "+page.toString());
    var url = "https://yts.mx/api/v2/list_movies.json?page=${page.toString()}";

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
