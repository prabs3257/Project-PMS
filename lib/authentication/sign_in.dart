import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_pms/authentication/first_time_questions.dart';
import 'package:project_pms/authentication/register.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
import 'package:http/http.dart' as http;
import 'package:project_pms/home_page.dart';
import 'package:project_pms/main.dart';

import 'authentication.dart';
import '../constants.dart';
import 'package:project_pms/title.dart';


bool loading = false;

class SignIn extends StatefulWidget {


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String email;
  String password;

  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();






  bool _rememberMe = false;




  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Form(
      key: signInFormKey,
      child: Padding(
        padding:  EdgeInsets.fromLTRB(7.78*SizeConfig.imageSizeMultiplier,(SizeConfig.heightMultiplier>7)?11*SizeConfig.heightMultiplier:9.78*SizeConfig.imageSizeMultiplier,7.78*SizeConfig.imageSizeMultiplier,0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overScroll) {
            overScroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(

            child: Column(
              children: [
                 Align(
                   alignment: Alignment.center,
                   child: Column(
                     children: [
                       Image(image: AssetImage("assets/images/sslogo.png"),
                       width: 45.66 * SizeConfig.imageSizeMultiplier,),
                       SizedBox(height: 3.5* SizeConfig.heightMultiplier,),
                       Image(image: AssetImage("assets/images/welcomebanner.png"),
                         width: 55 * SizeConfig.imageSizeMultiplier,)
                     ],
                   )
                 ),
                Column(
                  children: [
                    SizedBox(height: 3.5* SizeConfig.heightMultiplier,),
                    Text("Sign in",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 3.51*SizeConfig.heightMultiplier,color: Colors.black54),),

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
                    SizedBox(height: 1.46 * SizeConfig.heightMultiplier,),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                      child: TextFormField(
                        validator: (String value){
                          if(value.isEmpty || value.length<6){
                            return "Please enter a valid Password";
                          }
                          return null;
                        },

                        onChanged: (value){
                          password = value;
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        style: TextStyle(
                          color: Colors.black45,
                          fontFamily: 'OpenSans',
                        ),
                        decoration: InputDecoration(


                          contentPadding: EdgeInsets.only(bottom: 3),
                          hintText: 'Password',
                          hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),


                    Container(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () => print('Forgot Password Button Pressed'),
                        padding: EdgeInsets.only(right: 2.92 * SizeConfig.heightMultiplier),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                      ),
                    ),







                   Row(

                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(

                         children: [
                           SizedBox(width: 36.49*SizeConfig.imageSizeMultiplier,),
                           Text(
                             '- OR -',
                             style: TextStyle(
                               color: Colors.black45,
                               fontWeight: FontWeight.w500,
                               fontSize: 2.92*SizeConfig.heightMultiplier
                             ),
                           ),
                         ],
                       ),
                       RawMaterialButton(
                         onPressed: () async{


                           if(signInFormKey.currentState.validate())
                           {
                             print("successful");
                             setState(() {
                               loading = true;

                             });


                             try {
                               UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                   email: email,
                                   password: password
                               );
                               User user = result.user;

                               try{

                                 DocumentSnapshot ds = await userData.doc(user.uid).get();

                                 print("testing1234");


                                 //showInformationDialog(context);

                                 if(ds['FormFilled'] == true){

                                   await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : user.uid)));
                                   setState(() {
                                     loading = false;

                                   });

                                   setState(() {

                                   });
                                 }else if(ds['FormFilled'] == false){
                                   print("ppppppppp");
                                   await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FirstTimeQues(uid : user.uid)));

                                   setState(() {
                                     loading = false;

                                   });
                                 }


                               }catch(e){
                                 print(e);
                               }

                             } on FirebaseAuthException catch (e) {
                               if (e.code == 'user-not-found') {
                                 print('No user found for that email.');

                                 setState(() {
                                   loading = false;
                                 });

                                 Fluttertoast.showToast(
                                   msg: "'No user found for that email.'",
                                   toastLength: Toast.LENGTH_SHORT,
                                   gravity: ToastGravity.BOTTOM,

                                 );


                               } else if (e.code == 'wrong-password') {
                                 print('Wrong password provided for that user.');
                                 setState(() {
                                   loading = false;
                                 });

                                 Fluttertoast.showToast(
                                   msg: "Wrong password provided for that user.",
                                   toastLength: Toast.LENGTH_SHORT,
                                   gravity: ToastGravity.BOTTOM,

                                 );

                               }
                             }








                           }else{
                             print("UnSuccessfull");
                           }








                         },
                         elevation: 0.0,
                         fillColor: Color.fromARGB(
                           255, 0, 173, 207),
                         splashColor: Palette.darkOrange,
                         padding:  EdgeInsets.all(2.82 * SizeConfig.heightMultiplier),
                         shape: const CircleBorder(),
                         child:  Icon(
                           FontAwesomeIcons.longArrowAltRight,
                           color: Colors.white,
                           size: 2.19 * SizeConfig.heightMultiplier,
                         ),
                       ),



                     ],
                   ),



                    SizedBox(height:  0.46 * SizeConfig.heightMultiplier),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Sign in with',
                          style: TextStyle(
                            fontSize: 2.34*SizeConfig.heightMultiplier,
                            color: Colors.black45,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans',
                          ),
                        ),
                        SizedBox(width: 4.49*SizeConfig.imageSizeMultiplier,),

