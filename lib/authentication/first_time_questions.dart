import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/home_page.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class FirstTimeQues extends StatefulWidget {
  final String uid;

  const FirstTimeQues({Key key, this.uid}) : super(key: key);
  @override
  _FirstTimeQuesState createState() => _FirstTimeQuesState(uid);
}

class _FirstTimeQuesState extends State<FirstTimeQues> {


  final String uid;

  int _currentHorizontalIntValue = 10;
  double value = 6;
  bool _rememberMe = false;

  int cycleDuration = -1;
  bool idkCycleDuration = false;

  double cycleLength = 0;
  bool idkCycleLength = false;

  String lastPeriodDate = "-1";
  bool idkLastPeriodDate = false;

  String isPeriodRegular = "-1";
  bool idkIsPeriodRegular = false;

  double height = 0;
  bool idkHeight = false;

  int weight = -1;
  bool idkweight = false;

  final TextEditingController lastPeriodDateController = TextEditingController();



  _FirstTimeQuesState(this.uid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {

    return loading ? Loading() : Scaffold(
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


            ],
          ),
          backgroundColor: Colors.white,

        ),
      body: PageView(
        children: [
          Column(
        children: [

          Container(

            width: double.infinity,
            height: 8.78*SizeConfig.heightMultiplier,
            color: Color.fromARGB(255, 0, 173, 207),
            child: Center(child: Text("Let us know little more about you",style: TextStyle(fontSize: 2.92*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Colors.white),)),
          ),

          SizedBox(height: 5*SizeConfig.heightMultiplier,),
          Image(image: AssetImage("assets/images/qpageone.png"),
            width: 55.66 * SizeConfig.imageSizeMultiplier,),
          SizedBox(height: 2*SizeConfig.heightMultiplier,),

          Padding(
            padding:  EdgeInsets.only(left: 7 * SizeConfig.imageSizeMultiplier ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Duration of Cycle?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.78*SizeConfig.heightMultiplier),)),
          ),
          SizedBox(height: 1*SizeConfig.heightMultiplier,),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 0,vertical: 1.46*SizeConfig.heightMultiplier),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 0, 173, 207),width: 2),

                borderRadius: BorderRadius.all(
                    Radius.circular(15.0)
                ),
              ),
              child: NumberPicker(

                value: _currentHorizontalIntValue,
                minValue: 0,
                maxValue: 100,
                step: 1,

                itemWidth: 7.32*SizeConfig.heightMultiplier,
                itemHeight: 7.32*SizeConfig.heightMultiplier,

                itemCount: 5,
                selectedTextStyle: TextStyle(color: Color.fromARGB(255, 0, 173, 207),fontSize: 24),

                axis: Axis.horizontal,
                onChanged: (value) =>
                    setState(() {

                      _currentHorizontalIntValue = value;
                      cycleDuration = value;
                    }

                    ),

              ),

            ),
          ),

          SizedBox(height: 0.4*SizeConfig.heightMultiplier,),
          Padding(
            padding:  EdgeInsets.only(left: 4*SizeConfig.imageSizeMultiplier),
            child: Container(
              height: 2.92*SizeConfig.heightMultiplier,
              child: Row(
                children: <Widget>[
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.black45),
                    child: Checkbox(
                      value: idkCycleDuration,
                      checkColor: Colors.white,
                      activeColor: Colors.black45,
                      onChanged: (value) {
                        setState(() {
                          idkCycleDuration = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'I dont know',
                    style: TextStyle(color: Colors.black45),

                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.2*SizeConfig.heightMultiplier,),
          Padding(
            padding:  EdgeInsets.only(left: 7 * SizeConfig.imageSizeMultiplier ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Length of Cycle?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.78*SizeConfig.heightMultiplier),)),
          ),
          SizedBox(height: 0.5*SizeConfig.heightMultiplier,),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier,vertical: 1.46*SizeConfig.heightMultiplier),
            child: Container(

              decoration: BoxDecoration(
                color: Colors.orange,

                borderRadius: BorderRadius.all(
                    Radius.circular(15.0)
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 1.94*SizeConfig.imageSizeMultiplier,vertical: 0.3*SizeConfig.heightMultiplier),
                child: Row(

                  children: [
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: 10,
                        activeColor: Colors.white,
                        inactiveColor: Colors.white,
                        value: cycleLength,
                        onChanged: (value) {

                          setState(() {


                            cycleLength = value;

                          });


                        },

                      ),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: 2.43*SizeConfig.imageSizeMultiplier),
                      child: Container(

                        decoration: BoxDecoration(
                          color: Colors.white,

                          borderRadius: BorderRadius.all(
                              Radius.circular(12.0)
                          ),

                        ),
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier,vertical: 1.46*SizeConfig.heightMultiplier),
                          child: Text(cycleLength.round().toString()),
                        ),
                      ),
                    ),

                    Text("Days",style: TextStyle(color: Colors.white,fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.w600),)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 0.4*SizeConfig.heightMultiplier,),
          Padding(
            padding:  EdgeInsets.only(left: 4*SizeConfig.imageSizeMultiplier),
            child: Container(
              height: 20.0,
              child: Row(
                children: <Widget>[
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.black45),
                    child: Checkbox(
                      value: idkCycleLength,
                      checkColor: Colors.white,
                      activeColor: Colors.black45,
                      onChanged: (value) {
                        setState(() {
                          idkCycleLength = value;
                        });
                      },
                    ),
                  ),
                  Text(
                    'I dont know',
                    style: TextStyle(color: Colors.black45),

                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4*SizeConfig.heightMultiplier,),

          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 7*SizeConfig.imageSizeMultiplier),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                SizedBox(width: 25.49*SizeConfig.imageSizeMultiplier,),

                Text("1/3",style: TextStyle(color: Color.fromARGB(255, 0, 173, 207),fontWeight: FontWeight.bold),),
                Text("Swipe for more >>",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black45),),
              ],

            ),
          )







        ],


        ),
          Column(
            children: [

              Container(

                width: double.infinity,
                height: 8.78*SizeConfig.heightMultiplier,
                color: Color.fromARGB(255, 0, 173, 207),
                child: Center(child: Text("Let us know little more about you",style: TextStyle(fontSize: 2.92*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Colors.white),)),
              ),

              SizedBox(height: 5*SizeConfig.heightMultiplier,),
              Image(image: AssetImage("assets/images/qpagetwo.png"),
                width: 55.66 * SizeConfig.imageSizeMultiplier,),
              SizedBox(height: 2*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.only(left: 7 * SizeConfig.imageSizeMultiplier ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Last period date?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.78*SizeConfig.heightMultiplier),)),
              ),
              SizedBox(height: 2.8*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 5.35*SizeConfig.imageSizeMultiplier,vertical: 0),
                child: TextField(
                  controller: lastPeriodDateController,
                  onChanged: (value){

                  },
                  keyboardType: TextInputType.emailAddress,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                    color: Colors.black45,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(18.0),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(left: 4.86*SizeConfig.imageSizeMultiplier),
                    suffixIcon: IconButton(
                      onPressed: (){



                        FocusManager.instance.primaryFocus.unfocus();                            showDatePicker(context: context,
                            initialDate: DateTime(2001), firstDate: DateTime(1920),
                            lastDate: DateTime(2020)).then((date) {
                          print("birthday" + date.toString());
                          setState(() {

                            lastPeriodDate = date.toString().substring(0,10);
                            lastPeriodDateController.text = date.toString().substring(0,10);

                            FocusManager.instance.primaryFocus.unfocus();
                          });
                        });
                      },
                      icon: Icon(Icons.calendar_today,color: Color.fromARGB(255, 0, 173, 207)),),

                    hintText: 'YYYY-MM-DD',
                    hintStyle: TextStyle(fontSize: 2.63*SizeConfig.heightMultiplier,color: Colors.black45,fontWeight: FontWeight.w400),
                  ),
                ),
              ),

              SizedBox(height: 2.8*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.only(left: 4*SizeConfig.imageSizeMultiplier),
                child: Container(
                  height: 2.92*SizeConfig.heightMultiplier,
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black45),
                        child: Checkbox(
                          value: idkLastPeriodDate,
                          checkColor: Colors.white,
                          activeColor: Colors.black45,
                          onChanged: (value) {
                            setState(() {
                              idkLastPeriodDate = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I dont know',
                        style: TextStyle(color: Colors.black45),

                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.2*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.only(left: 7 * SizeConfig.imageSizeMultiplier ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Are your Periods regular or irregular?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.78*SizeConfig.heightMultiplier),)),
              ),
              SizedBox(height: 1.8*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Row(
                      children: [
                        Radio(value: 'Regular', groupValue: isPeriodRegular,
                            onChanged: (value){
                              isPeriodRegular = value;
                              setState(() {

                              });
                        }),
                        Text("Regular",style: TextStyle(fontSize: 2.34*SizeConfig.heightMultiplier,fontWeight: FontWeight.w400),)
                      ],
                    ),
                    Row(
                      children: [
                        Radio(value: 'Irregular', groupValue: isPeriodRegular, onChanged: (value){
                          isPeriodRegular = value;
                          setState(() {

                          });
                        }),
                        Text("Irregular",style: TextStyle(fontSize: 2.34*SizeConfig.heightMultiplier,fontWeight: FontWeight.w400),)
                      ],
                    ),



                  ],
                ),
              ),
              SizedBox(height: 1.8*SizeConfig.heightMultiplier,),


              SizedBox(height: 0.4*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.only(left: 4*SizeConfig.imageSizeMultiplier),
                child: Container(
                  height: 2.92*SizeConfig.heightMultiplier,
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black45),
                        child: Checkbox(
                          value: idkIsPeriodRegular,
                          checkColor: Colors.white,
                          activeColor: Colors.black45,
                          onChanged: (value) {
                            setState(() {
                              idkIsPeriodRegular = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I dont know',
                        style: TextStyle(color: Colors.black45),

                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 4*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 7*SizeConfig.imageSizeMultiplier),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    SizedBox(width: 25.49*SizeConfig.imageSizeMultiplier,),

                    Text("2/3",style: TextStyle(color: Color.fromARGB(255, 0, 173, 207),fontWeight: FontWeight.bold),),
                    Text("Swipe for more >>",style: TextStyle(fontStyle: FontStyle.italic,color: Colors.black45),),
                  ],

                ),
              )







            ],


          ),
          Column(
            children: [

              Container(

                width: double.infinity,
                height: 8.78*SizeConfig.heightMultiplier,
                color: Color.fromARGB(255, 0, 173, 207),
                child: Center(child: Text("Let us know little more about you",style: TextStyle(fontSize: 2.92*SizeConfig.heightMultiplier,fontWeight: FontWeight.bold,color: Colors.white),)),
              ),

              SizedBox(height: 5*SizeConfig.heightMultiplier,),
              Image(image: AssetImage("assets/images/qpagethree.png"),
                width: 25.66 * SizeConfig.imageSizeMultiplier,),
              SizedBox(height: 2*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.only(left: 7 * SizeConfig.imageSizeMultiplier ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("What is your Height?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.78*SizeConfig.heightMultiplier),)),
              ),
              SizedBox(height: 1*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier,vertical: 1.46*SizeConfig.heightMultiplier),
                child: Container(

                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 167, 205, 57),

                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0)
                    ),
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 1.94*SizeConfig.imageSizeMultiplier,vertical: 0.3*SizeConfig.heightMultiplier),
                    child: Row(

                      children: [
                        Expanded(
                          child: Slider(
                            min: 0,
                            max: 200,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white,
                            value: height,
                            onChanged: (value) {
                              setState(() {

                                height = value;
                              });
                            },

                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.only(right: 2.43*SizeConfig.imageSizeMultiplier),
                          child: Container(

                            decoration: BoxDecoration(
                              color: Colors.white,

                              borderRadius: BorderRadius.all(
                                  Radius.circular(12.0)
                              ),

                            ),
                            child: Padding(
                              padding:  EdgeInsets.symmetric(horizontal: 3.64*SizeConfig.imageSizeMultiplier,vertical: 1.46*SizeConfig.heightMultiplier),
                              child: Text(height.round().toString()),
                            ),
                          ),
                        ),

                        Text("cm",style: TextStyle(color: Colors.white,fontSize: 2.63*SizeConfig.heightMultiplier,fontWeight: FontWeight.w600),)
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 0.4*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.only(left: 4*SizeConfig.imageSizeMultiplier),
                child: Container(
                  height: 2.92*SizeConfig.heightMultiplier,
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black45),
                        child: Checkbox(
                          value: idkHeight,
                          checkColor: Colors.white,
                          activeColor: Colors.black45,
                          onChanged: (value) {
                            setState(() {
                              idkHeight = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I dont know',
                        style: TextStyle(color: Colors.black45),

                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 2.2*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.only(left: 7 * SizeConfig.imageSizeMultiplier ),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("What is your Weight?",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 2.78*SizeConfig.heightMultiplier),)),
              ),
              SizedBox(height: 0.5*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 9.73*SizeConfig.imageSizeMultiplier,vertical: 1.46*SizeConfig.heightMultiplier),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 0, 173, 207),width: 2),


                    borderRadius: BorderRadius.all(
                        Radius.circular(15.0)
                    ),
                  ),
                  child: Row(
                    children: [
                      NumberPicker(

                        value: _currentHorizontalIntValue,
                        minValue: 0,
                        maxValue: 100,
                        step: 1,

                        itemWidth: 12.16*SizeConfig.imageSizeMultiplier,
                        itemHeight: 7.32*SizeConfig.heightMultiplier,

                        itemCount: 5,
                        selectedTextStyle: TextStyle(color: Color.fromARGB(255, 0, 173, 207),fontSize: 24),

                        axis: Axis.horizontal,
                        onChanged: (value) {

                          setState(() => _currentHorizontalIntValue = value);
                          weight = value;
                        }
                            ,

                      ),
                      Padding(
                        padding:  EdgeInsets.only(left: 1.5*SizeConfig.imageSizeMultiplier),
                        child: Container(

                          decoration: BoxDecoration(
                            color:Color.fromARGB(
                                255, 0, 173, 207),

                            borderRadius: BorderRadius.all(
                                Radius.circular(12.0)
                            ),

                          ),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 3.44*SizeConfig.imageSizeMultiplier,vertical: 1.66*SizeConfig.heightMultiplier),
                            child: Text("Kg",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),

                    ],
                  ),

                ),
              ),
              SizedBox(height: 0.4*SizeConfig.heightMultiplier,),
              Padding(
                padding:  EdgeInsets.only(left: 4*SizeConfig.imageSizeMultiplier),
                child: Container(
                  height: 2.92*SizeConfig.heightMultiplier,
                  child: Row(
                    children: <Widget>[
                      Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.black45),
                        child: Checkbox(
                          value: idkweight,
                          checkColor: Colors.white,
                          activeColor: Colors.black45,
                          onChanged: (value) {
                            setState(() {
                              idkweight = value;
                            });
                          },
                        ),
                      ),
                      Text(
                        'I dont know',
                        style: TextStyle(color: Colors.black45),

                      ),
                    ],
                  ),
                ),
              ),

              //SizedBox(height: 4*SizeConfig.heightMultiplier,),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 1.53*SizeConfig.heightMultiplier,vertical: 1*SizeConfig.heightMultiplier),
                child: Container(
                  width: double.infinity,
                  child: RaisedButton(

                    elevation: 5.0,
                    onPressed: () async{


                      if(cycleDuration == -1 && idkCycleDuration == false){
                        Fluttertoast.showToast(
                          msg: "Please input Cycle Duration",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                        );
                      }else if(cycleLength == 0 && idkCycleLength == false){
                        Fluttertoast.showToast(
                          msg: "Please input Cycle Length",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                        );
                      }else if(lastPeriodDate == "-1" && idkLastPeriodDate == false){
                        Fluttertoast.showToast(
                          msg: "Please input Last period date",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                        );
                      }else if(isPeriodRegular == "-1" && idkIsPeriodRegular == false){
                        Fluttertoast.showToast(
                          msg: "Please input Period regularity",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                        );
                      }else if(height == 0 && idkHeight == false){
                        Fluttertoast.showToast(
                          msg: "Please input your Height",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                        );
                      }else if(weight == -1 && idkweight == false){
                        Fluttertoast.showToast(
                          msg: "Please input your Weight",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,

                        );
                      }else{


                        User user = await FirebaseAuth.instance.currentUser;
                        if(user.providerData[0].providerId == 'facebook.com'){

                          await FirebaseFirestore.instance.collection('userdata').doc(uid).set(
                              {
                                'FormFilled' : true,
                                'ProfilePic' : user.photoURL,
                                'Name': user.displayName,
                                'CycleDuration' : cycleDuration,
                                'CycleLength' : cycleLength.round(),
                                'LastPeriodDate' : lastPeriodDate,
                                'PeriodRegularity' : isPeriodRegular,
                                'Height' : height.round(),
                                'Weight' : weight

                              }
                          );

                        }else if(user.providerData[0].providerId == 'google.com'){

                          print("Its google yeh");

                          await FirebaseFirestore.instance.collection('userdata').doc(uid).set(
                              {
                                'FormFilled' : true,
                                'ProfilePic' : "https://firebasestorage.googleapis.com/v0/b/project-pms-4770e.appspot.com/o/arnel-hasanovic-MNd-Rka1o0Q-unsplash.jpg?alt=media&token=08a59060-4859-4cc5-a37c-9f00a9748f32",
                                'Name': user.displayName,
                                'CycleDuration' : cycleDuration,
                                'CycleLength' : cycleLength.round(),
                                'LastPeriodDate' : lastPeriodDate,
                                'PeriodRegularity' : isPeriodRegular,
                                'Height' : height.round(),
                                'Weight' : weight

                              }
                          );

                        }else{

                          await FirebaseFirestore.instance.collection('userdata').doc(uid).update(
                              {
                                'FormFilled' : true,

                                'ProfilePic' : "https://firebasestorage.googleapis.com/v0/b/project-pms-4770e.appspot.com/o/arnel-hasanovic-MNd-Rka1o0Q-unsplash.jpg?alt=media&token=08a59060-4859-4cc5-a37c-9f00a9748f32",
                                'CycleDuration' : cycleDuration,
                                'CycleLength' : cycleLength.round(),
                                'LastPeriodDate' : lastPeriodDate,
                                'PeriodRegularity' : isPeriodRegular,
                                'Height' : height.round(),
                                'Weight' : weight

                              }
                          );
                        }

                        await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidget(uid : uid)));



                      }


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







            ],


          ),

        ],
      )
    );
  }
}
