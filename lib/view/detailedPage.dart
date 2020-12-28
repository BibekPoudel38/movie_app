import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/controller/singleMovieController.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsPage extends StatelessWidget {
  final String id;

  const DetailsPage({Key key, this.id}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleMovieController>(
      init: SingleMovieController(id: id),
      builder: (controller) {
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
                title: controller.isLoading
                    ? Text("Loading...")
                    : Text(
                        controller.singlemovie.data.movie.title.toString(),
                      ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: controller.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          topBanner(controller),
                          SizedBox(height: 10),
                          SingleChildScrollView(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                valueTile(
                                  color: Colors.pink,
                                  iconData: Icons.favorite,
                                  text: controller
                                      .singlemovie.data.movie.likeCount
                                      .toString(),
                                  title: "Likes",
                                ),
                                valueTile(
                                  color: Colors.white,
                                  iconData: Icons.download_done_rounded,
                                  text: controller
                                      .singlemovie.data.movie.downloadCount
                                      .toString(),
                                  title: "Downloads",
                                ),
                                valueTile(
                                  color: Colors.white,
                                  iconData: Icons.language_rounded,
                                  text: controller
                                      .singlemovie.data.movie.language,
                                  title: "Language",
                                ),
                                valueTile(
                                  color: Colors.white,
                                  iconData: Icons.star_rate_rounded,
                                  text: controller.singlemovie.data.movie.rating
                                      .toString(),
                                  title: "Ratings",
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FlatButton(
                              minWidth: Get.width,
                              height: 60,
                              color: Colors.green.shade700,
                              textColor: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Torrent Links"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List<Widget>.generate(
                                          controller.singlemovie.data.movie
                                              .torrents.length,
                                          (index) {
                                            var torrent = controller.singlemovie
                                                .data.movie.torrents[index];
                                            return ListTile(
                                              title: Text(torrent.type),
                                              subtitle: Text(torrent.quality),
                                              trailing: Text(torrent.size),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text("Alert"),
                                                      content: Text(
                                                        'You are about to move to a torrent site. Make sure you have turned on your VPN before proceeding.',
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          child:
                                                              Text("Proceed"),
                                                          onPressed: () async {
                                                            await launchTorrent(
                                                                torrent.url);
                                                            print("Visiting");
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text("Torrent"),
                            ),
                          ),
                          controller.singlemovie.data.movie.ytTrailerCode ==
                                      null ||
                                  controller.singlemovie.data.movie
                                      .ytTrailerCode.isEmpty
                              ? Container()
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                  child: FlatButton(
                                    minWidth: Get.width,
                                    height: 60,
                                    color: Color(0xffFF0000),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      launchTorrent(
                                        'https://www.youtube.com/watch?v=${controller.singlemovie.data.movie.ytTrailerCode.toString()}',
                                      );
                                    },
                                    child: Text("Watch Trailer in Youtube"),
                                  ),
                                ),
                          SizedBox(height: 10),
                          controller.singlemovie.data.movie.cast != null
                              ? castsPanel(controller)
                              : ExpansionTile(
                                  title: Text("Casts"),
                                  children: [
                                    Container(
                                      height: 120,
                                      child: Image.asset(
                                        'assets/images/null.png',
                                        colorBlendMode: BlendMode.lighten,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Casts Not found"),
                                    ),
                                  ],
                                ),
                          SizedBox(height: 10),
                          descAndSummary(controller),
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  launchTorrent(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Container valueTile(
      {String text, IconData iconData, Color color, String title}) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            iconData,
            size: 35,
            color: color,
          ),
          Text(
            title,
            maxLines: 2,
          ),
          Text(text),
        ],
      ),
    );
  }

  ExpansionTile castsPanel(SingleMovieController controller) {
    return ExpansionTile(
      title: Text(
        "Casts",
        style: TextStyle(
          fontSize: 22,
        ),
      ),
      children: List<Widget>.generate(
        controller.singlemovie.data.movie.cast.length,
        (index) {
          return ListTile(
            title: Text(controller.singlemovie.data.movie.cast[index].name),
            subtitle: Text("As  " +
                controller.singlemovie.data.movie.cast[index].characterName),
            trailing:
                Text(controller.singlemovie.data.movie.cast[index].imdbCode),
          );
        },
      ),
    );
  }

  Container descAndSummary(SingleMovieController controller) {
    return Container(
      // height: 200,
      width: Get.width,
      // color: Colors.orange,
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Description",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Text(
              controller.singlemovie.data.movie.descriptionFull,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  Container topBanner(SingleMovieController controller) {
    return Container(
      height: Get.height * 0.2,
      width: Get.width,
      // color: Colors.orange,
      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 0.665,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                controller.singlemovie.data.movie.mediumCoverImage,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            width: Get.width * .55,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.singlemovie.data.movie.titleLong,
                  maxLines: 4,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      controller.singlemovie.data.movie.rating.toString(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.star_border,
                      color: Colors.yellowAccent,
                    ),
                  ],
                ),
                Spacer(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Row(
                    children: List<Widget>.generate(
                      controller.singlemovie.data.movie.genres.length,
                      (index) => Padding(
                        padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                        child: Chip(
                          label: Text(
                            controller.singlemovie.data.movie.genres[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
