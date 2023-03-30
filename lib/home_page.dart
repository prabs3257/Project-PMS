import 'dart:convert';
import 'dart:io';

import 'package:calendar_strip/calendar_strip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_pms/Blogs/blogs_details.dart';
import 'package:project_pms/Blogs/blogs_list.dart';
import 'package:project_pms/Forum/forum_home.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/hidden_drawer/drawer.dart';
import 'package:project_pms/main.dart';
import 'package:project_pms/map/map_screen.dart';
import 'package:project_pms/profile_page.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
import 'package:project_pms/shop/shop_home.dart';
import 'package:project_pms/slider/custom_slider_thumb_rect.dart';
import 'package:project_pms/slider/slider_widget.dart';
import 'package:project_pms/utils.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:configurable_expansion_tile/configurable_expansion_tile.dart';
import 'package:expandable/expandable.dart';
import 'package:project_pms/slider/slider_widget.dart';


import 'authentication/authentication.dart';
import 'constants.dart';
bool isSubmitted;

class DashboardPage extends DrawerContent {

  final String uid;


   DashboardPage({Key key, this.uid, String title});

  @override
  _DashboardPageState createState() => _DashboardPageState(uid);
}



class _DashboardPageState extends State<DashboardPage> {

  final String uid;

  String title;

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String test = "Please Fill the form";
  bool showForm = true;
  CalendarFormat _calendarFormat;

  bool canShowMoreBlogs = true;
  int noBlogsShown = 0;

  List blogList = [];

  double value1 = 6;
  double value2 = 5;
  double value3 = 4;
  double value4 = 8;
  double value5 = 7;

  String imageUrl = "https://firebasestorage.googleapis.com/v0/b/project-pms-4770e.appspot.com/o/arnel-hasanovic-MNd-Rka1o0Q-unsplash.jpg?alt=media&token=08a59060-4859-4cc5-a37c-9f00a9748f32";






  var userData = FirebaseFirestore.instance.collection('userdata');

  _DashboardPageState(this.uid);


