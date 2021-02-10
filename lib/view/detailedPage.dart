import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              body: controller.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Stack(
                      children: [
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              topBanner(controller),
                              SizedBox(height: 10),
                              SingleChildScrollView(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                      text: controller
                                          .singlemovie.data.movie.rating
                                          .toString(),
                                      title: "Ratings",
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
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
                                                controller.singlemovie.data
                                                    .movie.torrents.length,
                                                (index) {
                                                  var torrent = controller
                                                      .singlemovie
                                                      .data
                                                      .movie
                                                      .torrents[index];
                                                  return ListTile(
                                                    title: Text(torrent.type),
                                                    subtitle:
                                                        Text(torrent.quality),
                                                    trailing:
                                                        Text(torrent.size),
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title:
                                                                Text("Alert"),
                                                            content: Text(
                                                              'You are about to move to a torrent site. Make sure you have turned on your VPN before proceeding.',
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                child: Text(
                                                                    "Proceed"),
                                                                onPressed:
                                                                    () async {
                                                                  await controller
                                                                      .openTorrentLink(
                                                                    torrent.url,
                                                                    controller
                                                                        .singlemovie
                                                                        .data
                                                                        .movie
                                                                        .title,
                                                                  );
                                                                  print(
                                                                    "Visiting",
                                                                  );
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
                              ),
                              controller.singlemovie.data.movie.ytTrailerCode ==
                                          null ||
                                      controller.singlemovie.data.movie
                                          .ytTrailerCode.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: FlatButton(
                                          minWidth: Get.width,
                                          height: 60,
                                          color: Color(0xffFF0000),
                                          textColor: Colors.white,
                                          onPressed: () {
                                            launchYt(
                                              'https://www.youtube.com/watch?v=${controller.singlemovie.data.movie.ytTrailerCode.toString()}',
                                            );
                                          },
                                          child:
                                              Text("Watch Trailer in Youtube"),
                                        ),
                                      ),
                                    ),
                              SizedBox(height: 10),
                              controller.singlemovie.data.movie.cast != null
                                  ? castsPanel(controller)
                                  : ListTile(
                                      title: Text("No Casts found"),
                                      trailing: Icon(
                                        Icons.dangerous,
                                      ),
                                    ),
                              SizedBox(height: 10),
                              descAndSummary(controller, context),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          child: AppBar(
                            iconTheme: IconThemeData(
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  launchYt(String url) async {
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

  Widget castsPanel(SingleMovieController controller) {
    return Theme(
      data: ThemeData(
        accentColor: Colors.black,
      ),
      child: ExpansionTile(
        title: Text(
          "Casts",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        initiallyExpanded: false,
        children: List<Widget>.generate(
          controller.singlemovie.data.movie.cast.length,
          (index) {
            return ListTile(
              title: Text(controller.singlemovie.data.movie.cast[index].name),
              subtitle: Text("As  " +
                  controller.singlemovie.data.movie.cast[index].characterName),
              trailing:
                  Text(controller.singlemovie.data.movie.cast[index].imdbCode),
              leading: CircleAvatar(
                radius: 27,
                backgroundImage: NetworkImage(
                  controller.singlemovie.data.movie.cast[index].urlSmallImage ??
                      'https://hajiri.co/uploads/no_image.jpg',
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container descAndSummary(
      SingleMovieController controller, BuildContext context) {
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
            trailing: IconButton(
              icon: Icon(Icons.copy_rounded),
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text: controller.singlemovie.data.movie.descriptionFull,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Copied Link to Clipboard!',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    duration: Duration(
                      milliseconds: 500,
                    ),
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: "Copied",                      
                      onPressed: () {},
                    ),
                    backgroundColor: Colors.white,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Theme(
              data: ThemeData(
                textSelectionTheme: TextSelectionThemeData(
                  selectionColor: Colors.green,
                  cursorColor: Colors.orange,
                  selectionHandleColor: Colors.orange,
                ),
              ),
              child: SelectableText(
                controller.singlemovie.data.movie.descriptionFull.isEmpty
                    ? "No description Found"
                    : controller.singlemovie.data.movie.descriptionFull,
                textAlign: TextAlign.justify,
                cursorColor: Colors.black,
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} : ${parts[1].padLeft(2, '0')}';
  }

  Widget topBanner(SingleMovieController controller) {
    return Container(
      height: Get.height * 0.3 + Get.height * 0.18,
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            height: Get.height * 0.3,
            width: Get.width,
            decoration: BoxDecoration(
              // color: Colors.pink,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(
                  controller.singlemovie.data.movie.largeScreenshotImage1,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              margin: EdgeInsets.only(bottom: 15),
              height: Get.height * 0.2,
              width: Get.width,
              // color: Colors.orange,
              padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Row(
                children: [
                  AspectRatio(
                    aspectRatio: 0.69,
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.singlemovie.data.movie.titleLong,
                          maxLines: 4,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star_border,
                              color: Colors.yellowAccent,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              controller.singlemovie.data.movie.rating
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.timer,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              durationToString(
                                      controller.singlemovie.data.movie.runtime)
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        // Spacer(),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          child: Row(
                            children: List<Widget>.generate(
                              controller.singlemovie.data.movie.genres.length,
                              (index) => Padding(
                                padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: Chip(
                                  backgroundColor: Colors.white,
                                  label: Text(
                                    controller
                                        .singlemovie.data.movie.genres[index],
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
            ),
          ),
        ],
      ),
    );
  }
}
