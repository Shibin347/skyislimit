import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/repo_model.dart';

class RepoScreen extends StatefulWidget {
  String? repoUrl;
   RepoScreen({this.repoUrl});

  @override
  _RepoScreenState createState() => _RepoScreenState();
}

class _RepoScreenState extends State<RepoScreen> {
  List<RepoModel>? repoModel;
  Dio _dio = Dio();
  bool loading = false;

  Future<List<RepoModel>?> gerRepo()async {
    final repoModelList = <RepoModel>[];
    Response response = await _dio.get(widget.repoUrl.toString());
    RepoModel? singleRepoModel;

    for (var item in response.data) {
      singleRepoModel = RepoModel.fromJson(
          item); //factory method to convert json to Map<String,dynamic>
      repoModelList.add(singleRepoModel);
      repoModel = repoModelList;
      print(repoModel!.length);
    }
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    gerRepo();
    loading = true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (loading ==true)?const
      Center(
        child: CircularProgressIndicator(),
      ): ListView.builder(
        itemCount: repoModel!.length,
          itemBuilder: (context, index){
            return Column(
              children: [
            ListTile(
            title: Text(repoModel![index].name.toString()),
            subtitle: Text(repoModel![index].fullName.toString()),
              onTap: ()async{
              String googleUrl = repoModel![index].htmlUrl.toString();
              print(googleUrl);
              await launch(googleUrl);
              },
            ),
               const Divider()
              ],
            );
          }
      )
    );
  }
}
