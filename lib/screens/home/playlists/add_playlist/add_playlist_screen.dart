import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dhak_dhol/data/model/media_model.dart';
import 'package:dhak_dhol/data/model/playlist_model.dart';
import 'package:dhak_dhol/provider/playlist_provider.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPlaylistScreen extends StatelessWidget {
  static const routeName = "/addplaylists";
  final Media media;

  const AddPlaylistScreen({Key? key, required this.media}) : super(key: key);

  void newPlaylistDialog(
      BuildContext context, PlaylistsProvider playlistsModel) {
    String name = "";
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: AppColor.deepBlue,
            title: const Text(
              'New Playlist', style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: AppColor.secondary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Ok',
                  style: TextStyle(fontSize: 16, color: AppColor.secondary),
                ),
                onPressed: () {
                  if (name != "") {
                    playlistsModel.createPlaylist(name, media.mediaType ?? '');
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
            content: TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: AppColor.secondary,
              autofocus: true,
              decoration: InputDecoration(
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColor.secondary)
                ),

              ),
              onChanged: (text) {
                name = text;
              },
              // cursorColor: Colors.black,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    PlaylistsProvider playlistsModel = Provider.of<PlaylistsProvider>(context);
    List<Playlists> items = playlistsModel.playlistsList;

    return Scaffold(
      backgroundColor: AppColor.deepBlue,
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        title: const Text("Add To Playlist"),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
            child: ListTile(
              // contentPadding: const EdgeInsets.fromLTRB(20, 20, 10, 5),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColor.secondary, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              leading: const SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Icon(
                    Icons.playlist_add,
                    color: Colors.white,
                  ),
                ),
              ),
              title: Text(
                "New Playlist",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
            onTap: () {
              newPlaylistDialog(context, playlistsModel);
            },
          ),
          const Divider(),
          Expanded(
              child: items.isEmpty
                  ? Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(text: 'Playlist Empty \n'),
                                  TextSpan(
                                    text: 'Create Playlist By Pressing',
                                  ),
                                  TextSpan(
                                      text: ' New Playlist',
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          color: AppColor.secondary),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          newPlaylistDialog(
                                              context, playlistsModel);
                                        }),
                                ],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white, height: 1.7),
                              ),
                              textAlign: TextAlign.center,
                            )
                            // Text("No Playlist Display \n Create playlist by pressing New Playlist",
                            //     textAlign: TextAlign.center,
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .bodyMedium!
                            //         .copyWith(color: Colors.white,
                            //     height: 1.7)),
                            ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(0),
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 1, color: AppColor.secondary),
                        itemBuilder: (context, index) {
                          return SizedBox(
                              height: 70,
                              child: Items(
                                  media: media,
                                  playlists: items[index],
                                  playlistsModel: playlistsModel));
                        },
                      ),
                    ))
        ],
      ),
    );
  }
}

class Items extends StatelessWidget {
  const Items({
    Key? key,
    required this.media,
    required this.playlists,
    required this.playlistsModel,
  }) : super(key: key);

  final Media media;
  final Playlists playlists;
  final PlaylistsProvider playlistsModel;

  addMediaToPlaylist(BuildContext context, bool isAdded) {
    if (!isAdded) {
      playlistsModel.addMediaToPlaylist(media, playlists.id!);
    } else {
      playlistsModel.deleteMediaFromPlaylist(media, playlists.id!);
    }
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
        initialData: false,
        future: playlistsModel.isMediaAddedToPlaylist(media, playlists.id!),
        //returns bool
        builder:
            (BuildContext context, AsyncSnapshot<bool?> isAddedToPlaylists) {
          bool? isAdded = false;
          if (isAddedToPlaylists.data != null) {
            isAdded = isAddedToPlaylists.data;
          }
          return InkWell(
            child: ListTile(
              //contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: SizedBox(
                width: 40,
                height: 40,
                child: FutureBuilder<String?>(
                    initialData: "",
                    future: playlistsModel.getPlayListFirstMediaThumbnail(
                        playlists.id!), //returns bool
                    builder:
                        (BuildContext context, AsyncSnapshot<String?> value) {
                      if (value.data == null || value.data == "") {
                        return Icon(
                          Icons.music_note,
                          size: 30,
                          color: Colors.primaries[
                              Random().nextInt(Colors.primaries.length)],
                        );
                      } else {
                        return CachedNetworkImage(
                          imageUrl: value.data ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => const Center(
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
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
              subtitle: FutureBuilder<int>(
                  initialData: 0,
                  future: playlistsModel
                      .getPlaylistMediaCount(playlists.id!), //returns bool
                  builder: (BuildContext context, AsyncSnapshot<int> value) {
                    return Text(
                      value.data == null ? "0 item" : "${value.data} item(s)",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    );
                  }),
              trailing: Checkbox(
                  side: const BorderSide(color: Colors.white),
                  value: isAddedToPlaylists.data,
                  onChanged: ((isChecked) {
                    addMediaToPlaylist(context, isAdded!);
                  })),
            ),
            onTap: () {
              addMediaToPlaylist(context, isAdded!);
            },
          );
        });
  }
}
