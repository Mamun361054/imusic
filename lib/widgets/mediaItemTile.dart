import 'package:dhak_dhol/widgets/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../data/model/media_model.dart';
import '../provider/music/audio_provider.dart';
import '../screens/home/music_player_page/audio_player_new_page.dart';
import '../utils/TextStyles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/TimUtil.dart';

class ItemTile extends StatefulWidget {
  final Media media;
  final List<Media> mediaList;
  final int index;

  const ItemTile({
    Key? key,
    required this.mediaList,
    required this.index,
    required this.media,
  }) : super(key: key);

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<AudioProvider>(context, listen: false).preparePlaylist(widget.mediaList, widget.media,widget.index);
        Navigator.of(context).pushNamed(AudioPlayerNewPage.routeName);
      },
      child: Container(
        height: 130,
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
                        height: 80,
                        width: 80,
                        child: CachedNetworkImage(
                          imageUrl: widget.media.coverPhoto ?? '',
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
                              Text(
                                widget.media.artist ?? '',
                                style: TextStyles.caption(context)
                                    .copyWith(color: Colors.white),
                              ),
                              const Spacer(),
                              Text(
                                TimUtil.timeFormatter(
                                    widget.media.duration ?? 0),
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
                            child: Text(widget.media.title ?? '',
                                maxLines: 2,
                                style: TextStyles.subhead(context).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: <Widget>[
                            widget.media.viewsCount == 0
                                ? Container()
                                : Text(
                                    "${widget.media.viewsCount} view(s)",
                                    style: TextStyles.caption(context)
                                        .copyWith(color: Colors.white),
                                  ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.centerRight,
                              child: MediaPopupMenu(widget.media),
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
            Divider(
              height: 0.1,
              //color: Colors.grey.shade800,
            )
          ],
        ),
      ),
    );
  }
}
