import 'package:flutter/material.dart';
import 'package:herewego/models/post_model.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);
  static final String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var contentController = TextEditingController();
  var dateController = TextEditingController();

   addPost() async {

     String firstName = firstNameController.text.toString().trim();
     String lastName = lastNameController.text.toString().trim();
     String content = contentController.text.toString().trim();
     String date = dateController.text.toString().trim();

     if(firstName.isEmpty || lastName.isEmpty || content.isEmpty || date.isEmpty) return ;

     _apiAddPosts(firstName, lastName, content, date);
   }

   _apiAddPosts(String firstName, lastName, content, date) async {
     var id = await Prefs.loadUserId();
     RTDBService.addPost(new Post(id, firstName, lastName, content, date)).then((response) => {
       _respAddPost()
     });
   }
     _respAddPost(){
     Navigator.of(context).pop({"data" : "done"});
     }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Add post"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: "Firstname",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: "Lastname",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  hintText: "Content",
                ),
              ),
              SizedBox(height: 15,),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  hintText: "Date",
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 45,
                width: double.infinity,
                child: MaterialButton(
                  color: Colors.deepOrange,
                  onPressed: addPost,
                  child: Text("Add", style: TextStyle(color: Colors.white,fontSize: 17),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
