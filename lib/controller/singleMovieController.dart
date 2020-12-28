import 'package:get/get.dart';
import 'package:movie_app/Resources/resource.dart';
import 'package:movie_app/model/singleMovieModel.dart';

class SingleMovieController extends GetxController {
  final String id;
  var isLoading = true;
  var singlemovie = SingleMovieModel();

  SingleMovieController({this.id});

  @override
  void onInit() {
    fetchMovie();
    super.onInit();
  }

  Future<void> fetchMovie() async {
    isLoading = true;
    var mov = await Resources.fetchSingleMovie(id);

    if (mov != null) {
      singlemovie = mov;
      print("added : " + singlemovie.data.movie.title);
      isLoading = false;
      update();
    } else {
      print("object");
    }
    isLoading = false;
  }
}
