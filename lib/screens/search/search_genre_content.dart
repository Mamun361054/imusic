import 'package:dhak_dhol/data/model/genres_model.dart';
import 'package:flutter/material.dart';
import '../home/playlists/playlists_content.dart';

class SearchGenreContent extends StatelessWidget {
  final List<Genres> genres;
  const SearchGenreContent({Key? key,required this.genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: genres.length,
          separatorBuilder: (_,__) => Divider(color: Colors.grey,),
          itemBuilder: (BuildContext ctx, index) {
            final genre = genres[index];
            return GenreListContent(genres: genre);
          }),
    );
  }
}
