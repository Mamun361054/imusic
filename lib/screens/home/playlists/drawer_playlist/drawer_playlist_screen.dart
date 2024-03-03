import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:dhak_dhol/provider/playlist_provider.dart';
import 'package:dhak_dhol/screens/home/playlists/playlist_mdia_screen.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerPlaylistScreen extends StatefulWidget {
  const DrawerPlaylistScreen({Key? key}) : super(key: key);

  @override
  State<DrawerPlaylistScreen> createState() => _DrawerPlaylistScreenState();
}

class _DrawerPlaylistScreenState extends State<DrawerPlaylistScreen> {
  late PlaylistsProvider playlistsModel;

  void clearPlaylistsMedia(BuildContext context, int id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Clear Playlist Media",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "Ok",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  playlistsModel.deletePlaylistsMediaList(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
            content:
                const Text("Go ahead and remove all media from this playlist?"),
          );
        });
  }

  void deletePlaylist(BuildContext context, int id) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Clear All Media',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  "Ok",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  playlistsModel.deletePlaylists(id);
                  Navigator.of(context).pop();
                },
              ),
            ],
            content:
                const Text('Go ahead and remove all media from this playlist?'),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    playlistsModel = Provider.of<PlaylistsProvider>(context);
    List<Playlists> items = playlistsModel.playlistsList;
    return Scaffold(
        backgroundColor: AppColor.deepBlue,
        appBar: AppBar(
          backgroundColor: AppColor.deepBlue,
          title: const Text(
            'Playlist',
          ),
        ),
        body: items.isEmpty
            ? Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text("No Item Display",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.white)),
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.all(0),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(height: 1, color: Colors.grey),
                  itemBuilder: (context, index) {
                    final playlists = items[index];
                    return SizedBox(
                      height: 70,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                            return PlaylistMediaScreen(
                              playlists: playlists,
                            );
                          }));
                        },
                        leading: SizedBox(
                          width: 40,
                          height: 40,
                          child: FutureBuilder<String?>(
                              initialData: "",
                              future:
                                  playlistsModel.getPlayListFirstMediaThumbnail(
                                      playlists.id!), //returns bool
                              builder: (BuildContext context,
                                  AsyncSnapshot<String?> value) {
                                if (value.data == null || value.data == "") {
                                  return Icon(
                                    Icons.music_note,
                                    size: 30,
                                    color: Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)],
                                  );
                                } else {
                                  return CachedNetworkImage(
                                    imageUrl: value.data!,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => const Center(
                                        child: CupertinoActivityIndicator()),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                            child: Icon(
                                      Icons.error,
                                      color: Colors.grey,
                                    )),
                                  );
                                }
                              }),
                        ),
                        title: Text(
                          playlists.title ?? '',
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        subtitle: FutureBuilder<int>(
                            initialData: 0,
                            future: playlistsModel.getPlaylistMediaCount(
                                playlists.id!), //returns bool
                            builder: (BuildContext context,
                                AsyncSnapshot<int> value) {
                              return Text(
                                value.data == null
                                    ? "0 item"
                                    : "${value.data} item(s)",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              );
                            }),
                        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                        //subtitle:  Text(categories.interest, ),
                        trailing: PopupMenuButton(
                          elevation: 3.2,
                          //initialValue: choices[1],
                          itemBuilder: (BuildContext context) {
                            List<String> choices = [
                              "Clear Playlist Media",
                              'Delete Playlist'
                            ];
                            return choices.map((itm) {
                              return PopupMenuItem(
                                value: itm,
                                child: Text(itm),
                              );
                            }).toList();
                          },
                          //initialValue: 2,
                          onCanceled: () {
                            debugPrint("You have canceled the menu.");
                          },
                          onSelected: (value) {
                            debugPrint(value.toString());
                            if (value == "Clear Playlist Media") {
                              clearPlaylistsMedia(context, playlists.id!);
                            }
                            if (value == 'Delete Playlist') {
                              deletePlaylist(context, playlists.id!);
                            }
                          },
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ));
  }
}
