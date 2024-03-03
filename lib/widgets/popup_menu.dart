import 'dart:io';

import 'package:dhak_dhol/provider/bookmarks_provider.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/model/Downloads.dart';
import '../data/model/media_model.dart';
import '../provider/DownloadsModel.dart';
import '../screens/downloader/downloader_page.dart';
import '../screens/home/playlists/add_playlist/add_playlist_screen.dart';

class MediaPopupMenu extends StatelessWidget {
  const MediaPopupMenu(this.media, {super.key, this.isDownloads});

  final Media? media;
  final bool? isDownloads;

  @override
  Widget build(BuildContext context) {
    BookmarksProvider bookmarksModel = Provider.of<BookmarksProvider>(context);
    DownloadsModel downloadsModel = Provider.of<DownloadsModel>(context);

    return PopupMenuButton(
      elevation: 3.2,
      color: AppColor.signInPageBackgroundColor,
      itemBuilder: (BuildContext context) {
        bool isBookmarked = bookmarksModel.isMediaBookmarked(media);
        List<String> choices = [];
        if (!Platform.isIOS) {
          choices.add('save offline');
        }
        // if (media?.canDownload == true && !Platform.isIOS) {
        //   choices.add('save offline');
        // }
        if (isDownloads != null &&
            downloadsModel.isMediaInDownloads(media?.id ?? 0)?.status ==
                DownloadTaskStatus.complete) {
          choices.add('delete media');
        }
        choices.add('add playlist');
        if (isBookmarked) {
          choices.add('UnBookmark');
        } else {
          choices.add('Bookmark');
        }
        choices.add('share');
        return choices.map((itm) {
          return PopupMenuItem(
            value: itm,
            child: Text(itm,style: TextStyle(color: AppColor.titleColor,fontWeight: FontWeight.bold),),
          );
        }).toList();
      },
      //initialValue: 2,
      onCanceled: () {
        debugPrint("You have canceled the menu.");
      },
      onSelected: (value) {
        debugPrint(value.toString());
        if (value == 'save offline') {
          if(media != null) {
            downloadFIle(context, media!);
          }
        }
        if (value == 'delete media') {
          downloadsModel.removeDownloadedMedia(context, media?.id ?? 0);
        }
        if (value == 'add playlist') {
          if(media != null) {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
                return AddPlaylistScreen(media: media!);
              }));
        }
        }
        if (value == 'Bookmark') {
          if(media != null) {
          bookmarksModel.bookmarkMedia(media!);
        }
        }
        if (value == 'UnBookmark') {
          if(media != null) {
          bookmarksModel.unBookmarkMedia(media!);
        }
        }
        if (value == 'share') {
          if(media != null) {
          ShareFile.share(media!);
        }
        }
      },
      icon: Icon(
        Icons.more_vert,
        color: Colors.grey[500],
      ),
    );
  }

  downloadFIle(BuildContext context, Media media) {
    Downloads downloads = Downloads.mapCurrentDownloadMedia(media);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
          return DownloaderPage(downloads: downloads, platform: Theme.of(context).platform);
        }));
  }
}

class ShareFile {
  static share(Media media) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    if (media.http ?? false) {
      await Share.share(
        'Listen to ${media.title} Via music App, Download now at  http://play.google.com/store/apps/details?id=$packageName',
        subject: 'Listen to ${media.title}',
      );
    } else {
    }
  }
}
