import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/Resources/resource.dart';
import 'package:movie_app/model/singleMovieModel.dart';
import 'package:url_launcher/url_launcher.dart';

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

  openTorrentLink(String url, String name) async {
    if (await canLaunch(url)) {
      launch(url);
    } else {
      
    }
  }
}
