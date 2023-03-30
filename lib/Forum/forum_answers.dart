import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/constants.dart';
import 'package:project_pms/profile_page.dart';
import 'package:project_pms/save_config.dart';


class AnswersPage extends StatefulWidget {

  final String uid;
  final String quesId;
  final String quesTitle;
  final String quesDesc;
  final String quesDate;
  final String quesCreator;

  const AnswersPage({Key key, this.uid, this.quesId, this.quesTitle, this.quesDesc, this.quesDate, this.quesCreator}) : super(key: key);
  @override
  _AnswersPageState createState() => _AnswersPageState(uid,quesId,quesTitle,quesDesc,quesDate,quesCreator);
}

class _AnswersPageState extends State<AnswersPage> {
  final String uid;
  final String quesId;
  final String quesTitle;
  final String quesDesc;
  final String quesDate;
  final String quesCreator;


  String imageUrl;






  Future<void> showInformationDialog(BuildContext context) async{

    String answer;




    return await showDialog(context: context,
        builder: (context) {

          return Stack(

            children: [
              Padding(
                padding:  EdgeInsets.only(top: 4.39*SizeConfig.heightMultiplier),
                child: Dialog(

                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: Padding(
                    padding:  EdgeInsets.only(top: 5.85*SizeConfig.heightMultiplier),
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
                                      padding:  EdgeInsets.only(left: 4.86*SizeConfig.imageSizeMultiplier, bottom: 1.17*SizeConfig.heightMultiplier),
                                      child: Text(
                                        "Answer",
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
                                        answer = value;
                                      },
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: Color(0xff0962ff),
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: "Enter Answer",
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

                                  DocumentSnapshot ds = await FirebaseFirestore.instance.collection('userdata').
                                  doc(uid).get();

                                  await FirebaseFirestore.instance.collection('Answers')
                                      .doc(quesId).collection('AnswersList').doc().set(
                                      {
                                        'Answer' : answer,
                                        'AnsweringId' : uid,
                                        'AnsweringName' : ds['Name'],
                                        'AnsweringDate' : DateTime.now().toString(),
                                        'AnsweringProfilePic' : ds['ProfilePic']
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



  void initState() {
    // TODO: implement initState
    super.initState();


    getImage();


  }
  getImage() async{
    DocumentSnapshot ds = await FirebaseFirestore.instance.collection("userdata").doc(uid).get();
    setState(() {
      imageUrl = ds['ProfilePic'];
    });




  }



  _AnswersPageState(this.uid, this.quesId, this.quesTitle, this.quesDesc, this.quesDate, this.quesCreator, );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.78*SizeConfig.heightMultiplier,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 0, 173, 207),
                height: 8.78*SizeConfig.heightMultiplier,
                width: double.infinity,
                child: Center(child: Text("Community",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),)),

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 2.19*SizeConfig.heightMultiplier,horizontal: 2.43*SizeConfig.imageSizeMultiplier),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quesTitle,
                        style: TextStyle(fontSize: 2.92*SizeConfig.heightMultiplier, fontWeight: FontWeight.bold,color:Color.fromARGB(
                            255, 0, 173, 207),
                          ),),
                        SizedBox(height: 2.92*SizeConfig.heightMultiplier,),
                        Text(quesDesc,
                          style: TextStyle(fontSize: 2.34*SizeConfig.heightMultiplier,
                          ),),
                        SizedBox(height: 2.92*SizeConfig.heightMultiplier,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Posted By $quesCreator on ${quesDate.toString().substring(0,16)}",
                            style: TextStyle(color: Colors.black38),)
                          ],
                        )


                      ],
                    ),
                  ),
                ),
              ),

               Divider(
                height: 0,
                thickness: 1.5,
                indent: 4.86*SizeConfig.imageSizeMultiplier,
                endIndent: 4.86*SizeConfig.imageSizeMultiplier,
                color: Colors.black12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 1.75*SizeConfig.heightMultiplier),
                    child: Column(
                      children: [
                        Icon(Icons.edit,color: Colors.black45,),
                        SizedBox(height: 5,),
                        Text("Answer(05)",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 1.75*SizeConfig.heightMultiplier),
                    child: Column(
                      children: [
                        Icon(Icons.thumb_up_alt_outlined,color: Colors.black45,),
                        SizedBox(height: 5,),
                        Text("15 Likes",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 1.75*SizeConfig.heightMultiplier),
                    child: Column(
                      children: [
                        Icon(Icons.question_answer,color: Colors.black45,),
                        SizedBox(height: 5,),
                        Text("Comment(10)",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 1.75*SizeConfig.heightMultiplier),
                    child: Column(
                      children: [
                        Icon(Icons.share,color: Colors.black45,),
                        SizedBox(height: 5,),
                        Text("Share",style: TextStyle(color: Colors.black45,fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],

              ),
              SizedBox(height: 5,),
               Divider(
                height: 0,
                thickness: 1.5,
                indent: 4.86*SizeConfig.imageSizeMultiplier,
                endIndent: 4.86*SizeConfig.imageSizeMultiplier,
                color: Colors.black12,
              ),

              SizedBox(height: 5,),
              StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('Answers').doc(quesId)
                      .collection('AnswersList').snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

                    if(!snapshot.hasData || snapshot.data.docs.isEmpty){
                      return Center(child: Text("No Answers"));
                    }
                    return new ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context,index){
                          DocumentSnapshot ds = snapshot.data.docs[index];

                          return Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 2.43*SizeConfig.imageSizeMultiplier,vertical: 3),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: ClipOval(


                                          child: FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/shop_banner.jpg',
                                            image: ds['AnsweringProfilePic'],

                                            width: 6.98*SizeConfig.heightMultiplier,
                                            height: 6.98*SizeConfig.heightMultiplier,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 2.43*SizeConfig.imageSizeMultiplier,),

                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(ds['AnsweringName'],style: TextStyle(fontSize: 2.92*SizeConfig.heightMultiplier, fontWeight: FontWeight.bold,color:Color.fromARGB(
                                              255, 0, 173, 207),
                                          ),),
                                          Text("Answered On - ${ds['AnsweringDate'].toString().substring(0,16)}",style: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold),)
                                        ],
                                      )
                                    ],
                                  ),

                                  SizedBox(height: 2.92*SizeConfig.heightMultiplier,),


                                  Text(ds['Answer'],
                                  textAlign: TextAlign.left,),
                                  SizedBox(height: 2.19 * SizeConfig.heightMultiplier,),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(Icons.thumb_up_alt_outlined,color: Colors.black45,),
                                      SizedBox(width: 2.43 * SizeConfig.imageSizeMultiplier,),
                                      Icon(Icons.question_answer,color: Colors.black45,),
                                    ],
                                  ),

                                  SizedBox(height: 5,),
                                  const Divider(
                                    height: 0,
                                    thickness: 1.5,
                                    indent: 0,
                                    endIndent: 0,
                                    color: Colors.black12,
                                  ),


                                ],
                              ),
                            ),
                          );


                        });
                  }
              ),
            ],
          ),
        ),
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
