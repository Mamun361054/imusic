import 'package:dhak_dhol/model/search_item_model.dart';
import 'package:dhak_dhol/provider/search_provider.dart';
import 'package:dhak_dhol/screens/search/search_content.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (BuildContext context, provider, _) {
          return Scaffold(
            backgroundColor: AppColor.signInPageBackgroundColor,
            appBar: AppBar(
              backgroundColor: AppColor.signInPageBackgroundColor,
              title: const Text(
                'Search',
                style: TextStyle(color: Color(0xffeeeeee)),
              ),
            ),
            body: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Color(0xff330066)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: TextField(
                      controller: provider.searchController,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (query) {
                        provider.searchMedia(query);
                      },
                      onChanged: (val) {
                        provider.debounce.run(() {
                          provider.searchMedia(val);
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Icon(
                              Icons.search,
                              color: Colors.white.withOpacity(.4),
                            ),
                          ),
                          hintText: 'Search, artists, album',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(.4)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                provider.searchMedia(provider.searchController.text);
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white.withOpacity(.4),
                              ))),
                    ),
                  ),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 2.5,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0),
                    itemCount: 6,
                    itemBuilder: (context, index) {

                      final item = searchItems[index];

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: provider.filterIndex == index ? AppColor.inputBackgroundColor: AppColor.filterItemColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0))),
                          onPressed: () {
                            provider.updateFilterViewIndex(index: index);
                          }, child: Row(
                            children: [
                              Icon(item.icon,size: 20.0,),
                              SizedBox(width: 4.0,),
                              Text('${item.title}'),
                            ],
                          ));
                    }),
                Visibility(
                  visible: provider.isLoading,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Color(0xff330066)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SearchContent(viewIndex: provider.filterIndex, searchModel: provider.searchModel,),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
