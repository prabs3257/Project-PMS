import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/home_page.dart';
import 'package:project_pms/my_orders_page.dart';
import 'package:project_pms/save_config.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:project_pms/shared/loading.dart';
class ProfilePage extends StatefulWidget {

  final String uid;

  const ProfilePage({Key key, this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState(uid);
}

class _ProfilePageState extends State<ProfilePage> {
  final String uid;
  File image;
  String imgUrl;
  String imgFinal;
  DocumentSnapshot ds;


  Future<void> showInformationDialog(BuildContext context) async{

    String name;
    String number;



    return await showDialog(context: context,

        builder: (context) {


          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Dialog(


                  backgroundColor: Colors.lightBlue,
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

                                    //

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
                                          hintText: "Enter Name",
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
                                          "Mobile Number",
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
                                          hintText: "Enter Mobile Number",
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
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                    child: Container(


                                      child: RaisedButton(
                                        elevation: 5.0,
                                        onPressed: () async{

                                          if(name != "" || number != ""){
                                           await  FirebaseFirestore.instance.collection("userdata").doc(uid).update(
                                              {
                                                "Name" : name,
                                                "Number" : number

                                              }
                                            );
                                          }
                                          Navigator.of(context, rootNavigator: true).pop();

                                        },
                                        padding: EdgeInsets.symmetric(vertical: 15,horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                        ),
                                        color: Color.fromARGB(255, 245, 167, 29),
                                        child: Text(
                                          'SAVE',
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
                  child: Text("Update Profile",
                    style: TextStyle(decoration: TextDecoration.none, fontSize: 20,color: Colors.white),),
                ),
              ),


            ],
          );




        });
  }


  void initState() {
    // TODO: implement initState
    super.initState();

    getImage();


  }

  getImage() async{
    ds = await FirebaseFirestore.instance.collection("userdata").doc(uid).get();
    setState(() {
      imgFinal = ds['ProfilePic'];
    });

    setState(() {
      loading = false;
    });
  }

  _ProfilePageState(this.uid);
  @override
  Widget build(BuildContext context) {
    return loading ? Loading():Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.78*SizeConfig.heightMultiplier,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/stree_sanman_logo.png',width: 29.19*SizeConfig.imageSizeMultiplier,),


          ],
        ),
        backgroundColor: Colors.white,

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(

              color: Color.fromARGB(255, 0, 173, 207),
              height: 43.92*SizeConfig.heightMultiplier,
              child: Column(
                children: [
                  SizedBox(height: 1.46*SizeConfig.heightMultiplier,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_sharp),color: Colors.white),
                      Text("Profile",style: TextStyle(fontSize: 3.22*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Colors.white),),
                      IconButton(onPressed: (){showInformationDialog(context);}, icon: Icon(Icons.edit),color: Colors.white)
                    ],

                  ),

                  const Divider(
                    height: 20,
                    thickness: 0.5,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.white,
                  ),

                  SizedBox(height: 4.39*SizeConfig.heightMultiplier,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      ClipOval(


                        child: InkWell(
                          onTap: () async{

                            PickedFile img = await ImagePicker().getImage(source: ImageSource.gallery);


                            if(img != null){
                              setState(() {
                                loading = true;
                              });

                              var file = File(img.path);

                              var snapshot = await FirebaseStorage.instance.ref()
                                  .child('users/ProfilePics/$uid')
                                  .putFile(file);
                              var imgUrl = await snapshot.ref.getDownloadURL();


                              await FirebaseFirestore.instance.collection("userdata").doc(uid).update({

                                'ProfilePic' : imgUrl
                              });

                              await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : uid)));
                              setState(() {
                                loading = false;
                              });
                            }



                          },
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/shop_banner.jpg',
                            image:imgFinal,


                            width: 36.49*SizeConfig.imageSizeMultiplier,
                            height: 36.49*SizeConfig.imageSizeMultiplier,
                            fit: BoxFit.fill,

                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Text(ds['Name'],style: TextStyle(color: Colors.white,fontSize: 3.22*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Text('google@google.com',style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Text('+91 9819899918',style: TextStyle(color: Colors.white),),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            child: Text('Happiness Index',style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      )
                    ],
                  )

                ],

              ),
            ),

            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: InkWell(
                onTap: () async{

                  setState(() {
                    loading = true;
                  });
                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MyOrdersPage(uid : uid)));

                  setState(() {
                    loading = false;
                  });
                },
                child: Row(
                  children: [

                    Icon(Icons.shopping_bag_outlined,size: 25,color: Colors.black38,),
                    SizedBox(width: 10,),
                    Text("Orders", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(Icons.how_to_reg_outlined,size: 25,color: Colors.black38,),
                  SizedBox(width: 10,),
                  Text("Affiliates", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(Icons.headset_mic_outlined,size: 25,color: Colors.black38,),
                  SizedBox(width: 10,),
                  Text("Support", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(Icons.settings,size: 25,color: Colors.black38,),
                  SizedBox(width: 10,),
                  Text("Settings", style: TextStyle(fontSize:(SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(FontAwesomeIcons.balanceScale,size: 20,color: Colors.black38,),
                  SizedBox(width: 15,),
                  Text("Legal", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(Icons.share,size: 25,color: Colors.black38,),
                  SizedBox(width: 10,),
                  Text("Share with friends", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(Icons.star_outline_rounded,size: 25,color: Colors.black38,),
                  SizedBox(width: 10,),
                  Text("Rate us", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 2.92*SizeConfig.heightMultiplier,horizontal: 7.29*SizeConfig.imageSizeMultiplier),
              child: Row(
                children: [

                  Icon(Icons.logout,size: 25,color: Colors.black38,),
                  SizedBox(width: 10,),
                  Text("Logout", style: TextStyle(fontSize: (SizeConfig.heightMultiplier>=10) ? 1.92*SizeConfig.heightMultiplier : 2.92*SizeConfig.heightMultiplier,color: Colors.black38,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 2,
              indent: 25,
              endIndent: 25,

            ),

          ],
        ),
      ),
    );
  }
}
