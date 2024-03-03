import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:dhak_dhol/provider/genre_provider.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../search/search_music_content.dart';

class GenreScreen extends StatefulWidget {
  const GenreScreen({Key? key, this.genreTitle}) : super(key: key);
  final Genres? genreTitle;

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          GenreProvider(widget.genreTitle?.id ?? ''),
      child: Consumer<GenreProvider>(
        builder: (BuildContext context, provider, _) {
          return Scaffold(
            backgroundColor: AppColor.deepBlue,
            appBar: AppBar(
              backgroundColor: AppColor.deepBlue,
              title: Text(widget.genreTitle?.name ?? ''),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  provider.medias.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: provider.medias.length,
                            itemBuilder: (context, index) {
                              return SearchMusicContent(
                                selectMusic: provider.medias.elementAt(index),
                                mediaList: provider.medias,
                                index: index,
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
