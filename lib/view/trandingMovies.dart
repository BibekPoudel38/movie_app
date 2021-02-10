import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/trendingController.dart';
import 'package:movie_app/model/movielistmodel.dart';
import 'package:movie_app/view/detailedPage.dart';
import 'package:movie_app/view/movieTile.dart';

class TrendingMovies extends StatelessWidget {
  Map<String, IconData> genre = {
    "comedy": Icons.theater_comedy,
    "sci-fi": Icons.science_outlined,
    "horror": Icons.date_range_outlined,
    "romance": Icons.favorite_outline_outlined,
    "action": Icons.call_to_action,
    "thriller": Icons.threed_rotation_outlined,
    "drama": Icons.filter_drama,
    "mystry": Icons.military_tech_sharp,
    "crime": Icons.confirmation_num,
    "animation": Icons.animation,
    "adventure": Icons.card_travel,
    "fantasy": Icons.face_retouching_natural,
    "superhero": Icons.superscript,
  };
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff43C6AC),
                Color(0xff0052D4),
              ],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text("Trending"),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Trend Setters",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
                trendingContainer(),
                SizedBox(height: 10),
                Container(
                  // height: 210,
                  width: Get.width,
                  // color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Trending Movies",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GetBuilder<TrendingController>(
                        init: TrendingController(),
                        initState: (_) {},
                        builder: (controller) {
                          return Container(
                            // height: Get.height,
                            child: controller.isLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                                : Column(
                                    children: [
                                      for (var item in controller
                                          .trendingMoviesList[0].data.movies)
                                        MovieDisplayTile(item: item)
                                    ],
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container categoryChip({String text, IconData icon}) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Comedy"),
          Icon(
            icon,
            size: 40,
          )
        ],
      ),
    );
  }

  Container trendingContainer() {
    return Container(
      height: 200,
      width: Get.width,
      // color: Colors.white,
      child: GetBuilder<TrendingController>(
        init: TrendingController(),
        builder: (controller) {
          return controller.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  itemCount: 6,
                  itemBuilder: (context, i) {
                    // int index = i - 1;
                    if (i == 0) {
                      return SizedBox(
                        width: 5,
                      );
                    }
                    int index = i - 1;
                    var item =
                        controller.trendingMoviesList[0].data.movies[index];
                    return trendingMovieTile(context, item);
                  },
                );
        },
      ),
    );
  }

  GestureDetector trendingMovieTile(BuildContext context, Movie item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(
              id: item.id.toString(),
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Container(
              height: 180,
              width: Get.width * 0.75,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(item.largeCoverImage.toString()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                width: Get.width * 0.75,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black,
                        Colors.black12,
                        Colors.transparent
                      ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 90,
                width: Get.width * 0.75,
                // color: Colors.grey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.75,
                      height: 25,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 4,
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: item.genres.length,
                          itemBuilder: (context, index) {
                            var genre = item.genres[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(360),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(genre),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
