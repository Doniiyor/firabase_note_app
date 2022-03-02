import 'package:firabasenoteapp/SERVICES/auth_services.dart';
import 'package:firabasenoteapp/SERVICES/hive_db_services.dart';
import 'package:firabasenoteapp/pages/sign_in_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../SERVICES/rtdb_services.dart';
import '../models/post_model.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const String id = "/home_page";
  User user;
   HomePage({Key? key,  required this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Post> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPosts();
  }

  Future _openDetail() async {
    Map results = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return DetailPage();
    }));
    if (results.containsKey("data")) {
      print(results['data']);
      _apiGetPosts();
    }
  }

  _apiGetPosts() async {
    var id = HiveBase.loadUser();
    RTDBService.getPosts(id!).then((posts) => {
      _respPosts(posts),
    });
  }

  _respPosts(List<Post> posts) {
    setState(() {
      items = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      drawer: Drawer(

        child:  ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.amber,
                child: Text(widget.user.displayName![0],style: const TextStyle(fontSize: 20),),
              ),
              accountName: Text(
                widget.user.displayName!,
                style: const TextStyle(fontSize: 16),
              ),
              accountEmail: Text(widget.user.email!),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // AuthServices.signOut(context);
                      showDialog<String> (
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Deleted"),
                          content: Text("do you really want to deleted?"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context,"Cancel");
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: (){
                                //   Navigator.pop(context);
                                AuthServices.deletUser(context).then((value) {
                                  Navigator.pushNamedAndRemoveUntil(context, SignInPage.id, (route) => false);

                                });

                              },
                              child: Text("Ok"),
                            )
                          ],
                        ),

                      );

                    },
                    child: Text("Deleted Account", style: TextStyle(color: Colors.blue, fontSize: 16),),
                  ),
                  TextButton(
                    onPressed: () {
                      // AuthServices.signOut(context);
                      showDialog<String> (
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Log Aut"),
                          content: Text("do you really want to logaut?"),
                          actions: [
                            TextButton(
                              onPressed: (){
                                Navigator.pop(context,"Cancel");
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: (){


                                AuthServices.signOut(context);
                              },
                              child: Text("Ok"),
                            )
                          ],
                        ),

                      );

                    },
                    child: Text("Logout Accaunt", style: TextStyle(color: Colors.blue, fontSize: 16),),
                  ),
                ],
              ),
            ),

          ],
        ),


      ),
      body: items.isEmpty?Container():ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return userPost(items[index]);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetail,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget userPost(Post post) {
    return Card(
      //padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.name,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            post.content,
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            post.date.toString().substring(0,10),
            style: const TextStyle(color: Colors.black, fontSize: 16),
          ),

        ],
      ),
    );
  }
}





/*
 Drawer(
        child: Container(
          margin: EdgeInsets.only(top: 45,left: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 5),
                decoration: BoxDecoration(
                //  color: Colors.tealAccent.shade200
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 35,
                    ),
                    SizedBox(height: 15),
                    Text(widget.user!.displayName!),
                    SizedBox(height: 15,),
                    Text(widget.user!.email!),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  // AuthServices.signOut(context);
                 showDialog<String> (
                   context: context,
                   builder: (BuildContext context) => AlertDialog(
                   title: Text("Log Aut"),
                   content: Text("do you really want to logaut?"),
                     actions: [
                       TextButton(
                         onPressed: (){
                           Navigator.pop(context,"Cancel");
                         },
                         child: Text("Cancel"),
                       ),
                       TextButton(
                         onPressed: (){


                           AuthServices.signOut(context);
                         },
                         child: Text("Ok"),
                       )
                     ],
                   ),

                 );

                },
                child: Text("Logout Accaunt", style: TextStyle(color: Colors.blue, fontSize: 16),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // AuthServices.signOut(context);
                  showDialog<String> (
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text("Deleted"),
                      content: Text("do you really want to deleted?"),
                      actions: [
                        TextButton(
                          onPressed: (){
                            Navigator.pop(context,"Cancel");
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                            AuthServices.deletUser(context).then((value) {
                                Navigator.pushNamedAndRemoveUntil(context, SignInPage.id, (route) => false);

                            });

                          },
                          child: Text("Ok"),
                        )
                      ],
                    ),

                  );

                },
                child: Text("Deleted Account", style: TextStyle(color: Colors.blue, fontSize: 16),),
              ),
            ],
          ),
        ),
      ),
 */