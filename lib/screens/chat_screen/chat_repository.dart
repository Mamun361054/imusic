import 'package:dhak_dhol/data/Repository/repositor.dart';
import 'package:dhak_dhol/data/model/firebase_model/Search_user_response.dart';
import 'package:dhak_dhol/utils/shared_pref.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatRepository{


  Repository repository = Repository();

  Future<List<ChatProfileSearch>> chatUserSearchApi(context,query) async {

    final email = await SharedPref.getValue(SharedPref.keyEmail);

    FormData fromData = FormData.fromMap({
      "email": email,
      "query": query
    });

    final response = await repository.chatUserSearch(query);

    if(response?.status == "success"){
    return response?.searchProfiles ?? [];
    }
    return [];
  }
}