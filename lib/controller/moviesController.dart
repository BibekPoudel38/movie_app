import 'package:get/get.dart';
import 'package:movie_app/Resources/resource.dart';
import 'package:movie_app/model/movielistmodel.dart';

class MoviesController extends GetxController {
  var isLoading = true;
  var moviesList = <MovieListModel>[];
  var searchList = <MovieListModel>[];
  int pageNumber = 1;
  @override
  void onInit() {
    fetchMovies(pageNumber);
    super.onInit();
  }

  void nextButton([String query, String genre]) {
    print("pressed");
    pageNumber++;
    print(pageNumber);
    fetchMovies(pageNumber, query);
    update();
  }

  void previousButton([String query, String genre]) {
    print("pressed");
    pageNumber--;
    print(pageNumber);
    fetchMovies(pageNumber, query);
    update();
  }

  Future<void> fetchMovies(int page,
      [String query, String genre, int genreIndex]) async {
    genre == null ? selectedChipIndex = null : selectedChipIndex = genreIndex;
    isLoading = true;
    update();
    var movies = await Resources.fetchMovies(page, query, genre);
    if (movies != null) {
      moviesList.clear();
      moviesList.add(movies);
      update();
    }
    isLoading = false;
  }

  int selectedChipIndex = 0;
  changeChipColor(int index) {
    selectedChipIndex = index;
  }

  String searchString = "";
  onSearchChanged(String value) async {
    searchString = value;
    var movies = await Resources.fetchMovies(1, value, null);
    if (movies != null) {
      searchList.clear();
      searchList.add(movies);
      print(movies.data.movies.length);
      update();
    }
    update();
  }
}
