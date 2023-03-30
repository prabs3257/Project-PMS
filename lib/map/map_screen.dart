import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:project_pms/Blogs/blogs_list.dart';
import 'package:project_pms/Forum/forum_home.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/hidden_drawer/drawer.dart';
import 'package:project_pms/home_page.dart';
import 'package:project_pms/map/select_location.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
import 'package:project_pms/shop/shop_home.dart';

import 'box_utils.dart';
import 'package:custom_info_window/custom_info_window.dart';




class PinInfo{

  String locationData;
  String Name;
  String Image;
  String Address;
  String Number;
  int NumOfReviews;
  String DocName;


  PinInfo(String locationData, String Name, String Image,String Address,String Number,int NumOfReviews,String DocName){
    this.locationData = locationData;
    this.Name = Name;
    this.Image = Image;
    this.Address = Address;
    this.Number = Number;
    this.NumOfReviews = NumOfReviews;
    this.DocName = DocName;
  }

}

PinInfo SelectedPin;



String selectedDocName;

String review;
var _controller = TextEditingController();

class Place{

  String desc;
  String placeId;

  Place(String desc,String placeId){
    this.desc = desc;
    this.placeId = placeId;
  }
}







class MapScreen extends DrawerContent {

  final String uid;

   MapScreen({Key key, this.uid, String title});
  @override
  _MapScreenState createState() => _MapScreenState(uid);
}



class _MapScreenState extends State<MapScreen>{

  final String uid;

  Set<Marker> _markers = {};
  Marker marker;
  Uint8List markerIcon;

  List<Place> places = [];

  String searchQuery;

  bool showSearch = false;

  String reviewRating = (1.0).toString();
  String reviewTitle;
  String reviewDesc;
  String reviewImg;
  DocumentSnapshot dsSelected;

  bool allowToSubmit = true;

  int numReviewsShown = 2;

  bool canShowMoreReviews = true;
  bool noReviews = false;

  Completer<GoogleMapController> mapController = Completer();
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();

  _MapScreenState(this.uid);

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



