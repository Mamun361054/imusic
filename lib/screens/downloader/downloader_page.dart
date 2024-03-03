import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/model/Downloads.dart';
import '../../provider/DownloadsModel.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../provider/music/audio_provider.dart';
import '../../utils/TextStyles.dart';
import '../../utils/TimUtil.dart';
import '../../utils/app_const.dart';
import '../../widgets/popup_menu.dart';
import '../home/music_player_page/audio_player_new_page.dart';

class DownloaderPage extends StatefulWidget with WidgetsBindingObserver {
  final TargetPlatform platform;
  static const routeName = "/downloader";
  final Downloads? downloads;

  DownloaderPage({Key? key, this.downloads, required this.platform}) : super(key: key);

  @override
  State<DownloaderPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DownloaderPage> {
  late DownloadsModel downloadsModel;
  final TextEditingController inputController = TextEditingController();
  bool showClear = false;
  String filter = '';

  @override
  void initState() {
    Provider.of<DownloadsModel>(context, listen: false).initDownloads(widget.platform, widget.downloads);
    inputController.addListener(() {
      setState(() {
        filter = inputController.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    //downloadsModel.unbindBackgroundIsolate();
    inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    downloadsModel = Provider.of<DownloadsModel>(context);

    return Scaffold(
      backgroundColor: AppColor.signInPageBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.signInPageBackgroundColor,
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: const TextStyle(fontSize: 18, color: Colors.white),
          keyboardType: TextInputType.text,
          onSubmitted: (query) {
            //downloadsModel.searchDownloads(query);
          },
          /* onChanged: (term) {
            setState(() {
              showClear = (term.length > 2);
            });
            if (term.length == 0) {
              //downloadsModel.cancelSearch();
            }
          },*/
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Downloads',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.white70),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          showClear
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                  ),
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    downloadsModel.cancelSearch();
                  },
                )
              : Container(),
        ],
      ),
      body: BuildBodyPage(downloadsModel: downloadsModel, filter: filter),
    );
  }
}

class BuildBodyPage extends StatelessWidget {
  const BuildBodyPage({
    Key? key,
    required this.downloadsModel,
    required this.filter,
  }) : super(key: key);

  final DownloadsModel downloadsModel;
  final String filter;

  @override
  Widget build(BuildContext context) {
    if (downloadsModel.isLoading) {
      return const Center(
        child:  CircularProgressIndicator(),
      );
    }
    if (!downloadsModel.permissionReady) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'Please grant accessing storage permission to continue',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey, fontSize: 18.0),
              ),
            ),
            const SizedBox(
              height: 32.0,
            ),
            TextButton(
                onPressed: () {
                  downloadsModel.requestPermission();
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ))
          ],
        ),
      );
    }
    if (downloadsModel.permissionReady && downloadsModel.downloadsList.isEmpty) {
      return Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('No Items To Display',
                textAlign: TextAlign.center, style: TextStyles.medium(context).copyWith(color: Colors.white)),
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: downloadsModel.downloadsList.length,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(3.0),
        itemBuilder: (BuildContext context, int index) {
          return filter == ""
              ? ItemTile(
                  index: index,
                  object: downloadsModel.downloadsList[index],
                  downloadsModel: downloadsModel)
              : downloadsModel.downloadsList[index].title
                      !.toLowerCase()
                      .contains(filter.toLowerCase())
                  ? ItemTile(
                      index: index,
                      object: downloadsModel.downloadsList[index],
                      downloadsModel: downloadsModel)
                  : Container();
        });
  }
}

class ItemTile extends StatefulWidget {
  final Downloads object;
  final int index;
  final DownloadsModel downloadsModel;

  const ItemTile({
    Key? key,
    required this.index,
    required this.object,
    required this.downloadsModel,
  })  : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioProvider>(context, listen: false).preparePlaylist(Downloads.mapMediaListFromDownloadList(widget.downloadsModel.downloadsList), Downloads.mapMediaFromDownload(widget.object),widget.index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: Container(
        height: 140.0,
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Card(
                      margin: const EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: CachedNetworkImage(
                          imageUrl: widget.object.coverPhoto ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black12, BlendMode.darken)),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const Center(child: CupertinoActivityIndicator()),
                          errorWidget: (context, url, error) => const Center(
                              child: Icon(
                            Icons.error,
                            color: Colors.grey,
                          )),
                        ),
                      )),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 4, 0, 0),
                          child: Row(
                            children: <Widget>[
                              Text(widget.object.category ?? '',
                                  style: TextStyles.caption(context)
                                  .copyWith(color: Colors.white),
                                  ),
                              const Spacer(),
                              Text(
                                  TimUtil.timeFormatter(widget.object.duration ?? 0),
                                  style: TextStyles.caption(context)
                                  .copyWith(color: Colors.white),
                                  ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 10, 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.object.title ?? '',
                                maxLines: 1,
                                style: TextStyles.subhead(context).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const Spacer(),
                            widget.object.status == DownloadTaskStatus.complete
                                ? Align(
                                    alignment: Alignment.centerRight,
                                    child: MediaPopupMenu(
                                      Downloads.mapMediaFromDownload(
                                          widget.object),
                                      isDownloads: true,
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: _buildActionForTask(widget.object),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 0,
            ),
            widget.object.status == DownloadTaskStatus.running ||
                    widget.object.status == DownloadTaskStatus.paused
                ? LinearProgressIndicator(
                    value: (widget.object.progress??0) / 100,
                  )
                : Container(),
            const Divider()
          ],
        ),
      ),
    );
  }

  Widget? _buildActionForTask(Downloads task) {
    if (task.status == DownloadTaskStatus.undefined) {
      return RawMaterialButton(
        onPressed: () {
          widget.downloadsModel.requestDownload(task);
        },
        shape: const CircleBorder(),
        constraints: const BoxConstraints(minHeight: 32.0, minWidth: 32.0),
        child: const Icon(Icons.file_download),
      );
    } else if (task.status == DownloadTaskStatus.running) {
      return RawMaterialButton(
        onPressed: () {
          widget.downloadsModel.pauseDownload(task);
        },
        shape: const CircleBorder(),
        constraints: const BoxConstraints(minHeight: 32.0, minWidth: 32.0),
        child: const Icon(
          Icons.pause,
          color: Colors.red,
        ),
      );
    } else if (task.status == DownloadTaskStatus.paused) {
      return RawMaterialButton(
        onPressed: () {
          widget.downloadsModel.resumeDownload(task);
        },
        shape: const CircleBorder(),
        constraints: const BoxConstraints(minHeight: 32.0, minWidth: 32.0),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.green,
        ),
      );
    } else if (task.status == DownloadTaskStatus.complete) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Ready',
            style: TextStyle(color: Colors.green),
          ),
          RawMaterialButton(
            onPressed: () {
              widget.downloadsModel.delete(task);
            },
            shape: const CircleBorder(),
            constraints: const BoxConstraints(minHeight: 32.0, minWidth: 32.0),
            child: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          )
        ],
      );
    } else if (task.status == DownloadTaskStatus.canceled) {
      return const Text('Canceled', style: TextStyle(color: Colors.red));
    } else if (task.status == DownloadTaskStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text('Failed', style: TextStyle(color: Colors.red)),
          RawMaterialButton(
            onPressed: () {
              widget.downloadsModel.retryDownload(task);
            },
            shape: const CircleBorder(),
            constraints: const BoxConstraints(minHeight: 32.0, minWidth: 32.0),
            child: const Icon(
              Icons.refresh,
              color: Colors.green,
            ),
          )
        ],
      );
    } else {
      return null;
    }
  }
}
