import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pms/Blogs/blogs_details.dart';
import 'package:project_pms/Forum/forum_home.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/hidden_drawer/drawer.dart';
import 'package:project_pms/home_page.dart';
import 'package:project_pms/map/map_screen.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shop/shop_home.dart';

class BlogsList extends DrawerContent {

  BlogsList({Key key, String title});
  @override
  _BlogsListState createState() => _BlogsListState();
}

class _BlogsListState extends State<BlogsList> {
  List blogList = [];
  HiddenDrawerController _drawerController;
  String title;




  void initState() {
    // TODO: implement initState
    super.initState();


    _drawerController = HiddenDrawerController(

      items: [
        DrawerItem(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(Icons.home, color: Colors.white),

        ),
        DrawerItem(
          text: Text(
            'Gallery',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.photo_album, color: Colors.white),

        ),
        DrawerItem(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => BlogsList()));
          },
          text: Text(
            'Favorites',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.favorite, color: Colors.white),

        ),
        DrawerItem(
          text: Text(
            'Notification',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.notifications, color: Colors.white),

        ),
        DrawerItem(
          text: Text(
            'Invite',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.insert_invitation, color: Colors.white),

        ),
        DrawerItem(
          text: Text(
            'SETTINGS',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(Icons.settings, color: Colors.white),

        ),
      ],
    );



    getBlogsList();
  }


  getBlogsList() async{

    await FirebaseFirestore.instance.collection('Blogs').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {

          blogList.add(doc);
        });



        // print(value['Name']);
      });
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.78*SizeConfig.heightMultiplier,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: widget.onMenuPressed,icon: Icon(Icons.menu,color: Colors.black,)),
            Image.asset('assets/images/stree_sanman_logo.png',width: 29.19*SizeConfig.imageSizeMultiplier,),

          ],
        ),
        backgroundColor: Colors.white,

      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 15),
            itemCount: blogList.length,
            itemBuilder: (context,index){

          return InkWell(
            onTap: () async{

              setState(() {
                loading = true;
              });


              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BlogsDetails(blogId: blogList[index].id,)));




              setState(() {
                loading = false;
              });
            },
            child: Container(
              height: 160,
              margin: EdgeInsets.only(bottom: 15),
              child: Stack(
                children: [
                 ClipRRect(
                   borderRadius: BorderRadius.circular(15),
                   child: FadeInImage.assetNetwork(
                     placeholder: 'assets/images/shop_banner.jpg',
                     image: blogList[index]['BlogCoverImage'],
                     width: MediaQuery.of(context).size.width,

                     fit: BoxFit.cover,

                   ),
                 ),
                  Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.black45.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 6,),
                        Text(blogList[index]['BlogTitle'],
                        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                          overflow: TextOverflow.ellipsis,),
                        SizedBox(height: 4,),
                        Text(blogList[index]['BlogerName'],
                          style: TextStyle(color: Colors.white,fontSize: 17,),
                          textAlign: TextAlign.center,)

                      ],

                    )
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}




class MainWidgetBlogs extends StatefulWidget {
  MainWidgetBlogs({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;

  @override
  _MainWidgetBlogsState createState() => _MainWidgetBlogsState(uid);
}

class _MainWidgetBlogsState extends State<MainWidgetBlogs> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;
  final String uid;

  _MainWidgetBlogsState(this.uid);

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: BlogsList(
        title: "shop",

      ),

      items: [
        DrawerItem(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(FontAwesomeIcons.home, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier,),
          page: BlogsList(
              title: 'Home',

          ),
          onPressed: () async{
            setState(() {
              loading = true;
            });
            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : uid)));
            setState(() {
              loading = false;
            });

          },
        ),
        DrawerItem(
          text: Text(
            'Shop',
            style: TextStyle(color: Colors.white),
          ),

          onPressed: () async{

            setState(() {
              loading = true;
            });

            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidgetShop(uid : uid)));

            setState(() {
              loading = false;
            });

          },
          icon: Icon(FontAwesomeIcons.store, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: BlogsList(
            title: 'Shop',
          ),
        ),
        DrawerItem(

          text: Text(
            'Blogs',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(FontAwesomeIcons.newspaper, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: BlogsList(
            title: 'Blogs',
          ),
        ),
        DrawerItem(
          text: Text(
            'Forum',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ForumHome(uid : uid)));

          },
          icon: Icon(FontAwesomeIcons.book, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: BlogsList(
            title: 'Forum',
          ),
        ),
        DrawerItem(
          text: Text(
            'Maps',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async{

            setState(() {
              loading = true;
            });
            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidgetMap(uid : uid)));


            setState(() {
              loading = false;
            });

          },
          icon: Icon(FontAwesomeIcons.map, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: BlogsList(
            title: 'maps',
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HiddenDrawer(
        controller: _drawerController,
        header: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/smileyface.png"),
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Miroslava Savitskaya',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                        Text('Active Status',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),

            ],
          ),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xfff953c6), Color(0xffb91d73)],
            // tileMode: TileMode.repeated,
          ),
        ),
      ),
    );
  }
}
