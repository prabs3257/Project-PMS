import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_pms/map/thank_you_map_request.dart';
import 'package:project_pms/save_config.dart';

class AddDetails extends StatefulWidget {

  final String uid;
  final String type;
  final LatLng location;

  const AddDetails({Key key, this.uid, this.type, this.location}) : super(key: key);
  @override
  _AddDetailsState createState() => _AddDetailsState(uid,type,location);
}

class _AddDetailsState extends State<AddDetails> {
  final String uid;
  final String type;
  final LatLng location;
  bool allowToSubmit = true;
  String reqImg;

  String name;
  String email;
  String orgName;
  String number;
  String address;

  final GlobalKey<FormState> reqFormKey = GlobalKey<FormState>();

  _AddDetailsState(this.uid, this.type, this.location);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.78*SizeConfig.heightMultiplier,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp,color: Colors.black,)),
            SizedBox(width: 10,),
            Image.asset('assets/images/stree_sanman_logo.png',width: 29.19*SizeConfig.imageSizeMultiplier,),

          ],
        ),
        backgroundColor: Colors.white,

      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowGlow();
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    color: Color.fromARGB(255, 0, 173, 207),
                    width: double.infinity,
                    height: 8.78 * SizeConfig.heightMultiplier,
                    child: Center(
                      child: Text(
                        "Add Details",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                            fontSize: 3.22*SizeConfig.textMultiplier),

                      ),
                    ),
                  ),


                ],
              ),

              SizedBox(height: 10,),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Form(
                    key: reqFormKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                          child: TextFormField(
                            validator: (String value){
                              if(value.isEmpty){
                                return "Please enter a valid Name";
                              }
                              return null;
                            },
                            onChanged: (value){

                              name = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(


                              contentPadding: EdgeInsets.only(bottom: 3),
                              hintText: 'Name',
                              hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                          child: TextFormField(
                            validator: (String value){
                              if(value.isEmpty || !RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                                return "Please enter a valid Email";
                              }
                              return null;
                            },
                            onChanged: (value){

                              email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(


                              contentPadding: EdgeInsets.only(bottom: 3),
                              hintText: 'Email',
                              hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                          child: TextFormField(
                            validator: (String value){
                              if(value.isEmpty){
                                return "Please enter a valid Organisation Name";
                              }
                              return null;
                            },
                            onChanged: (value){

                              orgName = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.center,
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(


                              contentPadding: EdgeInsets.only(bottom: 3),
                              hintText: 'Organisation Name',
                              hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                          child: TextFormField(
                            validator: (String value){
                              if(value.isNotEmpty){

                                if(value.length != 10){
                                  return "Please enter a valid Contact Number";
                                }
                              }

                              return null;
                            },
                            onChanged: (value){

                              number = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'OpenSans',
                            ),
                            decoration: InputDecoration(


                              contentPadding: EdgeInsets.only(bottom: 3),

                              suffixIcon: Padding(
                                padding: EdgeInsets.only(top: 5*SizeConfig.heightMultiplier),
                                child: Text("(optional)",
                                  style: TextStyle(fontSize: 12,color: Colors.black45),),
                              ),


                              hintText: 'Contact Number',
                              hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                          child: TextFormField(

                            onChanged: (value){

                              address = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textAlignVertical: TextAlignVertical.bottom,
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'OpenSans',
                            ),

                            decoration: InputDecoration(


                              contentPadding: EdgeInsets.only(bottom: 3),

                              suffixIcon: Padding(
                                padding: EdgeInsets.only(top: 5*SizeConfig.heightMultiplier),
                                child: Text("(optional)",
                                  style: TextStyle(fontSize: 12,color: Colors.black45),),
                              ),

                              hintText: 'Full Address',
                              hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 40,),

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
                                    reqImg = imgUrl;

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

                                  if(reqFormKey.currentState.validate()){

                                    if(allowToSubmit){

                                      await FirebaseFirestore.instance.collection('MapRequests').doc().set({

                                        'RequestingId' : uid,
                                        'Type' : type,
                                        'Latitude' : location.latitude.toString(),
                                        'Longitude' : location.longitude.toString(),
                                        'Image' : reqImg,
                                        'Name' : name,
                                        'Email' : email,
                                        'OrganisationName' : orgName,
                                        'ContactNumber' : number,
                                        'Address' : address


                                      });

                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (context) => ThankYouMapReqPage(uid: uid,)));


                                    }else{

                                      print("too soon");
                                      Fluttertoast.showToast(
                                        msg: "Please wait ...",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,

                                      );

                                    }
                                  }else{
                                    print("UnSuccessfull");
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
                        SizedBox(height: 30,),

                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
