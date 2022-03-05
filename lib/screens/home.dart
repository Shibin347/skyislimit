
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skyislimit/models/user_model.dart';
import 'package:skyislimit/screens/tab_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  List<UserModel>? userModel;
  bool searching = false;
  Icon customIcon = const Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget customSearchBar = const Text(
    'Users',
    style: TextStyle(fontSize: 25, color: Colors.white),
  );
  TextEditingController searchController = TextEditingController();
  List<UserModel> secondList = [];

  Dio _dio = Dio();
  String baseUrl = "https://api.github.com/users";
  Future<List<UserModel>?> getUsers() async {
// create a list of userModel

    final userModelList = <UserModel>[];

    Response response = await _dio.get(baseUrl);

    UserModel? singleUserModel;

    for (var item in response.data) {
      singleUserModel = UserModel.fromJson(
          item); //factory method to convert json to Map<String,dynamic>
      userModelList.add(singleUserModel);
      userModel = userModelList;
    }
    if(mounted){
      setState(() {
        loading = false;
      });
    }
  }

  bool? _isConnected;

  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.kindacode.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        _isConnected = false;
      });
      if (kDebugMode) {
        print(err);
      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    _checkInternetConnection();
     getUsers();
    loading = true;
    TextEditingController searchController = TextEditingController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return(_isConnected == false)? Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            Text("No Internet Connection. "),
            TextButton(onPressed: (){
              _checkInternetConnection().whenComplete(() => getUsers());
            }, child: Text("Retry"))
          ],
        ),
      )
    ): Scaffold(
      appBar: AppBar(
        title:customSearchBar,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  searching = true;
                  customIcon = const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  );
                  customSearchBar = TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                        hintText: 'Search Item.....',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                        border: InputBorder.none),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (string) {
                      setState(() {
                        secondList = userModel!.where((element) => (element.login!
                            .toLowerCase()
                            .contains(string.toLowerCase())))
                            .toList();
                      });
                    },
                  );
                } else {
                  searching = false;
                  customIcon = const Icon(
                    Icons.search,
                    color: Colors.white,
                  );
                  customSearchBar = const Text(
                    "Digital Menu",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  );
                }
              });
            },
            icon: customIcon,
          ),
        ],
      ),
      body: (loading == true)?
      const
      Center(
        child: CircularProgressIndicator(),
      ): Visibility(
        replacement:const Center(
          child: Text("No Data Found"),
        ),
          child:(searching == true)?ListView.builder(
            itemCount: secondList.length,
              itemBuilder: (context, index){
              return Column(
                children: [
                  ListTile(
                    title: Text(secondList[index].login.toString()),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(name: secondList[index].login.toString(),image: secondList[index].avatarUrl.toString(),repoUrl: secondList[index].reposUrl.toString(),)));
                    },
                  ),
                  const Divider()
                ],
              );

          }
          ): ListView.builder(
            itemCount: userModel!.length,
              itemBuilder: (context, index){
                return Column(
                  children: [
                    ListTile(
                      title: Text(userModel![index].login!),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(name: userModel![index].login.toString(),image: userModel![index].avatarUrl.toString(),repoUrl: userModel![index].reposUrl.toString(),)));
                      },
                    ),
                   const Divider()
                  ],
                );

              }
          )

      )
    );
  }
}

