import 'package:dhak_dhol/provider/add_album_provider.dart';
import 'package:dhak_dhol/utils/app_const.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAlbumScreen extends StatefulWidget {
  const AddAlbumScreen({Key? key}) : super(key: key);

  @override
  State<AddAlbumScreen> createState() => _AddAlbumScreenState();
}

class _AddAlbumScreenState extends State<AddAlbumScreen> {
  bool _validate = false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AddAlbumProvider(),
      child: Consumer<AddAlbumProvider>(
        builder: (BuildContext context, provider, _) {
          return Scaffold(
            backgroundColor: AppColor.deepBlue,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColor.deepBlue,
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Center(child: Image.asset('assets/images/app_logo.png')),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Add new album to your account',
                      style: TextStyle(color: AppColor.textColor, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 156,
                      width: 343,
                      decoration: BoxDecoration(
                          color: AppColor.backgroundColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: InkWell(
                        onTap: () {
                          provider.pickAlbumImage();
                        },
                        child: DottedBorder(
                          radius: const Radius.circular(50),
                          color: Colors.red,
                          strokeWidth: .4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/cloud-upload.png'),
                                Text(
                                  'Drag  your music cover',
                                  style: TextStyle(
                                      color: AppColor.textColor, fontSize: 18),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Add Album title",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.manrope(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: provider.titleController,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        errorText:
                            _validate ? 'Please add a album title here' : null,
                        contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                        filled: true,
                        fillColor: AppColor.fromFillColor,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            provider.titleController.text.isEmpty
                                ? _validate = true
                                : _validate = false;
                          });
                          provider.albumAdd(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: AppColor.buttonColor,
                          onPrimary: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Add Album',
                            style: GoogleFonts.manrope(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
