import 'package:flutter/material.dart';
import 'package:herewego/models/post_model.dart';
import 'package:herewego/services/auth_service.dart';
import 'package:herewego/services/prefs_service.dart';
import 'package:herewego/services/rtdb_service.dart';

import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  static String id = "home_page";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var isLoading = false;
  List<Post> items = [];
  
  Future openDetail() async{
    Map results = await Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context){
        return new DetailPage();
      }
    ));
    if(results != null && results.containsKey("data")){
      print(results["data"]);
      _apiGetPost();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiGetPost();
  }

   _apiGetPost() async {
    setState(() {
      isLoading = true;
    });
    var id = await Prefs.loadUserId();
    RTDBService.getPosts(id).then((response) => {
      _respPost(response)
    });
   }

   _respPost(List<Post> posts){
    setState(() {
      isLoading = false;
      items = posts;
    });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("All Posts"),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white,),
            onPressed: (){
              AuthService.signOutUser(context);
            },
          )
        ],
      ),
      body:  Stack(
        children: [
          ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, i){
              return itemOfList(items[i]);
            },
          ),
          isLoading ? Center(
            child: CircularProgressIndicator()
          ):
          SizedBox.shrink()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white,),
          onPressed: openDetail,
        ),
      ),
    );
  }

  Widget itemOfList(Post post){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: 200,
            width: double.infinity,
            child: post.img_url == null ?
            Image.asset("assets/images/ic_default.jpg", fit: BoxFit.cover,):
            Image.network(post.img_url, fit: BoxFit.cover,)
          ),
          SizedBox(height: 5,),
          Text(post.firstName + " " + post.lastName, style: TextStyle(fontSize: 20),),
          SizedBox(height: 5,),
          Text(post.date, style: TextStyle(fontSize: 16),),
          SizedBox(height: 5,),
          Text(post.content, style: TextStyle(fontSize: 16),)
        ],
      ),
    );
  }
}
