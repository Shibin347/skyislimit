import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  String? Image;
  String? name;
  int? repoLength;
   ProfileScreen({Key? key,this.name,this.Image,this.repoLength}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           SizedBox(
             width: 70,
             height: 70,
             child: Padding(
               padding: const EdgeInsets.all(8.0),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(100),
                 child: Image.network(widget.Image.toString()),
               ),
             ),
           ),
            const SizedBox(width: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name.toString(),style: const TextStyle(fontWeight: FontWeight.bold),),
                 const SizedBox(height: 10,),
                  Text("Total Repositories are :" +widget.repoLength.toString())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
