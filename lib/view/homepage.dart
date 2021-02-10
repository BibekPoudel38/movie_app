import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/moviesController.dart';
import 'package:movie_app/model/movielistmodel.dart';
import 'package:movie_app/view/detailedPage.dart';
import 'package:movie_app/view/movieTile.dart';

class HomePage extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            child: customAppBar(),
            preferredSize: Size.fromHeight(170),
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: mainViewPort(context),
          ),
        ),
        GetBuilder<MoviesController>(
          init: MoviesController(),
          initState: (_) {},
          builder: (controller) {
            print(controller.searchString);
            return controller.searchString.isEmpty
                ? SizedBox()
                : Positioned(
                    top: 150,
                    left: Get.width * 0.1,
                    right: Get.width * 0.1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Material(
                        child: Container(
                          width: Get.width * 0.8,
                          height: Get.height * 0.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                for (var item
                                    in controller.searchList[0].data.movies)
                                  searchSuggestionTile(context, item)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget searchSuggestionTile(BuildContext context, Movie model) {
    return model == null
        ? Text("data")
        : GetBuilder<MoviesController>(
            init: MoviesController(),
            initState: (_) {},
            builder: (controller) {
              return GestureDetector(
                onTap: () {
                  controller.searchString = "";
                  FocusScope.of(context).unfocus();
                  searchController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        id: model.id.toString(),
                      ),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(model.title),
                  subtitle: Text("Language : ${model.language}"),
                  trailing: Icon(Icons.open_in_new),
                ),
              );
            },
          );
  }

  Drawer sideDrawer(BuildContext context) => Drawer(
        child: Column(
          children: [
            Container(
              height: Get.height * 0.3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff0575E6),
                    Color(0xff021B79),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  "Movie App",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ListTile(
                  title: Text(
                    "Upcoming Movies",
                  ),
                  trailing: Icon(Icons.update),
                  onTap: () {},
                ),
                SizedBox(),
                Text(
                  "Please note that this app doesnot promote piracy. We encourage you to use legit site to watch the movie if possible.",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ],
        ),
      );

  TextEditingController searchController = TextEditingController();

  List<String> genre = [
    "comedy",
    "sci-fi",
    "horror",
    "romance",
    "action",
    "thriller",
    "drama",
    "mystry",
    "crime",
    "animation",
    "adventure",
    "fantasy",
    "superhero"
  ];

  AppBar customAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.movie_sharp),
        onPressed: () {
          scaffoldKey.currentState.openDrawer();
        },
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      title: Text(
        "Movies",
        style: TextStyle(
          color: Colors.black,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: Column(
          children: [
            SizedBox(
              width: Get.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: GetBuilder<MoviesController>(
                  init: MoviesController(),
                  initState: (_) {},
                  builder: (cntrl) {
                    return TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        fillColor: Colors.white54,
                        filled: true,
                        hintText: "Search for Movies...",
                        border: InputBorder.none,
                      ),
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (value) async {
                        cntrl.searchString = "";
                        await cntrl.fetchMovies(1, value.toString());
                      },
                      onChanged: (value) async {
                        await cntrl.onSearchChanged(value);
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              // color: Colors.orange,
              height: 50,
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: genre.length,
                  itemBuilder: (context, index) {
                    return GetBuilder<MoviesController>(
                      init: MoviesController(),
                      initState: (_) {},
                      builder: (cntrl) {
                        return genreChip(index, cntrl);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        GetBuilder<MoviesController>(
          init: MoviesController(),
          initState: (_) {},
          builder: (controller) {
            return IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () async {
                controller.pageNumber = 1;
                await controller
                    .fetchMovies(1)
                    .then((value) => searchController.clear());
              },
            );
          },
        ),
      ],
    );
  }

  Widget genreChip(int index, MoviesController cntrl) {
    return GestureDetector(
      child: Chip(
        backgroundColor:
            cntrl.selectedChipIndex == index ? Colors.black : Colors.white,
        label: Text(
          genre[index],
          style: TextStyle(
            color:
                cntrl.selectedChipIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
      onTap: () async {
        print("pressed");
        cntrl.changeChipColor(index);
        await cntrl.fetchMovies(1, null, genre[index], index);
      },
    );
  }

  // Widget genreChip(int index) {
  //   return GetBuilder<ChipController>(
  //     init: ChipController(),
  //     initState: (_) {},
  //     builder: (controller) {
  //       return Chip(
  //         backgroundColor:
  //             controller.selectedChip == index ? Colors.black : Colors.grey,
  //         label: Text(
  //           genre[index],
  //         ),
  //       );
  //     },
  //   );
  // }

  GetBuilder<MoviesController> mainViewPort(BuildContext context) {
    return GetBuilder<MoviesController>(
      init: MoviesController(),
      initState: (_) {},
      builder: (controller) {
        return controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : movieTile(controller);
      },
    );
  }

  ScrollController scrollController = ScrollController();
  Container movieTile(MoviesController controller) {
    return Container(
      color: Colors.transparent,
      child: ListView.builder(
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: controller.moviesList[0].data.movies.length + 1,
        itemBuilder: (context, index) {
          print(controller.isLoading);
          if (controller.isLoading) {
            return CircularProgressIndicator();
          } else if (index == controller.moviesList[0].data.movies.length) {
            return Container(
              height: 100,
              width: Get.width,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.pageNumber > 3
                        ? FlatButton(
                            color: Colors.yellow,
                            onPressed: () {
                              controller.fetchMovies(1).then((value) {
                                controller.pageNumber = 1;
                                return scrollController.animateTo(
                                  0.0,
                                  curve: Curves.easeOut,
                                  duration: const Duration(milliseconds: 300),
                                );
                              });
                            },
                            child: Text('Page 1'),
                          )
                        : Container(),
                    controller.pageNumber > 3
                        ? SizedBox(
                            width: 50,
                          )
                        : SizedBox(),
                    controller.pageNumber > 1
                        ? FlatButton(
                            color: Colors.yellow,
                            onPressed: () {
                              controller.previousButton(searchController.text);
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
                        controller.nextButton(searchController.text);
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              ),
            );
          }
          var item = controller.moviesList[0].data.movies[index];
          return MovieDisplayTile(item: item);
        },
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} Hours  ${parts[1].padLeft(2, '0')} Minutes';
  }
}
