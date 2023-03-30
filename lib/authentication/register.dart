import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_pms/authentication/first_time_questions.dart';
import 'package:project_pms/home_page.dart';


import 'authentication.dart';
import 'sign_in_up_bar.dart';
import '../title.dart';
import '../main.dart';
import '../constants.dart';
import '../save_config.dart';

class Register extends StatefulWidget {
  const Register({Key key, this.onSignInPressed}) : super(key: key);

  final VoidCallback onSignInPressed;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String email;
  String password;
  String name;
  String dob;
  String number;


  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  DateTime selectedDob;
  final TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
        key: signUpFormKey,
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
                    child: Image(image: AssetImage("assets/images/sslogo.png"),
                      width: 45.66 * SizeConfig.imageSizeMultiplier,),
                  ),
                  Column(
                    children: [
                      SizedBox(height:(SizeConfig.heightMultiplier>7)? 5.5* SizeConfig.heightMultiplier : 3.5* SizeConfig.heightMultiplier,),
                      Text("Sign up",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 3.51*SizeConfig.heightMultiplier,color: Colors.black54),),

                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty ){
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
                      SizedBox(height: 1.06 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                        child: TextFormField(

                          validator: (String value){
                            if(value.isEmpty ){
                              return "Please enter a Date of Birth";
                            }
                            return null;
                          },
                          controller: dobController,
                          onChanged: (value){
                            dob = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.bottom,
                          style: TextStyle(
                            color: Colors.black45,
                            fontFamily: 'OpenSans',
                          ),

                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 3),
                            suffixIcon: IconButton(
                              padding: EdgeInsets.only(top: 2.93*SizeConfig.heightMultiplier),
                              icon: Icon(Icons.calendar_today, color:Color.fromARGB(
                                  255, 0, 173, 207),size: 22,),
                              onPressed: () {


                                FocusManager.instance.primaryFocus.unfocus();                            showDatePicker(context: context,
                                    initialDate: DateTime(2001), firstDate: DateTime(1920),
                                    lastDate: DateTime(2020)).then((date) {
                                      print("birthday" + date.toString());
                                      setState(() {

                                        dob = date.toString().substring(0,10);
                                        dobController.text = date.toString().substring(0,10);

                                        FocusManager.instance.primaryFocus.unfocus();
                                      });
                                });
                              },
                            ),




                            hintText: 'Date of Birth (YYYY-MM-DD)',
                            hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold,),
                          ),
                        ),
                      ),
                      SizedBox(height: 0.06 * SizeConfig.heightMultiplier,),
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
                      SizedBox(height: 1.06 * SizeConfig.heightMultiplier,),
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
                      SizedBox(height: 1.06 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                        child: TextFormField(
                          validator: (String value){
                            if(value.isEmpty || value.length<6){
                              return "Please enter a Password with 6 or more characters";
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
                      SizedBox(height: 1.06 * SizeConfig.heightMultiplier,),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                        child: TextFormField(

                          validator: (String value){
                            if(value.isEmpty || value != password){
                              return "Please confirm your password";
                            }
                            return null;
                          },
                          onChanged: (value){

                          },
                          keyboardType: TextInputType.emailAddress,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontFamily: 'OpenSans',
                          ),
                          decoration: InputDecoration(


                            contentPadding: EdgeInsets.only(bottom: 3),
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.06 * SizeConfig.heightMultiplier,),

                      Padding(
                        padding:  EdgeInsets.all(1.53*SizeConfig.heightMultiplier),
                        child: Container(
                          width: double.infinity,
                          child: RaisedButton(


                            elevation: 5.0,
                            onPressed: () async{

                              if(signUpFormKey.currentState.validate())
                              {
                                print("successful");






                                try {
                                  final newUser = await auth
                                      .createUserWithEmailAndPassword(
                                      email: email, password: password);


                                  if(newUser != null){


                                    var currentuser = auth.currentUser;
                                    User user = currentuser;

                                    await FirebaseFirestore.instance.collection('userdata').doc(user.uid).set(
                                        {
                                          'FormFilled' : false,
                                          'D.O.B' : dob,
                                          'Contact Number' : number,
                                          'Name' : name

                                        }
                                    );


                                    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => FirstTimeQues(uid : user.uid)));

                                  }
                                }catch(e){
                                  print(e);
                                }



                              }else{
                                print("UnSuccessfull");
                              }








                            },
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2.2*SizeConfig.heightMultiplier),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),

                            ),
                            color:Color.fromARGB(
                              255, 0, 173, 207),
                            child: Text(
                              'REGISTER',
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


                      SizedBox(height: 2.66 * SizeConfig.heightMultiplier,),

                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {

                            email = null;
                            password = null;

                            Navigator.pop(context);

                          },
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Have an Account? ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 2.63 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Sign in',
                                  style: TextStyle(
                                    color:Color.fromARGB(
                                        255, 0, 173, 207),
                                    fontSize: 2.63 * SizeConfig.textMultiplier,
                                    fontWeight: FontWeight.bold,
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
      ),
    );
  }
}