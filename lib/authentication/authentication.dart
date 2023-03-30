import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:project_pms/home_page.dart';
import 'file:///C:/Users/prabh/AndroidStudioProjects/project_pms/lib/authentication/sign_in.dart';


FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

FacebookAccessToken accessToken;

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
bool formFilled ;

var userData = FirebaseFirestore.instance.collection('userdata');



googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

  if(googleSignInAccount != null){

    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,
    accessToken: googleSignInAuthentication.accessToken);

   UserCredential result = await auth.signInWithCredential(credential);

   User user = await auth.currentUser;

   print(user.uid);
   print(user.photoURL);
  }
}

void isFormFilled() async{

  String test = "hello";


  DocumentSnapshot ds = await userData.doc(loggedInUser.uid).get();


  formFilled = await ds['FormFilled'];
  print("Filled is ${formFilled}");








}

Future<Null> facebookSignIn() async {

  final FacebookLogin facebookSignIn = new FacebookLogin();

  final FacebookLoginResult result =
  await facebookSignIn.logIn(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
       accessToken = result.accessToken;
      print('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');





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

  print(user.uid);


}

void SignInWithEmail(String email , String password, BuildContext context) async{


  try {
    final user = await auth.signInWithEmailAndPassword(
        email: email, password: password);

    var currentuser =  auth.currentUser;





    if (user != null) {

    /*  isFormFilled();
      print("Filled value is $formFilled");
      if(formFilled == false || formFilled == null) {
         await userData.doc(loggedInUser.uid).set(
            { 'FormFilled': false}
        );
       // print("making it false formFilled is : ${isFormFilled()}");
      }

     */








      print(currentuser.email);
    }
  }catch(e){
    print("error is $e");
  }



}

void SignUp(String email , String password, BuildContext context) async{

  try {
    final newUser = await auth
        .createUserWithEmailAndPassword(
        email: email, password: password);


    if(newUser != null){


      var currentuser = auth.currentUser;
      loggedInUser = currentuser;

      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));

    }
  }catch(e){
    print(e);
  }



}