import 'package:get/get.dart';
import 'package:movie_app/Resources/resource.dart';
import 'package:movie_app/model/movielistmodel.dart';

class MoviesController extends GetxController {
  var isLoading = true;
  var moviesList = <MovieListModel>[];
  int pageNumber = 1;
  @override
  void onInit() {
    fetchMovies(pageNumber);
    super.onInit();
  }

  void nextButton() {
    print("pressed");
    pageNumber++;
    print(pageNumber);
    fetchMovies(pageNumber);
    update();
  }

  void previousButton() {
    print("pressed");
    pageNumber--;
    print(pageNumber);
    fetchMovies(pageNumber);
    update();
  }

  Future<void> fetchMovies(int page) async {
    isLoading = true;
    var movies = await Resources.fetchMovies(page);
    if (movies != null) {
      moviesList.clear();
      moviesList.add(movies);
      update();
    }
    isLoading = false;
  }
}