  Future<void> showInformationDialog(BuildContext context) async{

    String name;
    String age;
    String number;
    String duration;
    String length;
    String lastdate;

    imageUrl = "https://firebasestorage.googleapis.com/v0/b/project-pms-4770e.appspot.com/o/arnel-hasanovic-MNd-Rka1o0Q-unsplash.jpg?alt=media&token=08a59060-4859-4cc5-a37c-9f00a9748f32";

    return await showDialog(context: context,
        barrierDismissible: false,
        builder: (context) {

          return Stack(

            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Dialog(

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      color: Colors.white,
                      height: 1000,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                      child: Text(
                                        "Name",
                                        style: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 15,
                                          color: Color(0xff8f9db5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                                    child: TextFormField(
                                      obscureText: false,
                                      // this can be changed based on usage -
                                      // such as - onChanged or onFieldSubmitted
                                      onChanged: (value) {
                                        name = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Enter your Name",
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[350],
                                            fontWeight: FontWeight.w600),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                        focusColor: Color(0xff0962ff),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Color(0xff0962ff)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.grey[350],
                                          ),
                                        ),
                                        suffixIcon: isSubmitted == true
                                        // will turn the visibility of the 'checkbox' icon
                                        // ON or OFF based on the condition we set before
                                            ? Visibility(
                                          visible: true,
                                          child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: IconButton(icon : Icon(Icons.add), onPressed: (){print("Hello");},)
                                          ),
                                        )
                                            : Visibility(
                                          visible: false,
                                          child: IconButton(icon : Icon(Icons.add), onPressed: (){print("Hello");},),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                      child: Text(
                                        "Age",
                                        style: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 15,
                                          color: Color(0xff8f9db5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                                    child: TextFormField(
                                      obscureText: false,
                                      // this can be changed based on usage -
                                      // such as - onChanged or onFieldSubmitted
                                      onChanged: (value) {
                                        age = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Enter your Age",
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[350],
                                            fontWeight: FontWeight.w600),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                        focusColor: Color(0xff0962ff),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Color(0xff0962ff)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.grey[350],
                                          ),
                                        ),
                                        suffixIcon: isSubmitted == true
                                        // will turn the visibility of the 'checkbox' icon
                                        // ON or OFF based on the condition we set before
                                            ? Visibility(
                                          visible: true,
                                          child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.add)
                                          ),
                                        )
                                            : Visibility(
                                          visible: false,
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                      child: Text(
                                        "Contact Number",
                                        style: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 15,
                                          color: Color(0xff8f9db5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                                    child: TextFormField(
                                      obscureText: false,
                                      // this can be changed based on usage -
                                      // such as - onChanged or onFieldSubmitted
                                      onChanged: (value) {
                                        number = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Enter your Contact Number",
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[350],
                                            fontWeight: FontWeight.w600),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                        focusColor: Color(0xff0962ff),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Color(0xff0962ff)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.grey[350],
                                          ),
                                        ),
                                        suffixIcon: isSubmitted == true
                                        // will turn the visibility of the 'checkbox' icon
                                        // ON or OFF based on the condition we set before
                                            ? Visibility(
                                          visible: true,
                                          child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.add)
                                          ),
                                        )
                                            : Visibility(
                                          visible: false,
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                ],
                              ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                      child: Text(
                                        "Duration of Cycle",
                                        style: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 15,
                                          color: Color(0xff8f9db5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                                    child: TextFormField(
                                      obscureText: false,
                                      // this can be changed based on usage -
                                      // such as - onChanged or onFieldSubmitted
                                      onChanged: (value) {
                                        duration = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Example: 30 Days",
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[350],
                                            fontWeight: FontWeight.w600),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                        focusColor: Color(0xff0962ff),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Color(0xff0962ff)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.grey[350],
                                          ),
                                        ),
                                        suffixIcon: isSubmitted == true
                                        // will turn the visibility of the 'checkbox' icon
                                        // ON or OFF based on the condition we set before
                                            ? Visibility(
                                          visible: true,
                                          child: Padding(
                                              padding: const EdgeInsets.only(right: 8.0),
                                              child: Icon(Icons.add)
                                          ),
                                        )
                                            : Visibility(
                                          visible: false,
                                          child: Icon(Icons.add),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                ],
                              ),
                              SizedBox(height: 10,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                  child: Text(
                                    "Length of Cycle",
                                    style: TextStyle(
                                      fontFamily: 'Product Sans',
                                      fontSize: 15,
                                      color: Color(0xff8f9db5),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 10,),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [

                                      Row(
                                        children: [
                                          Radio(value: null, groupValue: null, onChanged: null),
                                          Text("3 Days")
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(value: null, groupValue: null, onChanged: null),
                                          Text("3 Days")
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Radio(value: null, groupValue: null, onChanged: null),
                                          Text("3 Days")
                                        ],
                                      ),



                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,


                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    Row(
                                      children: [
                                        Radio(value: null, groupValue: null, onChanged: null),
                                        Text("3 Days")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(value: null, groupValue: null, onChanged: null),
                                        Text("3 Days")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Radio(value: null, groupValue: null, onChanged: null),
                                        Text("3 Days")
                                      ],
                                    ),



                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                      child: Text(
                                        "Last Period Date",
                                        style: TextStyle(
                                          fontFamily: 'Product Sans',
                                          fontSize: 15,
                                          color: Color(0xff8f9db5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
                                    child: TextFormField(
                                      obscureText: false,
                                      // this can be changed based on usage -
                                      // such as - onChanged or onFieldSubmitted
                                      onChanged: (value) {
                                        setState(() {
                                          isSubmitted = true;
                                        });
                                        lastdate = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "DD/MM/YYYY",
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey[350],
                                            fontWeight: FontWeight.w600),
                                        contentPadding:
                                        EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                        focusColor: Color(0xff0962ff),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(color: Color(0xff0962ff)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.grey[350],
                                          ),
                                        ),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.only(right: 8.0),
                                          child: IconButton(icon : Icon(Icons.add), onPressed: (){print("Hello");}),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                ],
                              ),
                              SizedBox(height: 10,),
                              RawMaterialButton(
                                onPressed: () async{




                                  User user = await FirebaseAuth.instance.currentUser;

                                  if(user.providerData[0].providerId == 'facebook.com'){
                                    print("its facebook");

                                    await userData.doc(uid).set(
                                        { 'FormFilled' : true,
                                          'Name' : name,
                                          'Age' : age,
                                          'Number' : number,
                                          'Duration' : duration,
                                          'Last Date' : lastdate,
                                          'ProfilePic' : user.photoURL
                                        }
                                    );

                                    setState(() {
                                      imageUrl =user.photoURL;
                                    });

                                  }else{
                                    userData.doc(uid).set(
                                        { 'FormFilled' : true,
                                          'Name' : name,
                                          'Age' : age,
                                          'Number' : number,
                                          'Duration' : duration,
                                          'Last Date' : lastdate,
                                          'ProfilePic' : "https://firebasestorage.googleapis.com/v0/b/project-pms-4770e.appspot.com/o/arnel-hasanovic-MNd-Rka1o0Q-unsplash.jpg?alt=media&token=08a59060-4859-4cc5-a37c-9f00a9748f32"
                                        }
                                    );


                                  }

                                  Navigator.of(context, rootNavigator: true).pop();


                                },
                                elevation: 0.0,
                                fillColor: Palette.darkBlue,
                                splashColor: Palette.darkOrange,
                                padding:  EdgeInsets.all(3.22 * SizeConfig.heightMultiplier),
                                shape: const CircleBorder(),
                                child:  Icon(
                                  FontAwesomeIcons.longArrowAltRight,
                                  color: Colors.white,
                                  size: 2.19 * SizeConfig.heightMultiplier,
                                ),
                              ),











                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CircleAvatar(
                  child: Icon(Icons.add,
                    size: 50,color: Colors.black,),
                  radius: 50,
                  backgroundColor: Colors.white,
                ),
              )
            ],
          );




        });
  }



  HiddenDrawerController _drawerController;
  @override
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

    _calendarFormat = CalendarFormat.week;

    testing();
    getBlogs();
    getImage();


  }
  getImage() async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("userdata").doc(uid).get();
    setState(() {
      imageUrl = ds['ProfilePic'];
    });




  }



  void testing() async{

    try{

      DocumentSnapshot ds = await userData.doc(uid).get();

      print("testing1234");





      showInformationDialog(context);
      if(ds['FormFilled'] == true){

        Navigator.of(context, rootNavigator: true).pop();



        setState(() {




          test = "Already Done";
          print("is it done" + test);
        });
      }



    }catch(e){
      print(e);
    }






  }

  Future<void> getBlogs() async{

    await FirebaseFirestore.instance.collection('Blogs').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {

          blogList.add(doc);
        });

        setState(() {

          loading = false;
        });

        // print(value['Name']);
      });
    });

    noBlogsShown = blogList.length;
    if(blogList.length < 5){
      canShowMoreBlogs = false;
    }else{
      canShowMoreBlogs = true;
      setState(() {
        noBlogsShown = 4;
      });
    }


  }


  void openCalendar(){
    if(_calendarFormat == CalendarFormat.week){

      setState(() {
        //  _calendarFormat = CalendarFormat.month;

      });
    }



  }




  @override
  Widget build(BuildContext context) {


    DateTime _focusedDay = DateTime.now();
    List<DateTime> _selectedDay = [DateTime.utc(2021,5,25),DateTime.utc(2021,5,26),DateTime.utc(2021,5,24)];


    Widget roundedButton(String buttonLabel, Color bgColor, Color textColor) {
      var loginBtn = new Container(
        padding: EdgeInsets.all(5.0),
        alignment: FractionalOffset.center,
        decoration: new BoxDecoration(
          color: bgColor,
          borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF696969),
              offset: Offset(1.0, 6.0),
              blurRadius: 0.001,
            ),
          ],
        ),
        child: Text(
          buttonLabel,
          style: new TextStyle(
              color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      );
      return loginBtn;
    }


    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: roundedButton("No", const Color(0xFF167F67),
                  const Color(0xFFFFFFFF)),
            ),
            new GestureDetector(
              onTap: () {

                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else if (Platform.isIOS) {
                  exit(0);
                }

              },
              child: roundedButton(" Yes ", const Color(0xFF167F67),
                  const Color(0xFFFFFFFF)),
            ),
          ],
        ),
      ) ??
          false;
    }






    return loading ? Loading() : WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 8.78*SizeConfig.heightMultiplier,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: widget.onMenuPressed, icon: Icon(Icons.menu,color: Colors.black,)),
                    Image.asset('assets/images/stree_sanman_logo.png',width: 29.19*SizeConfig.imageSizeMultiplier,),

                  ],
                ),
                InkWell(
                    onTap: () async{

                      setState(() {
                        loading = true;
                      });

                      await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfilePage(uid : uid)));

                      setState(() {
                        loading = false;
                      });

                    },
                    child:
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipOval(


                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/shop_banner.jpg',
                          image: imageUrl,

                          width: 5.78*SizeConfig.heightMultiplier,
                          height: 5.78*SizeConfig.heightMultiplier,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),

                )

              ],
            ),
            backgroundColor: Colors.white,

          ),
          backgroundColor: Colors.white,
          body:
          SingleChildScrollView(
            child: Column(
              children: [






                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 0,
                        child: TableCalendar(
                          daysOfWeekStyle: DaysOfWeekStyle(dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0]),

                          firstDay: kFirstDay,
                          lastDay: kLastDay,
                          focusedDay: _focusedDay,
                          headerVisible: true,







                          calendarFormat: _calendarFormat,

                          selectedDayPredicate: (day) {
                            // Use `selectedDayPredicate` to determine which day is currently selected.
                            // If this returns true, then `day` will be marked as selected.

                            // Using `isSameDay` is recommended to disregard
                            // the time-part of compared DateTime objects.
                            return _selectedDay.contains(day);
                          },

                          onDaySelected: (selectedDay, focusedDay) {
                            // openCalendar();

                            print("hell");





                          },

                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              // Call `setState()` when updating calendar format
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },


                          onPageChanged: (focusedDay) {
                            // No need to call `setState()` here
                            _focusedDay = focusedDay;



                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const Divider(
                  height: 20,
                  thickness: 0.5,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),


                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier,vertical: 1*SizeConfig.heightMultiplier),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Period due in 2 days',
                        style: TextStyle(
                          color: Color.fromARGB(255, 206, 16, 16),

                          fontSize:3.87 * SizeConfig.imageSizeMultiplier,
                          fontWeight: FontWeight.w600,

                          fontFamily: 'OpenSans',
                        ),

                      ),
                      Text(
                        'Fertility due in 8 days',
                        style: TextStyle(
                          color: Color.fromARGB(255, 206, 16, 16),

                          fontSize: 3.87 * SizeConfig.imageSizeMultiplier,
                          fontWeight: FontWeight.w600,

                          fontFamily: 'OpenSans',
                        ),

                      ),

                    ],
                  ),
                ),

                const Divider(
                  height: 20,
                  thickness: 0.5,
                  indent: 15,
                  endIndent: 15,
                  color: Colors.black,
                ),

                SizedBox(height: 1.46*SizeConfig.heightMultiplier,),

                Text('Whats your mood today?',
                  style: TextStyle(color: Color.fromARGB(255, 0, 173, 207),
                  fontSize: 2.5*SizeConfig.heightMultiplier,fontWeight: FontWeight.w900),
                ),

                SizedBox(height: 2.89*SizeConfig.heightMultiplier,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [

                        Image(image: AssetImage("assets/images/emojitwo.png"),
                          width: 10.66 * SizeConfig.imageSizeMultiplier,),
                        SizedBox(height: 1.5*SizeConfig.heightMultiplier,),
                        Text("Happy",style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500,fontSize: 3.67 * SizeConfig.imageSizeMultiplier,),),



                      ],
                    ),
                    Column(
                      children: [
                        Image(image: AssetImage("assets/images/emojione.png"),
                          width: 10.66 * SizeConfig.imageSizeMultiplier,),
                        SizedBox(height: 1.5*SizeConfig.heightMultiplier,),
                        Text("Sad",style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500,fontSize: 3.67 * SizeConfig.imageSizeMultiplier),),

                      ],
                    ),
                    Column(
                      children: [
                        Image(image: AssetImage("assets/images/emojifour.png"),
                          width: 10.66 * SizeConfig.imageSizeMultiplier,),
                        SizedBox(height: 1.5*SizeConfig.heightMultiplier,),
                        Text("Anxious",style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500,fontSize: 3.67 * SizeConfig.imageSizeMultiplier),),

                      ],
                    ),
                    Column(
                      children: [
                        Image(image: AssetImage("assets/images/emojifour.png"),
                          width: 10.66 * SizeConfig.imageSizeMultiplier,),
                        SizedBox(height: 1.5*SizeConfig.heightMultiplier,),
                        Text("Anxious",style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500,fontSize: 3.67 * SizeConfig.imageSizeMultiplier),),

                      ],
                    ),
                    Column(
                      children: [
                        Image(image: AssetImage("assets/images/emojifive.png"),
                          width: 10.66 * SizeConfig.imageSizeMultiplier,),
                        SizedBox(height: 1.5*SizeConfig.heightMultiplier,),
                        Text("Frustrated",style: TextStyle(color: Colors.black38,fontWeight: FontWeight.w500,fontSize: 3.67 * SizeConfig.imageSizeMultiplier),),
                      ],
                    )
                  ],
                ),



                SizedBox(height: 2.89*SizeConfig.heightMultiplier,),

                Container(
                  height: 11.71*SizeConfig.heightMultiplier,
                  width: double.infinity,
                  color: Color.fromARGB(255, 0, 173, 207),
                  child: Row(
                    children: [

                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal:  3.64*SizeConfig.imageSizeMultiplier),
                        child: Container(
                          child: CircleAvatar(backgroundImage: AssetImage("assets/images/smileyface.png"),
                            radius: 6.08*SizeConfig.imageSizeMultiplier,backgroundColor: Colors.yellow,),
                        ),
                      ),
                      Container(
                        width:68.12 * SizeConfig.imageSizeMultiplier,
                        child: Text("\"There is only one happiness in this life, to love and to be loved.\"",
                          style: TextStyle(fontSize: 3.89*SizeConfig.imageSizeMultiplier,
                            color: Color.fromARGB(240, 255, 255, 255),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      )

                    ],
                  ),
                ),

                SizedBox(height: 2.29*SizeConfig.heightMultiplier,),


                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 4.86*SizeConfig.imageSizeMultiplier),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Headache",
                        style: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 173, 207),),),
                    ),

                    expanded: Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.grey.withOpacity(0.4),
                            inactiveTrackColor: Colors.grey.withOpacity(0.4),

                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: 48 * .4,
                              min: 0,
                              max: 10,
                            ),
                            overlayColor: Colors.white.withOpacity(.4),
                            //valueIndicatorColor: Colors.white,
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.red.withOpacity(.7),
                          ),
                          child: Slider(
                            min: 0,
                              max: 10,
                              value: value1,
                              onChanged: (value) {
                                setState(() {
                                  value1 = value;
                                });
                              }),
                        ),
                      ),
                    ),

                  ),
                ),
                const Divider(
                  height:10,
                  thickness: 0.5,
                  indent: 25,
                  endIndent: 25,
                  color: Colors.black45,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 4.86*SizeConfig.imageSizeMultiplier),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Body Pain",
                        style: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 173, 207),),),
                    ),

                    expanded: Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.grey.withOpacity(0.4),
                            inactiveTrackColor: Colors.grey.withOpacity(0.4),

                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: 48 * .4,
                              min: 0,
                              max: 10,
                            ),
                            overlayColor: Colors.white.withOpacity(.4),
                            //valueIndicatorColor: Colors.white,
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.red.withOpacity(.7),
                          ),
                          child: Slider(
                              min: 0,
                              max: 10,
                              value: value2,
                              onChanged: (value) {
                                setState(() {
                                  value2 = value;
                                });
                              }),
                        ),
                      ),
                    ),

                  ),
                ),
                const Divider(
                  height:10,
                  thickness: 0.5,
                  indent: 25,
                  endIndent: 25,
                  color: Colors.black45,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 4.86*SizeConfig.imageSizeMultiplier),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Abdominal Pain",
                        style: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 173, 207),),),
                    ),

                    expanded: Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.grey.withOpacity(0.4),
                            inactiveTrackColor: Colors.grey.withOpacity(0.4),

                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: 48 * .4,
                              min: 0,
                              max: 10,
                            ),
                            overlayColor: Colors.white.withOpacity(.4),
                            //valueIndicatorColor: Colors.white,
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.red.withOpacity(.7),
                          ),
                          child: Slider(
                              min: 0,
                              max: 10,
                              value: value3,
                              onChanged: (value) {
                                setState(() {
                                  value3 = value;
                                });
                              }),
                        ),
                      ),
                    ),

                  ),
                ),
                const Divider(
                  height:10,
                  thickness: 0.5,
                  indent: 25,
                  endIndent: 25,
                  color: Colors.black45,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 4.86*SizeConfig.imageSizeMultiplier),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Weakness",
                        style: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 173, 207),),),
                    ),

                    expanded: Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.grey.withOpacity(0.4),
                            inactiveTrackColor: Colors.grey.withOpacity(0.4),

                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: 48 * .4,
                              min: 0,
                              max: 10,
                            ),
                            overlayColor: Colors.white.withOpacity(.4),
                            //valueIndicatorColor: Colors.white,
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.red.withOpacity(.7),
                          ),
                          child: Slider(
                              min: 0,
                              max: 10,
                              value: value4,
                              onChanged: (value) {
                                setState(() {
                                  value4 = value;
                                });
                              }),
                        ),
                      ),
                    ),

                  ),
                ),
                const Divider(
                  height:10,
                  thickness: 0.5,
                  indent: 25,
                  endIndent: 25,
                  color: Colors.black45,
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 4.86*SizeConfig.imageSizeMultiplier),
                  child: ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Fever",
                        style: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Color.fromARGB(255, 0, 173, 207),),),
                    ),

                    expanded: Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.grey.withOpacity(0.4),
                            inactiveTrackColor: Colors.grey.withOpacity(0.4),

                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: 48 * .4,
                              min: 0,
                              max: 10,
                            ),
                            overlayColor: Colors.white.withOpacity(.4),
                            //valueIndicatorColor: Colors.white,
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.red.withOpacity(.7),
                          ),
                          child: Slider(
                              min: 0,
                              max: 10,
                              value: value5,
                              onChanged: (value) {
                                setState(() {
                                  value5 = value;
                                });
                              }),
                        ),
                      ),
                    ),

                  ),
                ),
                const Divider(
                  height:10,
                  thickness: 0.5,
                  indent: 25,
                  endIndent: 25,
                  color: Colors.black45,
                ),

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 5.53*SizeConfig.heightMultiplier,vertical: 2*SizeConfig.heightMultiplier),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(


                      elevation: 5.0,
                      onPressed: () async{


                      },
                      padding: EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier,vertical: 1.8*SizeConfig.heightMultiplier),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),

                      ),
                      color:Color.fromARGB(
                          255, 0, 173, 207),
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize:4.37 * SizeConfig.imageSizeMultiplier,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                ),



                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 3.64*SizeConfig.imageSizeMultiplier),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Blogs for you",
                          style: TextStyle(
                              fontSize: 2.92*SizeConfig.heightMultiplier,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),

                    Visibility(
                      visible: canShowMoreBlogs,
                      child: FlatButton(onPressed: () async{

                        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BlogsList()));


                      },

                          child: Text("See all",
                            style: TextStyle(color: Colors.teal),)),
                    )
                  ],
                ),
                SizedBox(height: 2.19*SizeConfig.heightMultiplier,),

                Container(
                  height: 43.92*SizeConfig.heightMultiplier,
                  child: ListView.builder(
                      itemCount: noBlogsShown,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        String finalDaysAgo;

                        int daysAgo;
                        DateTime postDate;
                        Timestamp time;


                        if(blogList.length<5){

                          canShowMoreBlogs = false;
                          noBlogsShown = blogList.length;
                        }else{
                          canShowMoreBlogs = true;
                          noBlogsShown = 4;
                        }


                        time = blogList[index]['BlogPostDate'];

                        postDate = DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch);


                        daysAgo = DateTime.now().difference(postDate).inDays;
                        if(daysAgo < 32){
                          finalDaysAgo = daysAgo.toString() + " days ago";

                        }else if(daysAgo>=32 && daysAgo<365){

                          finalDaysAgo = (daysAgo~/30).toString() + " months ago";

                        }else {
                          finalDaysAgo = (daysAgo~/365).toString() + " years ago";
                        }



                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 0),
                          child: InkWell(
                            onTap: () async{




                              setState(() {
                                loading = true;
                              });


                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => BlogsDetails(blogId: blogList[index].id,)));




                              setState(() {
                                loading = false;
                              });



                            },
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation:3,
                              child: Column(
                                children: [
                                  FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/shop_banner.jpg',
                                    image: blogList[index]['BlogImage'],

                                    width: 46.79*SizeConfig.imageSizeMultiplier,
                                    height: 24.89*SizeConfig.heightMultiplier,
                                    fit: BoxFit.fill,

                                  ),
                                  Container(
                                      height: 13.17*SizeConfig.heightMultiplier,
                                      width: 46.79*SizeConfig.imageSizeMultiplier,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(blogList[index]['BlogTitle'],
                                          style: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,),
                                      )),

                                  Text(
                                    finalDaysAgo,
                                    style: TextStyle(
                                        color: Colors.black45
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );

                      }),
                ),
                SizedBox(height: 50,),


                InkWell(
                  onTap: () async{
                    setState(() {
                      loading = true;
                    });

                    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidgetShop(uid : uid)));

                    setState(() {
                      loading = false;
                    });

                  },
                  child: Container(
                    height: 230,

                    child: Image.asset('assets/images/shop_banner.jpg',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,),
                  ),
                ),







                FlatButton(onPressed: () async{

                  User user = await FirebaseAuth.instance.currentUser;
                  if(user.providerData[0].providerId == 'google.com'){
                    print("its google");
                    await gooleSignIn.disconnect();
                  }
                  if(user.providerData[0].providerId == 'facebook.com'){
                    print("its facebook");








                    FacebookLogin().logOut();

                  }
                  await auth.signOut();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      HomePage()), (Route<dynamic> route) => false);
                }, child: Text("Logout")),



                FlatButton(onPressed: () async{
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ForumHome(uid : uid)));

                }, child: Text("Forum")),

                FlatButton(onPressed: () async{

                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MapScreen(uid: uid,)));

                  print(value1);
                }, child: Text("maps")),


              ],
            ),
          )




      ),
    );
  }
}




class MainWidget extends StatefulWidget {
  MainWidget({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;

  @override
  _MainWidgetState createState() => _MainWidgetState(uid);
}

class _MainWidgetState extends State<MainWidget> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;
  final String uid;

  _MainWidgetState(this.uid);

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: DashboardPage(
        title: 'main',
        uid: uid,
      ),
      items: [
        DrawerItem(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(FontAwesomeIcons.home, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier,),
          page: DashboardPage(
            title: 'Home',
          ),
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
          page: DashboardPage(
            title: 'Shop',
          ),
        ),
        DrawerItem(
          onPressed: () async{
           await Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) =>  MainWidgetBlogs(uid : uid)));

          },
          text: Text(
            'Blogs',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(FontAwesomeIcons.newspaper, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: DashboardPage(
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
          page: DashboardPage(
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
          page: DashboardPage(
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
