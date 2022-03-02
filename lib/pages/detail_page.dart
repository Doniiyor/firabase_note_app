import 'package:firabasenoteapp/SERVICES/hive_db_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../SERVICES/rtdb_services.dart';
import '../models/post_model.dart';

class DetailPage extends StatefulWidget {
  static const String id = "/detail_page";
  const DetailPage({Key? key}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var isLoading = false;

  var firstNameController = TextEditingController();
  var dateController = TextEditingController();
  var contentController = TextEditingController();

  _addPost() async {
    String firstName = firstNameController.text.trim().toString();
    String content = contentController.text.trim().toString();
    DateTime date = DateTime.parse(dateController.text.trim().toString());
    if (dateController.text.isEmpty ||
        content.isEmpty ||
        firstName.isEmpty) return;
    _apiAddPost(firstName, date, content);
  }

  _apiAddPost(String name, DateTime date, String content) async {
    var id = HiveBase.loadUser();
    RTDBService.addPost(Post(id!, name, date, content)).then((response) => {
      _respAddPost(),
    });
  }

  _respAddPost() {
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop({'data': 'done'});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Add Post"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      hintText: "First Name",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: const InputDecoration(
                      hintText: "Content",
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    keyboardType: TextInputType.datetime,
                    controller: dateController,
                    decoration: const InputDecoration(
                      hintText: "Date",
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          builder: (context, child){
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.blue, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary: Colors.blue, // button text color
                                  ),
                                ),
                              ), child: child!,
                            )
                          }
                      );
                      if (pickedDate != null) {
                        String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: MaterialButton(
                      onPressed: _addPost,
                      color: Colors.blue,
                      child: const Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
