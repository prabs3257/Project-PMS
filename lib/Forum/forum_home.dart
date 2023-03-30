import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pms/Forum/forum_answers.dart';
import 'package:project_pms/save_config.dart';

import 'package:project_pms/constants.dart';

class ForumHome extends StatefulWidget {

  final String uid;

  const ForumHome({Key key, this.uid}) : super(key: key);
  @override
  _ForumHomeState createState() => _ForumHomeState(uid);
}

class _ForumHomeState extends State<ForumHome> {
  final String uid;
  String quesId;

  _ForumHomeState(this.uid);



  Future<void> showInformationDialog(BuildContext context) async{

    String title;
    String description;



    return await showDialog(context: context,
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
                                        title = value;
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
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 20.0, bottom: 8),
                                      child: Text(
                                        "Description",
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
                                        description = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Enter Description",
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
                              SizedBox(height: 10,),
                              RawMaterialButton(
                                onPressed: () async{



                                  DocumentReference dRef = await FirebaseFirestore.instance.collection('Questions').add(
                                      {
                                        'Title' : title,
                                        'Description' : description,
                                        'CreatorId' : uid,
                                        'Date' : DateTime.now().toString()


                                      }
                                  );
                                  DocumentSnapshot ds1 = await FirebaseFirestore.instance.collection('userdata').doc(uid).get();



                                  await FirebaseFirestore.instance.collection('Questions').doc(dRef.id).update(
                                      {
                                        'QuesId' : dRef.id,
                                        'CreatorName' : ds1['Name']
                                      }
                                  );





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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 240, 244),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Questions').orderBy('Date',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if(!snapshot.hasData || snapshot.data.docs.isEmpty){
            return Center(child: Text("No questions"));
          }


          return Column(
            children: [
              SizedBox(height: 100,),
              Expanded(
                child: new ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,index) {
                      DocumentSnapshot ds = snapshot.data.docs[index];




                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 8),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(height: 10),
                              ListTile(
                                leading: Icon(Icons.album, size:50),
                                title: Text(ds['Title'], style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                                subtitle: Text("Created By ${ds['CreatorName']} on ${ds['Date'].toString().substring(0,16)}"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  // TextButton(
                                  //   child: const Text('BUY TICKETS'),
                                  //   onPressed: () {/* ... */},
                                  // ),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text('Answers'),
                                    onPressed: () {
                                      quesId = ds['QuesId'];
                                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AnswersPage(uid : uid,quesId: quesId,
                                      quesCreator: ds['CreatorName'],
                                      quesDate: ds['Date'],
                                      quesDesc: ds['Description'],
                                      quesTitle: ds['Title'],)));


                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );

                    }),
              ),
            ],
          );





        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showInformationDialog(context);

        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),

    );
  }
}
