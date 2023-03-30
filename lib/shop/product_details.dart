import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project_pms/authentication/authentication.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/profile_page.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_pms/shop/thank_you_page.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:visibility_detector/visibility_detector.dart';



class ProductDetailsPage extends StatefulWidget {

  final String uid;
  final String productId;



  const ProductDetailsPage({Key key, this.uid, this.productId}) : super(key: key);
  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState(uid,productId);
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final String uid;
  final String productId;

  int noOfReviews = 0;

  String reviewRating = (1.0).toString();
  String reviewTitle;
  String reviewDesc;

  List reviewList;

  bool showSpecs = false;
  bool showKit = false;

  String imgURL ;

  List imgList = [];
  List specsList = [];

  DocumentSnapshot ds;
  bool showOrignalPrice = false;
  List categories;
  List insideKit;

  bool hasReviewed = false;

  int numReviewsShown = 2;

  bool canShowMoreReviews = true;
  bool noReviews = false;

  bool showBottomBuy = false;

  Razorpay razorpay;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   decide();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);
  }

  void handlerPaymentSuccess(PaymentSuccessResponse response) async{

    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ThankYouPage(uid: uid,)));

    Map order = {'OrderId' : DateTime.now().millisecondsSinceEpoch,'ItemName' : ds['Name'],'ItemPrice' : ds['Price'],
      'OrderingTime' : DateTime.now().toString(),
    };

    await FirebaseFirestore.instance.collection('userdata').doc(uid).update({

      'Orders' : FieldValue.arrayUnion([order]),
    });


  }

  void handlerErrorFailure(){
    Fluttertoast.showToast(
      msg: "Payment Failed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,

    );

  }

  void handlerExternalWallet(){
    print("External Wallet");

  }


  void openCheckout(){
    var options = {
      "key" : "rzp_test_jxcMEmv3iA0gJ6",
      "amount" : ds['Price'] *100,
      "name" : ds['Name'],
      "description" : "Payment for ",
      "prefill" : {
        "contact" : "9818882828",
        "email" : "aab@cdd.com"
      },
      "external" : {
        "wallets" : ["paytm"]
      }
    };

    try{
      razorpay.open(options);
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> showInformationDialog(BuildContext context) async{



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
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                  child: Container(


                                    child: RaisedButton(
                                      elevation: 5.0,
                                      onPressed: () async{

                                        print("hello"+ ds['Reviews'].length.toString());

                                        DocumentSnapshot dsUser = await FirebaseFirestore.instance.collection('userdata').doc(uid).get();



                                        Map review = {'ReviewTitle' : reviewTitle,'ReviewRating' : reviewRating,
                                        'ReviewDesc' : reviewDesc,'ReviewerId' : uid,'ReviewingTime' : DateTime.now().toString(),
                                        'ReviewerName' : dsUser['Name']};


                                        ds['Reviews'].forEach((elements) {

                                          if(elements['ReviewerId'] == uid){


                                            FirebaseFirestore.instance.collection('Products').doc(productId).update({

                                              'Reviews' : FieldValue.arrayRemove([elements]),
                                              'TotalRating' : (double.parse(ds['TotalRating']) - double.parse(elements['ReviewRating'])).toString()



                                            });
                                            FirebaseFirestore.instance.collection('Products').doc(productId).update({


                                              'Reviews' : FieldValue.arrayUnion([review]),

                                            });

                                          }else{



                                          }


                                        });



                                        await FirebaseFirestore.instance.collection('Products').doc(productId).update({

                                          'Reviews' : FieldValue.arrayUnion([review] ),


                                        });

                                        print([ds['Reviews']].length);
                                        await FirebaseFirestore.instance.collection('Products').doc(productId).update({


                                          'NumberOfRatings' : ds['Reviews'].length.toString(),
                                          'TotalRating' : (double.parse(ds['TotalRating']) + double.parse(reviewRating)).toString()


                                        });
                                        await FirebaseFirestore.instance.collection('Products').doc(productId).update({


                                          'Rating' : (double.parse(ds['TotalRating'])/double.parse(ds['NumberOfRatings'])).toString()


                                        });






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
                 child: Text("Rate & Review",
                   style: TextStyle(decoration: TextDecoration.none, fontSize: 20,color: Colors.white),),
               ),
             ),


           ],
         );




        });
  }



  Future<Widget> decide() async{
    /* if(imageFile == null){
      return Center(child: Text("No data"));

    }else{
      print(imageFile);


      return Image.memory(imageFile);


    }

    */

    await FirebaseFirestore.instance.collection('ShowcaseImages').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {

          if(doc.id == productId){
             imgList.add(doc);
          }

        });


        // print(value['Name']);
      });
    });





    ds = await FirebaseFirestore.instance.collection('Products').doc(productId).get();









    setState(() {
      loading = false;
    });



    if(ds['onSale'] == true){
      showOrignalPrice = true;
    }





    categories = ds['Categories'];
    specsList = ds['Specifications'];
    insideKit = ds['InsideKit'];



    if(specsList[0] != null){
      showSpecs = true;

    }
    if(insideKit[0] != null){
      showKit = true;

    }








  }








  _ProductDetailsPageState(this.uid, this.productId);
  @override
  Widget build(BuildContext context) {
    return loading ? Loading():Scaffold(
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
        body:Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/2.3, // better for fixed size
                    width: double.infinity,
                    child: FutureBuilder(
                      future: decide(),
                      builder: (context,snapshot) {




                        return ListView.builder(
                            itemCount: int.parse(imgList[0]['NumberOfImages']),

                            scrollDirection: Axis.horizontal,


                            itemBuilder: (context,index){

                              return Container(
                                width: MediaQuery.of(context).size.width,


                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/facebook.jpg',
                                    image: imgList[0]['ShowcaseImage${index+1}'],
                                    width: MediaQuery.of(context).size.width,

                                    fit: BoxFit.fill
                                  ),
                                ),
                              );

                            });



                      },
                    ),
                  ),
                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 10,right: 0,bottom: 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                            child: Text(ds['Name'],
                            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          children: [
                            RatingBar.builder(
                              ignoreGestures: true,
                              itemSize: 15,
                              initialRating: double.parse(ds['Rating']),
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
                            Text("(${ds['NumberOfRatings']})")
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          width: MediaQuery.of(context).size.width/2,
                          child: Text(ds['ShortDescription'],
                          style: TextStyle(fontSize: 18),),
                        )),
                  ),
                  SizedBox(height: 15,),

                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Rs " + ds['Price'].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize:4.37 * SizeConfig.imageSizeMultiplier),),
                        SizedBox(width:4.86*SizeConfig.imageSizeMultiplier,),
                        Visibility(
                          visible: showOrignalPrice,
                          child: Text("Rs " + ds['OrignalPrice'].toString(),
                            style: TextStyle(fontSize: 4.2* SizeConfig.imageSizeMultiplier,decoration: TextDecoration.lineThrough),),
                        ),
                        SizedBox(width: 5.59*SizeConfig.imageSizeMultiplier),
                        Visibility(
                          visible: showOrignalPrice,
                          child: Text(ds['Discount'],
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 3.64 * SizeConfig.imageSizeMultiplier,color: Colors.teal),),
                        ),
                      ],
                    ),
                  ),


            VisibilityDetector(
                key: Key("unique key"),
                onVisibilityChanged: (VisibilityInfo info) {
                  debugPrint("${info.visibleFraction} of my widget is visible");

                  if(info.visibleFraction  == 0){
                    setState(() {
                      showBottomBuy = true;
                    });
                  }else{
                    setState(() {
                      showBottomBuy = false;
                    });
                  }
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.66*SizeConfig.heightMultiplier),


                              child: RaisedButton(

                                elevation: 5.0,
                                onPressed: () => print('Login Button Pressed'),
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.grey,
                                child: Text(
                                  'ADD TO CART',
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
                          SizedBox(width: 2.43 * SizeConfig.heightMultiplier,),
                          Expanded(
                            child: Container(

                              padding: EdgeInsets.symmetric(vertical: 1.66*SizeConfig.heightMultiplier),

                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () async{




                                  openCheckout();
                                  },
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Color.fromARGB(255, 167, 205, 57),
                                child: Text(
                                  'BUY NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontSize: 4.37 * SizeConfig.imageSizeMultiplier,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                      child: Container(
                        width: double.infinity,

                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () => print('Login Button Pressed'),
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color.fromARGB(255, 245, 167, 29),
                          child: Text(
                            'SUBSCRIBE',
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
            ),







                  SizedBox(height: 10,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("Categories :",
                            style: TextStyle(fontSize: 17,color: Colors.teal),)),
                      ),

                      InkWell(
                        onTap: (){
                          showInformationDialog(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Text(hasReviewed?"Update Your Review" : "Write a Review",
                            style: TextStyle(fontSize: 17,color: Colors.teal),),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: 14,
                        child: ListView.builder(

                          shrinkWrap: true,
                            scrollDirection: Axis.horizontal,

                            itemCount: categories.length,
                            itemBuilder: (context,index){

                              return Text(
                                categories[index] + ", "
                              );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  const Divider(
                    height: 20,
                    thickness: 0.5,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),

                  Visibility(
                    visible: showSpecs,
                    child: Column(
                      children: [

                        SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Specifications",
                                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                        ),
                        SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 120,
                              child: ListView.builder(

                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,

                                  itemCount: specsList.length,
                                  itemBuilder: (context,index){

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            child: Icon(Icons.add),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(specsList[index]['Name'].toString().replaceAll("\\n", "\n"),
                                            textAlign: TextAlign.center,),
                                          SizedBox(height: 5,),
                                          Text("(${specsList[index]['Quantity']})")

                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        const Divider(
                          height: 20,
                          thickness: 0.5,
                          indent: 15,
                          endIndent: 15,
                          color: Colors.black,
                        ),

                      ],
                    ),
                  ),

                  SizedBox(height: 15,),

                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Description",
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(height: 15,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ExpandableText(
                      ds['Description'],
                      expandText: 'View more',
                      collapseText: 'View less',
                      maxLines: 3,
                      linkColor: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 15,),
                  const Divider(
                    height: 20,
                    thickness: 0.5,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  SizedBox(height: 15,),

                  Visibility(
                    visible: showKit,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("Inside Kit",
                                style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                        ),
                        SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(

                              child: ListView.builder(

                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: insideKit.length,
                                  itemBuilder: (context,index){

                                    return ExpansionTile(title: Text(insideKit[index]['Title'],
                                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.teal),),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                          child: Text(insideKit[index]['Description']),
                                        )
                                      ],);
                                  }),
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        const Divider(
                          height: 20,
                          thickness: 0.5,
                          indent: 15,
                          endIndent: 15,
                          color: Colors.black,
                        ),






                      ],
                    ),
                  ),
                  SizedBox(height: 20,),

                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Reviews",
                          style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)),
                  ),
                  SizedBox(height: 30,),

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


                            itemCount: numReviewsShown,
                            itemBuilder: (context,index){


                              if(ds['Reviews'].length == 0){
                                noReviews = true;
                              }

                              if(ds['Reviews'].length <= 2){
                                numReviewsShown = ds['Reviews'].length;
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
                                            ds['Reviews'][index]['ReviewTitle'],
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
                                          initialRating: double.parse(ds['Reviews'][index]['ReviewRating']),
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
                                        "\" ${ds['Reviews'][index]['ReviewDesc']} \"",
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
                                          "By- ${ds['Reviews'][index]['ReviewerName']}\non ${ds['Reviews'][index]['ReviewingTime'].toString().substring(0,16)}"
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
                    visible: canShowMoreReviews,
                    child: FlatButton(onPressed: (){

                      if((numReviewsShown+2) >= ds['Reviews'].length){
                        numReviewsShown = ds['Reviews'].length;
                        canShowMoreReviews = false;

                      }else{
                        numReviewsShown += 2;
                      }



                    }, child: Text("click")),
                  )









                ],
              ),
            ),

            Visibility(
              visible: showBottomBuy,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.66*SizeConfig.heightMultiplier),


                              child: RaisedButton(

                                elevation: 5.0,
                                onPressed: () => print('Login Button Pressed'),
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Colors.grey,
                                child: Text(
                                  'ADD TO CART',
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
                          SizedBox(width: 2.43 * SizeConfig.heightMultiplier,),
                          Expanded(
                            child: Container(

                              padding: EdgeInsets.symmetric(vertical: 1.66*SizeConfig.heightMultiplier),

                              child: RaisedButton(
                                elevation: 5.0,
                                onPressed: () => print('Login Button Pressed'),
                                padding: EdgeInsets.all(15.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Color.fromARGB(255, 167, 205, 57),
                                child: Text(
                                  'BUY NOW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1.5,
                                    fontSize: 4.37 * SizeConfig.imageSizeMultiplier,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                      child: Container(
                        width: double.infinity,

                        child: RaisedButton(
                          elevation: 5.0,
                          onPressed: () => print('Login Button Pressed'),
                          padding: EdgeInsets.all(15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          color: Color.fromARGB(255, 245, 167, 29),
                          child: Text(
                            'SUBSCRIBE',
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
              ),
            ),



          ],
        ),

    );
  }
}

