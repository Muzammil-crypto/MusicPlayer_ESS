// ignore_for_file: sort_child_properties_last

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itunes_musicplayer/controllers/home_page_controller.dart';
import 'package:itunes_musicplayer/theme/theme_helper.dart';

class HomePage extends StatelessWidget {
  final HomePageController homePagecontroller = Get.put(HomePageController());
  // final songDetailsController = Get.put(SongDetailsController());
  // final musicPlayerController = MusicPlayerController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Obx(
      () => Scaffold(
        backgroundColor: ThemeHelper.accentColor,
        appBar: AppBar(
          backgroundColor: ThemeHelper.accentColor,
          title: Center(
            child: homePagecontroller.search.value
                ? Container(
                    decoration: BoxDecoration(
                        color: ThemeHelper.primaryColor,
                        borderRadius: BorderRadius.circular(18)),
                    width: width / 1.8,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18)),
                          width: width / 2,
                          child: TextField(
                              focusNode: focusNode,
                              controller:
                                  homePagecontroller.textEditingController,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: ThemeHelper.primaryColor,
                                  ),
                                  hintText: "Search the Artist",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 25.0),
                                      borderRadius:
                                          BorderRadius.circular(18.0)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 25.0),
                                      borderRadius:
                                          BorderRadius.circular(18.0)))),
                        ),
                        Container(
                          child: TextButton(
                            child: Text(
                              "Search",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () => {
                              homePagecontroller.getSearchedSongs(
                                  homePagecontroller.textEditingController.text)
                            },
                          ),
                        )
                      ],
                    ))
                : Text(
                    "My Playlist",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                homePagecontroller
                    .searchClicked(!homePagecontroller.search.value);
              },
              child: homePagecontroller.search.value
                  ? Icon(Icons.close)
                  : Icon(Icons.search),
            ),
          ],
        ),
        body: Center(
            child: Obx(
          () => homePagecontroller.isLoading.value
              ? const CircularProgressIndicator()
              : Container(
                  child: Row(children: [
                    Expanded(
                      child: Container(
                        child: ListView.builder(
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: ThemeHelper.primaryColor,
                                  ),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: ThemeHelper.primaryColor,
                                child: ListTile(
                                  title: Text(homePagecontroller
                                          .musicModel.songs
                                          ?.elementAt(index)
                                          .trackName ??
                                      "N/A"),
                                  subtitle: Text(homePagecontroller
                                          .musicModel.songs
                                          ?.elementAt(index)
                                          .artistName ??
                                      "N/A"),
                                  trailing: const Icon(
                                    Icons.play_arrow,
                                  ),
                                  leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          homePagecontroller.musicModel.songs
                                                  ?.elementAt(index)
                                                  .artworkUrl60 ??
                                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCT_yPqjGgX7UQpfBxW-luzlIwDaKpjJgTmaEJYH4Q0Q&s")),
                                  onTap: () {
                                    homePagecontroller.selectSong(index);
                                  },
                                ),
                                elevation: 5,
                              );
                            },
                            itemCount:
                                homePagecontroller.musicModel.songs?.length ??
                                    0),
                        color: Colors.black,
                      ),
                      flex: 4,
                    ),
                    homePagecontroller.songClicked.value
                        ? Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 30),
                              child: Column(
                                children: [
                                  // ignore: sized_box_for_whitespace
                                  Container(
                                    height: height / 7,
                                    width: width / 2,
                                    child: Image(
                                      image: NetworkImage(homePagecontroller
                                              .songSelected.artworkUrl60 ??
                                          "N/A"),
                                    ),
                                  ),
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromARGB(83, 0, 0, 0),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: IconButton(
                                        onPressed: () async => {
                                              if (homePagecontroller
                                                  .songPlaying.value)
                                                {
                                                  await homePagecontroller
                                                      .pauseMusic()
                                                }
                                              else
                                                {
                                                  await homePagecontroller
                                                      .playMusic(UrlSource(
                                                          homePagecontroller
                                                                  .songSelected
                                                                  .previewUrl ??
                                                              "N/A"))
                                                }
                                            },
                                        icon: Icon(
                                            homePagecontroller.songPlaying.value
                                                ? Icons.pause
                                                : Icons.play_arrow)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: Column(children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: ThemeHelper.primaryColor,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                        ),
                                        child: ListTile(
                                          title: Text(homePagecontroller
                                                  .songSelected.trackName ??
                                              "N/A"),
                                          subtitle: Text(homePagecontroller
                                                  .songSelected.artistName ??
                                              "N/A"),
                                        ),
                                      ),
                                    ]),
                                  ),
                                ],
                              ),
                              color: Colors.white,
                            ),
                            flex: 4,
                          )
                        : Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(top: 30),
                              child: const Center(
                                child: Text(
                                  "Select Song",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                  ]),
                ),
        )),
      ),
    );
  }
}