    Timer _timer = Timer(Duration(seconds: 1), ()  {
      setState(() {
        loading = false;
      });
    });






  }







  Future<void> showInformationDialog(BuildContext context) async{



    return showDialog(context: context,

        builder: (context) {


          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Dialog(


                  backgroundColor:Color.fromARGB(255, 0, 173, 207),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
                      color: Colors.white,
                      height: 1000,
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [


                                Column(
                                  children: [
                                    SizedBox(height: 15,),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                        child: Text(
                                          "Rate This Product",
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            color: Color(0xff8f9db5),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 15),
                                          child: RatingBar.builder(
                                            initialRating: 1,
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (rating) {
                                              reviewRating = rating.toString();
                                            },
                                          )
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
                                          "Title",
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

                                          reviewTitle = value;
                                        },
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: "Enter Title",
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

                                        ),
                                      ),
                                    ),
                                    //
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                        child: Text(
                                          "Review This Product",
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
                                        maxLines: 7,
                                        obscureText: false,
                                        // this can be changed based on usage -
                                        // such as - onChanged or onFieldSubmitted
                                        onChanged: (value) {

                                          reviewDesc = value;
                                        },
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: "Description",
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

                                        ),
                                      ),
                                    ),
                                    //
                                  ],
                                ),
                                SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(


                                      child: RaisedButton(
                                        elevation: 5.0,
                                        onPressed: () async{






                                          PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);

                                          if(img != null){

                                            allowToSubmit = false;

                                            var file = File(img.path);

                                            var snapshot = await FirebaseStorage.instance.ref()
                                                .child('users/$uid')
                                                .putFile(file);

                                            var imgUrl = await snapshot.ref.getDownloadURL();
                                            reviewImg = imgUrl;

                                            allowToSubmit = true;

                                          }








                                        },
                                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        color: Color.fromARGB(255, 245, 167, 29),
                                        child: Text(
                                          'ADD PHOTO',
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize:3.87 * SizeConfig.imageSizeMultiplier,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(


                                      child: RaisedButton(
                                        elevation: 5.0,
                                        onPressed: () async{


                                          //print("hello"+ ds['Reviews'].length.toString());


                                          if(allowToSubmit){


                                            DocumentSnapshot dsUser = await FirebaseFirestore.instance.collection('userdata').doc(uid).get();

                                            Map review = {'ReviewTitle' : reviewTitle,'ReviewRating' : reviewRating,
                                              'ReviewDesc' : reviewDesc,'ReviewerId' : uid,'ReviewingTime' : DateTime.now().toString(),
                                              'ReviewerName' : dsUser['Name'],'ReviewImage' : reviewImg};


                                            dsSelected['Reviews'].forEach((elements) {

                                              if(elements['ReviewerId'] == uid){


                                                FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).update({

                                                  'Reviews' : FieldValue.arrayRemove([elements]),
                                                  'TotalRating' : (double.parse(dsSelected['TotalRating']) - double.parse(elements['ReviewRating'])).toString()



                                                });
                                                FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).update({


                                                  'Reviews' : FieldValue.arrayUnion([review]),

                                                });

                                              }else{




                                              }


                                            });



                                            await FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).update({

                                              'Reviews' : FieldValue.arrayUnion([review] ),


                                            });
                                            dsSelected = await FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).get();

                                            print("reviewsss " + [dsSelected['Reviews']].length.toString());
                                            await FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).update({


                                              'NumberOfRatings' : dsSelected['Reviews'].length.toString(),
                                              'TotalRating' : (double.parse(dsSelected['TotalRating'].toString()) + double.parse(reviewRating)).toString()


                                            });
                                            dsSelected = await FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).get();

                                            print("total rating " + double.parse(dsSelected['TotalRating']).toString());
                                            print("rating is " +(double.parse(dsSelected['TotalRating'])/double.parse([dsSelected['Reviews']].length.toString())).toString());
                                            await FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).update({


                                              'Rating' : (double.parse(dsSelected['TotalRating'])/double.parse(dsSelected['Reviews'].length.toString())).toString()


                                            });
                                            print("total rating final " + (dsSelected['TotalRating']));

                                            await FirebaseFirestore.instance.collection('Markers').doc(selectedDocName).update({


                                              'Images' : FieldValue.arrayUnion([reviewImg]),


                                            });






                                            Navigator.of(context, rootNavigator: true).pop();



                                          }else{

                                            print("too soon");
                                            Fluttertoast.showToast(
                                              msg: "Please wait ...",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,

                                            );

                                          }


                                        },
                                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 25),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        color: Color.fromARGB(
                                            255, 0, 173, 207),
                                        child: Text(
                                          'SUBMIT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize:3.87 * SizeConfig.imageSizeMultiplier,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),











                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 75),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("Rate & Review",
                    style: TextStyle(decoration: TextDecoration.none, fontSize: 20,color: Colors.white),),
                ),
              ),


            ],
          );




        });
  }





  Widget buildBottomSheet(BuildContext context){




    return Container(

      color: Color(0xff757575),
      child: Container(
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0)
              )
          ),
          child: DraggableScrollableSheet(
            expand: false,


            builder: (BuildContext context, ScrollController scrollController) {

              return Container(
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)
                      )
                  ),

                  child:Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: ListView(
                      padding: const EdgeInsets.all(8),
                      controller: scrollController,
                      children: [
                        Column(



                          children: [
                            Container(

                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,

                                children: [


                                  Container(

                                    width: 340,
                                    height: 150,
                                    child: ListView.builder(
                                        itemCount: dsSelected['Images'].length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index){

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(7.0),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/shop_banner.jpg',
                                                image: dsSelected['Images'][index],




                                              ),
                                            ),
                                          );
                                        }),
                                  ),


                                  SizedBox(height: 20,),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: RatingBar.builder(
                                      ignoreGestures: true,
                                      itemSize: 20,
                                      initialRating: 3.0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),

                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Address :",
                                      style: TextStyle(fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromARGB(
                                              255, 0, 173, 207)
                                      ),


                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: 340,
                                    child: Text(dsSelected['Address'],
                                      style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),


                                    ),
                                  ),



                                  SizedBox(height : 20),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Contact Number :",
                                      style: TextStyle(fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromARGB(
                                              255, 0, 173, 207)
                                      ),


                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: 340,
                                    child: Text(dsSelected['Contact'],
                                      style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),


                                    ),


                                  ),

                                  SizedBox(height : 20),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Price :",
                                      style: TextStyle(fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromARGB(
                                              255, 0, 173, 207)
                                      ),


                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: 340,
                                    child: Text(dsSelected['Price'],
                                      style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),


                                    ),


                                  ),



                                  SizedBox(height : 20),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Video Link :",
                                      style: TextStyle(fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Color.fromARGB(
                                              255, 0, 173, 207)
                                      ),


                                    ),
                                  ),
                                  SizedBox(height: 5,),
                                  Container(
                                    width: 340,
                                    child: Text(dsSelected['Video'],
                                      style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),


                                    ),


                                  ),

                                  SizedBox(height : 20),


                                  SizedBox(height : 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Reviews:",
                                          style: TextStyle(fontSize: 22,
                                              fontWeight: FontWeight.w900,
                                              color: Color.fromARGB(
                                                  255, 0, 173, 207)
                                          ),


                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          showInformationDialog(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 15),
                                          child: Text("Write a Review",
                                            style: TextStyle(fontSize: 17,fontWeight: FontWeight.w800,color: Color.fromARGB(255, 245, 167, 29)),),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height : 15),
                                  Visibility(
                                      visible: noReviews,
                                      child: Text("No Reviews")),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(

                                        child: ListView.builder(

                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),


                                            itemCount: dsSelected['Reviews'].length,
                                            itemBuilder: (context,index){


                                              if(dsSelected['Reviews'].length == 0){
                                                noReviews = true;
                                              }

                                              if(dsSelected['Reviews'].length <= 2){
                                                numReviewsShown = dsSelected['Reviews'].length;
                                                canShowMoreReviews = false;

                                              }

                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                                                        child: Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Text(
                                                            dsSelected['Reviews'][index]['ReviewTitle'],
                                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                                                                color: Colors.teal),

                                                          ),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding: const EdgeInsets.only(right: 20),
                                                        child: RatingBar.builder(
                                                          ignoreGestures: false,
                                                          itemSize: 15,
                                                          initialRating: double.parse(dsSelected['Reviews'][index]['ReviewRating']),
                                                          minRating: 1,
                                                          direction: Axis.horizontal,
                                                          allowHalfRating: true,
                                                          itemCount: 5,
                                                          itemPadding: EdgeInsets.symmetric(horizontal: 0.0),
                                                          itemBuilder: (context, _) => Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),

                                                        ),
                                                      ),

                                                    ],
                                                  ),

                                                  SizedBox(height: 0,),

                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                                    child: Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        "\" ${dsSelected['Reviews'][index]['ReviewDesc']} \"",
                                                        style: TextStyle(fontSize: 16),

                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10,),

                                                  Padding(
                                                    padding: const EdgeInsets.only(right: 15),
                                                    child: Align(
                                                      alignment: Alignment.centerRight,
                                                      child: Text(
                                                          "By- ${dsSelected['Reviews'][index]['ReviewerName']}\non ${dsSelected['Reviews'][index]['ReviewingTime'].toString().substring(0,16)}"
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
                                                  SizedBox(height: 10,),

                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),

                                  Visibility(
                                    visible: false,
                                    child: FlatButton(onPressed: (){

                                      if((numReviewsShown+2) >= dsSelected['Reviews'].length){
                                        setState(() {
                                          numReviewsShown = dsSelected['Reviews'].length;
                                          canShowMoreReviews = false;
                                        });

                                      }else{
                                        setState(() {
                                          numReviewsShown += 2;
                                        });
                                      }



                                    }, child: Text("click")),
                                  )









                                ],

                              ),
                            ),


                          ],
                        )
                      ],
                    ),
                  )
              );
            },
          )
      ),
    );
  }


  Future<List<Place>> getPlaces(String value) async{


    places.clear();
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${value.toString()}&language=en&key=AIzaSyB5J_0EDhmMyiiK8N66WCujVsWXIXx4tik');
    var response = await http.get(url);

    var jsonData = json.decode(response.body);

    for(var u in jsonData["predictions"]){

      Place place = Place(u["description"],u["place_id"]);
      setState(() {
        places.add(place);
      });
      //print(place.desc);


    }




  }



  int id = 0;
  final key = 'AIzaSyB5J_0EDhmMyiiK8N66WCujVsWXIXx4tik';



  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }

  void setMapMarker() async{

    markerIcon = await getBytesFromAsset('assets/images/hospital.png', 100);

  }

  void _onMapCreated(GoogleMapController controller) async{


    mapController.complete(controller);
    _customInfoWindowController.googleMapController = controller;

    print("mapdone");
    DocumentSnapshot dsInfo = await FirebaseFirestore.instance.collection('Markers').doc('Info').get();

   // setState(() {
   //   _markers.add(Marker(
   //     markerId: MarkerId(id.toString()),
   //     position: LatLng(28.576398, 77.045490),
   //
   //     onTap: (){
   //       _customInfoWindowController.addInfoWindow(
   //         Column(
   //           children: [
   //             Expanded(
   //               child: Container(
   //                 decoration: BoxDecoration(
   //                   color: Colors.white,
   //                   borderRadius: BorderRadius.circular(10),
   //                 ),
   //                 child: Padding(
   //                   padding: const EdgeInsets.all(8.0),
   //                   child: Column(
   //
   //                     children: [
   //
   //                       SizedBox(
   //                         width: 8.0,
   //                       ),
   //                       Text(
   //                         "I am here",
   //                         style:
   //                         Theme.of(context).textTheme.headline6.copyWith(
   //                           color: Colors.black,
   //                         ),
   //                       )
   //                     ],
   //                   ),
   //                 ),
   //                 width: double.infinity,
   //                 height: double.infinity,
   //               ),
   //             ),
   //
   //           ],
   //         ),
   //           LatLng(28.576398, 77.045490)
   //       );
   //     },
   //   ));
   // });



    for(int i = 0; i < dsInfo["Count"]; i++){

      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Markers').doc('Marker_${i+1}').get();

      setState(() {

        _markers.add(Marker(
          markerId: MarkerId(id.toString()),
          position: LatLng(double.parse(ds['Lat']), double.parse(ds['Lng'])),

          onTap: (){
            _customInfoWindowController.addInfoWindow(
                Column(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          dsSelected = ds;
                          selectedDocName = "Marker_${i+1}";
                          showModalBottomSheet(context: context,isScrollControlled: true, builder: buildBottomSheet);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Container(
                                    width: 230,
                                    height: 40,
                                    child: ListView.builder(
                                        itemCount: ds['Images'].length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context,index){

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 5),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(7.0),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: 'assets/images/shop_banner.jpg',
                                                image: ds['Images'][index],

                                                width:70,
                                                height: 40,


                                              ),
                                            ),
                                          );
                                    }),
                                  ),

                                  SizedBox(height: 8,),
                                  Text("Price : ${ds['Price']}",style: TextStyle(fontSize: 12,color: Colors.black45),),
                                  SizedBox(height: 5,),
                                  Text("Address : ${ds['Address']}",style: TextStyle(fontSize: 12,color: Colors.black45)),

                                  SizedBox(height: 5,),
                                  Text("Video Link : ",style: TextStyle(fontSize: 12,color: Colors.black45)),

                                  Text(ds['Video'],style: TextStyle(fontSize: 12,color: Colors.black45))
                                ],
                              ),
                            ),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),

                  ],
                ),
                LatLng(double.parse(ds['Lat']), double.parse(ds['Lng']))
            );
          },
        ));
        id++;

      });
    }




  }

  void _currentLocation() async {
    final GoogleMapController controller = await mapController.future;
    LocationData currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 17.0,
      ),
    ));
  }




  @override
  Widget build(BuildContext context) {



    return  loading ? Loading() : Scaffold(

                appBar:AppBar(
                  toolbarHeight: 8.78*SizeConfig.heightMultiplier,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(onPressed: widget.onMenuPressed, icon: Icon(Icons.menu,color: Colors.black,)),
                      Image.asset('assets/images/stree_sanman_logo.png',width: 29.19*SizeConfig.imageSizeMultiplier,),

                    ],
                  ),
                  backgroundColor: Colors.white,

                ),



                body:Stack(
                  children: [



                    GoogleMap(
                      initialCameraPosition: CameraPosition(target: LatLng(28.5723921,77.0449214),
                          zoom: 15),
                      myLocationEnabled: true,
                      onMapCreated: _onMapCreated,
                      myLocationButtonEnabled: false,
                      markers: _markers,
                      onCameraMove: (position) {
                        _customInfoWindowController.onCameraMove();
                      },
                      onTap: (position) {
                        _customInfoWindowController.hideInfoWindow();
                      },

                      zoomControlsEnabled: false,

                    ),
                    CustomInfoWindow(
                      controller: _customInfoWindowController,
                      height: 160,
                      width: 250,
                      offset: 50,
                    ),


                    Column(

                      children: [

                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                SizedBox(height: 10.0),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  decoration: (showSearch) ? kSearchDecorationStyle : kBoxDecorationStyle,

                                  child: TextField(


                                    onChanged: (value) async{
                                      setState(() {
                                        searchQuery = value;
                                      });

                                      if(value == ""){

                                        setState(() {
                                          showSearch = false;
                                        });
                                      }else{
                                        setState(() {
                                          showSearch = true;
                                        });
                                      }

                                      await getPlaces(value);

                                      // setState(() {
                                      //
                                      // });
                                      //
                                      // await getPlaces(value);
                                      //
                                      //
                                      // print(places.length);

                                    },



                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'OpenSans',
                                    ),
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 18,vertical: 20),
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Search',
                                      hintStyle: kHintTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),

                        SizedBox(height: 0,),

                        Visibility(
                          visible: showSearch,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              height: 130,

                              decoration: kSearchDropDownDecorationStyle,
                              child: ListView.builder(

                                  itemCount: places.length,
                                  itemBuilder: (context,index){

                                    return ListTile(
                                      title: Text(places[index].desc),
                                      onTap: () async{


                                        var url = Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=${places[index].placeId}&fields=geometry&key=AIzaSyB5J_0EDhmMyiiK8N66WCujVsWXIXx4tik');
                                        var response = await http.get(url);

                                        var jsonData = json.decode(response.body);



                                        final GoogleMapController controller = await mapController.future;
                                        controller.animateCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(target: LatLng(jsonData["result"]["geometry"]["location"]["lat"], jsonData["result"]["geometry"]["location"]["lng"]),zoom: 16)

                                            )
                                        );


                                        setState(() {
                                          showSearch = false;
                                          searchQuery = "";
                                          places.clear();
                                          _controller.clear();

                                        });
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),









                  ],

                ),


                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child:

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Transform.scale(
                            scale: 0.8,
                            child: FloatingActionButton(
                              onPressed: _currentLocation,

                              backgroundColor: Color.fromARGB(
                                  255, 0, 173, 207),
                              child: Icon(Icons.location_searching,),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: FloatingActionButton.extended(

                                onPressed: () async{
                                  // Add your onPressed code here!

                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SelectLocation(type: "Vending Machine",uid: uid,)));


                                },

                                label: const Text('Add Vending\nMachine',textAlign: TextAlign.center,style:TextStyle(
                                  fontSize: 12
                                ),),
                                backgroundColor: Color.fromARGB(255, 167, 205, 57)

                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                              child: FloatingActionButton.extended(
                                onPressed: () async{
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SelectLocation(type: "Incinerator",uid: uid,)));

                                },

                                label: const Text('Add \nIncinerator',textAlign: TextAlign.center,style:TextStyle(
                                    fontSize: 12
                                ),),
                                backgroundColor: Color.fromARGB(
                                    255, 0, 173, 207),

                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                              child: FloatingActionButton.extended(
                                onPressed: () async{
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => SelectLocation(type: "Store",uid: uid,)));

                                },

                                label: const Text('Add \nStore',textAlign: TextAlign.center,style:TextStyle(
                                    fontSize: 12
                                ),),
                                backgroundColor: Color.fromARGB(255, 245, 167, 29),

                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),



              );



  }
}


class MainWidgetMap extends StatefulWidget {
  MainWidgetMap({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;

  @override
  _MainWidgetMapState createState() => _MainWidgetMapState(uid);
}

class _MainWidgetMapState extends State<MainWidgetMap> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;
  final String uid;

  _MainWidgetMapState(this.uid);

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: MapScreen(
        title: "shop",
        uid: uid,
      ),

      items: [
        DrawerItem(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(FontAwesomeIcons.home, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier,),
          page: MapScreen(
              title: 'Home',
              uid:uid
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
          page: MapScreen(
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
          page: MapScreen(
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
          page: MapScreen(
            title: 'Forum',
          ),
        ),
        DrawerItem(
          text: Text(
            'Maps',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(FontAwesomeIcons.map, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: ShopHome(
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