                        GestureDetector(
                          onTap: () async{

                            setState(() {
                              loading = true;

                            });


                            GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

                            if(googleSignInAccount != null){

                              GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
                              AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,
                                  accessToken: googleSignInAuthentication.accessToken);

                              UserCredential result = await auth.signInWithCredential(credential);

                              User user = await auth.currentUser;


                              DocumentSnapshot ds1 = await FirebaseFirestore.instance.collection('userdata').doc(user.uid).get();

                              if(ds1.exists){
                                print("it exists");
                              }else{
                                print("its does not exists");

                                await FirebaseFirestore.instance.collection('userdata').doc(user.uid).set(
                                    {
                                      'FormFilled' : false
                                    }
                                );
                              }






                              try{

                                DocumentSnapshot ds = await userData.doc(user.uid).get();

                                print("testing1234");


                                //showInformationDialog(context);

                                if(ds['FormFilled'] == true){

                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : user.uid)));
                                  setState(() {
                                    loading = false;

                                  });

                                  setState(() {

                                  });
                                }else if(ds['FormFilled'] == false){
                                  print("ppppppppp");
                                  await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FirstTimeQues(uid : user.uid)));

                                  setState(() {
                                    loading = false;

                                  });
                                }


                              }catch(e){
                                print(e);
                              }







                              //await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : user.uid)));






                              setState(() {
                                loading = false;

                              });

                            }



                          },

                          child: Container(
                            height: 7.73 * SizeConfig.imageSizeMultiplier,
                            width: 7.73 * SizeConfig.imageSizeMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage("assets/images/google.jpg"),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 4.49*SizeConfig.imageSizeMultiplier,),
                        GestureDetector(
                          onTap: () async{
                            setState(() {
                              loading = true;

                            });

                            final FacebookLogin facebookSignIn = new FacebookLogin();

                            final FacebookLoginResult result =
                            await facebookSignIn.logIn(['email']);

                            switch (result.status) {
                              case FacebookLoginStatus.loggedIn:
                                accessToken = result.accessToken;






                                final graphResponse = await http.get(
                                    Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,first_name,picture&access_token=${accessToken.token}'));
                                final profile = jsonDecode(graphResponse.body);

                                print(profile['first_name']);
                                break;
                              case FacebookLoginStatus.cancelledByUser:
                                print('Login cancelled by the user.');
                                break;
                              case FacebookLoginStatus.error:
                                print('Something went wrong with the login process.\n'
                                    'Here\'s the error Facebook gave us: ${result.errorMessage}');
                                break;
                            }

                            AuthCredential credentials = FacebookAuthProvider.credential(accessToken.token);
                            UserCredential resultFacebook = await auth.signInWithCredential(credentials);
                            User user = await auth.currentUser;
                            DocumentSnapshot ds1 = await FirebaseFirestore.instance.collection('userdata').doc(user.uid).get();

                            if(ds1.exists){
                              print("it exists");
                            }else{
                              print("its does not exists");

                              await FirebaseFirestore.instance.collection('userdata').doc(user.uid).set(
                                  {
                                    'FormFilled' : false
                                  }
                              );
                            }






                            try{

                              DocumentSnapshot ds = await userData.doc(user.uid).get();

                              print("testing1234");


                              //showInformationDialog(context);

                              if(ds['FormFilled'] == true){

                                await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : user.uid)));
                                setState(() {
                                  loading = false;

                                });

                                setState(() {

                                });
                              }else if(ds['FormFilled'] == false){
                                print("ppppppppp");
                                await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FirstTimeQues(uid : user.uid)));

                                setState(() {
                                  loading = false;

                                });
                              }


                            }catch(e){
                              print(e);
                            }



                            setState(() {
                              loading = false;

                            });
                          },

                          child: Container(
                            height: 7.73 * SizeConfig.imageSizeMultiplier,
                            width: 7.73 * SizeConfig.imageSizeMultiplier,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 6.0,
                                ),
                              ],
                              image: DecorationImage(
                                image: AssetImage("assets/images/facebook.jpg"),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),


                    SizedBox(height: 4.66 * SizeConfig.heightMultiplier,),

                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {

                          email = null;
                          password = null;

                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Register()));

                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Don\'t have an Account? ',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: 2.63 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign up',
                                style: TextStyle(
                                  color:Color.fromARGB(
                                    255, 0, 173, 207),
                                  fontSize: 2.63 * SizeConfig.textMultiplier,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )



                  ],




                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

