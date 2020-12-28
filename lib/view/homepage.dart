import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/moviesController.dart';
import 'package:movie_app/view/detailedPage.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color(0xff2c3e50),
                Color(0xff2980b9),
              ],
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              "Movies",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              GetBuilder<MoviesController>(
                initState: (_) {},
                builder: (controller) {
                  return controller.pageNumber > 1
                      ? IconButton(
                          icon: Icon(Icons.home_outlined),
                          onPressed: () async {
                            await controller.fetchMovies(1);
                            print(controller.moviesList[0].data.movies.length);
                          },
                        )
                      : Container();
                },
              ),
            ],
          ),
          body: mainViewPort(context),
        ),
      ],
    );
  }

  GetBuilder<MoviesController> mainViewPort(BuildContext context) {
    return GetBuilder<MoviesController>(
      init: MoviesController(),
      initState: (_) {},
      builder: (controller) {
        return controller.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : movieTile(controller);
      },
    );
  }

  Container movieTile(MoviesController controller) {
    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        itemCount: controller.moviesList[0].data.movies.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.moviesList[0].data.movies.length) {
            return Container(
              height: 100,
              width: Get.width,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.pageNumber > 1
                        ? FlatButton(
                            color: Colors.yellow,
                            onPressed: () {
                              controller.previousButton();
                            },
                            child: Text('Previous'),
                          )
                        : Container(),
                    controller.pageNumber > 1
                        ? SizedBox(
                            width: 50,
                          )
                        : SizedBox(),
                    FlatButton(
                      color: Colors.yellow,
                      onPressed: () {
                        controller.nextButton();
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            );
          }
          var item = controller.moviesList[0].data.movies[index];
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
            child: Container(
              width: Get.width * 0.5,
              height: 200,
              margin: EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    colors: [
                      Colors.white12,
                      Colors.white38,
                    ]),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 0.665,
                    child: Image.network(
                      item.mediumCoverImage,
                    ),
                  ),
                  Container(
                    width: Get.width * 0.62,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          item.dateUploaded.year.toString() +
                              "/" +
                              item.dateUploaded.month.toString() +
                              "/" +
                              item.dateUploaded.day.toString(),
                          style: TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          item.descriptionFull,
                          maxLines: 4,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w300,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
