import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:skyislimit/models/repo_model.dart';
import 'package:skyislimit/screens/profile.dart';
import 'package:skyislimit/screens/repo.dart';

class DetailScreen extends StatefulWidget {
  String name;
  String image;
  String repoUrl;
   DetailScreen({required this.name,required this.image,required this.repoUrl});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  List<RepoModel>? repoModel;
  Dio _dio = Dio();
  bool loading = false;

  Future<List<RepoModel>?> gerRepo()async {
    final repoModelList = <RepoModel>[];
    Response response = await _dio.get(widget.repoUrl);
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
                tabs: [
              Text("Profile"),
              Text("Repositories")
            ]
            ),
          ),
          body: TabBarView(
              children: [
                (loading == true)?Center(child: CircularProgressIndicator(),): ProfileScreen(name:widget.name, Image: widget.image,repoLength: repoModel!.length,),
                RepoScreen(repoUrl: widget.repoUrl,)
              ]
          ),
        )
    );
  }
}
