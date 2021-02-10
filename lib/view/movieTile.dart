import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movie_app/model/movielistmodel.dart';
import 'package:movie_app/view/detailedPage.dart';

class MovieDisplayTile extends StatelessWidget {
  const MovieDisplayTile({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Movie item;

  @override
  Widget build(BuildContext context) {
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
        margin: EdgeInsets.fromLTRB(20, 5, 20, 5),
        height: 200,
        width: Get.width,
        // color: Colors.orange,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: Get.width,
                height: 130,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: Get.width * 0.54,
                    // height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          item.dateUploaded.toString().substring(0, 10),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          durationToString(item.runtime),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Color(0xffFD6F62),
                            ),
                            SizedBox(width: 10),
                            Text(
                              item.rating.toString() ?? "NA",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Container(
                  height: 180,
                  width: 120,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff9FD2E2),
                        offset: Offset(-4, 4),
                        blurRadius: 5,
                      ),
                    ],
                    image: DecorationImage(
                      image: NetworkImage(item.mediumCoverImage),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')} Hours  ${parts[1].padLeft(2, '0')} Minutes';
  }
}
