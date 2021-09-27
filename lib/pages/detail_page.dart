import 'dart:io';

import 'package:flutter/material.dart';
import 'package:herewego/models/post_model.dart';
import 'package:herewego/pages/storage_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key key}) : super(key: key);
  static final String id = "detail_page";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  var isLoading = false;
  File _image;
  final picker  = ImagePicker();

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
     if(_image == null) return;

     _apiUploadImage(firstName, lastName, content, date);
   }

   void _apiUploadImage(String firstName, String lastName, String content,String date ){
     setState(() {
       isLoading = true;
     });
     StorService.UploadImage(_image).then((img_url) => {
       _apiAddPosts(firstName, lastName, content, date, img_url)
     });
   }

   _apiAddPosts(String firstName, lastName, content, date, img_url) async {
     var id = await Prefs.loadUserId();
     RTDBService.addPost(new Post(id, firstName, lastName, content, date, img_url)).then((response) => {
       _respAddPost()
     });
   }
     _respAddPost(){
     setState(() {
       isLoading = false;
     });
     Navigator.of(context).pop({"data" : "done"});
     }

   Future  getImage() async{
      final pickedFile = await picker.getImage(source: ImageSource.gallery);

      setState(() {
        if(pickedFile != null){
          _image = File(pickedFile.path);
        }else{
          print("No images selected");
        }
      });
     }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Add post"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 100,
                      width: 100,
                      child: _image != null ?
                      Image.file(_image, fit: BoxFit.cover,) :
                      Image.asset("assets/images/ic_image.jpeg"),
                    ),
                  ),
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
          isLoading ? Center(
            child: CircularProgressIndicator(),
          ):
              SizedBox.shrink()
        ],
      )
    );
  }
}
