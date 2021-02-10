import 'package:get/get.dart';
import 'package:movie_app/Resources/resource.dart';
import 'package:movie_app/model/movielistmodel.dart';

class TrendingController extends GetxController {
  var isLoading = true;
  var trendingMoviesList = <MovieListModel>[];
  int pageNumber = 1;
  @override
  void onInit() {
    fetchTrendingMovies();
    super.onInit();
  }

  void nextButton() {
    print("pressed");
    pageNumber++;
    fetchTrendingMovies();
    update();
  }

  void previousButton() {
    print("pressed");
    pageNumber--;
    fetchTrendingMovies();
    update();
  }

  Future<void> fetchTrendingMovies() async {
    isLoading = true;
    update();
    var movies = await Resources.fetchTrendingMovies();
    if (movies != null) {
      print(trendingMoviesList.length);
      trendingMoviesList.clear();
      trendingMoviesList.add(movies);
      update();
    }
    isLoading = false;
  }
}
