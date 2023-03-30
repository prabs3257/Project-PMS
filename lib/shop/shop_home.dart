
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_pms/Blogs/blogs_list.dart';
import 'package:project_pms/Forum/forum_home.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/hidden_drawer/drawer.dart';
import 'package:project_pms/home_page.dart';
import 'package:project_pms/map/map_screen.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
import 'package:project_pms/shop/product_details.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class ShopHome extends DrawerContent {

  final String uid;


  ShopHome({Key key, this.uid, String title});

  @override
  _ShopHomeState createState() => _ShopHomeState(uid);
}

class _ShopHomeState extends State<ShopHome> {

  final String uid;
  List itemList = [];
  int cartNum = 0;
  String title;

  DocumentSnapshot ds;

  Razorpay razorpay;

  _ShopHomeState(this.uid);

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

    getProductsList();
    getCart();

    razorpay = new Razorpay();

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlerPaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlerErrorFailure);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handlerExternalWallet);


  }




  void handlerPaymentSuccess(){
    print("Pament success");

  }

  void handlerErrorFailure(){
    print("Pament error");

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
        "contact" : "",
        "email" : ""
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





  Future<void> getProductsList() async {

    ds = await FirebaseFirestore.instance.collection('ShowcaseImages').doc('PromoBanner').get();




    await FirebaseFirestore.instance.collection('Products').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {

          itemList.add(doc);
        });

       // print(value['Name']);
      });
    });
    setState(() {
      loading = false;
    });



  }



  void getCart() async{

    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('Carts').doc(uid).get();


    try{
      setState(() {
        cartNum = ds['NumberOfItems'];

      });

    }catch(e){
      cartNum = 0;
    }

  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
        appBar: AppBar(
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
        body: SingleChildScrollView(
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
                        "Stree Sanman Shop",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                        fontSize: 3.22*SizeConfig.textMultiplier),

                      ),
                    ),
                  ),

                  Container(
                      width: double.infinity,
                      height: 8.78 * SizeConfig.heightMultiplier,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_sharp,size: 35,color: Colors.white,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )

                        ),
                      )
                  ),
                ],
              ),

              Container(

                child: FadeInImage.assetNetwork(

                  width: MediaQuery.of(context).size.width,
                  placeholder: 'assets/images/shop_banner.jpg',
                  image: ds['PromoBannerImage'],
                )
              ),
              SizedBox(height: 0.73 * SizeConfig.heightMultiplier,),

              ListView.builder(
                itemCount: itemList.length,

                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),

                  itemBuilder: (context,index){

                  bool showOrignalPrice = false;

                  if(itemList[index]['onSale'] == true){
                    showOrignalPrice = true;
                  }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async{



                          setState(() {
                            loading = true;
                          });


                          await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductDetailsPage(uid : uid, productId: itemList[index].id)));


                          setState(() {
                            loading = false;
                          });


                        },
                        child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        children: [

                                          FadeInImage.assetNetwork(
                                            placeholder: 'assets/images/facebook.jpg',
                                            image: itemList[index]['Picture'],
                                            width: 34*SizeConfig.imageSizeMultiplier,
                                            height: 16.10*SizeConfig.heightMultiplier,

                                          ),
                                          Container(
                                            width: 34*SizeConfig.imageSizeMultiplier,
                                            height: 16.10*SizeConfig.heightMultiplier,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.all(Radius.circular(20.0)),

                                            ),
                                          ),


                                        ],
                                      ),


                                      SizedBox(width: 4.86*SizeConfig.imageSizeMultiplier,),
                                      Container(
                                        width: 48.66 * SizeConfig.imageSizeMultiplier,
                                        child: Column(

                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Text(itemList[index]['Name'],
                                            style: TextStyle(fontSize: 3.22 * SizeConfig.heightMultiplier,fontWeight: FontWeight.bold),),
                                            Text(itemList[index]['ShortDescription']),
                                            SizedBox(height: 1.46 * SizeConfig.heightMultiplier,),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text("Rs " + itemList[index]['Price'].toString(),
                                                style: TextStyle(fontWeight: FontWeight.bold,fontSize:4.37 * SizeConfig.imageSizeMultiplier),),
                                                SizedBox(width: 2.43 * SizeConfig.imageSizeMultiplier,),
                                                Visibility(
                                                  visible: showOrignalPrice,
                                                  child: Text("Rs " + itemList[index]['OrignalPrice'].toString(),
                                                    style: TextStyle(fontSize: 3.64 * SizeConfig.imageSizeMultiplier,decoration: TextDecoration.lineThrough),),
                                                ),
                                                SizedBox(width: 1.21 * SizeConfig.imageSizeMultiplier,),
                                                Visibility(
                                                  visible: showOrignalPrice,
                                                  child: Text(itemList[index]['Discount'],
                                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 3.64 * SizeConfig.imageSizeMultiplier,color: Colors.teal),),
                                                ),
                                              ],
                                            ),
                                        SizedBox(height: 0.73*SizeConfig.heightMultiplier,),

                                        Row(
                                          children: [
                                            RatingBar.builder(
                                              ignoreGestures: true,
                                              itemSize: 15,
                                              initialRating: double.parse(itemList[index]['Rating']),
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
                                            Text("(${itemList[index]['NumberOfRatings']})"),


                                          ],
                                        ),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 3.66*SizeConfig.heightMultiplier),


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

                                          padding: EdgeInsets.symmetric(vertical: 3.66*SizeConfig.heightMultiplier),

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
                                  const Divider(
                                    height: 20,
                                    thickness: 0.5,
                                    indent: 10,
                                    endIndent: 10,
                                    color: Colors.black,
                                  ),


                                ],
                              ),

                            ),
                          ),
                      ),

                    );

              }),
            ],
          ),
        ),

    );
  }
}



class MainWidgetShop extends StatefulWidget {
  MainWidgetShop({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;

  @override
  _MainWidgetShopState createState() => _MainWidgetShopState(uid);
}

class _MainWidgetShopState extends State<MainWidgetShop> with TickerProviderStateMixin {
  HiddenDrawerController _drawerController;
  final String uid;

  _MainWidgetShopState(this.uid);

  @override
  void initState() {
    super.initState();
    _drawerController = HiddenDrawerController(
      initialPage: ShopHome(
        title: "shop",
        uid: uid,
      ),

      items: [
        DrawerItem(
          text: Text('Home', style: TextStyle(color: Colors.white)),
          icon: Icon(FontAwesomeIcons.home, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier,),
          page: ShopHome(
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

          icon: Icon(FontAwesomeIcons.store, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: ShopHome(
            title: 'Shop',
          ),
        ),
        DrawerItem(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => MainWidgetBlogs(uid : uid)));

          },
          text: Text(
            'Blogs',
            style: TextStyle(color: Colors.white),
          ),
          icon: Icon(FontAwesomeIcons.newspaper, color: Colors.white,size: 6.69*SizeConfig.imageSizeMultiplier),
          page: ShopHome(
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
          page: ShopHome(
            title: 'Forum',
          ),
        ),
        DrawerItem(
          text: Text(
            'Maps',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () async{

            setState(() {
              loading = true;
            });
            await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainWidgetMap(uid : uid)));


            setState(() {
              loading = false;
            });

          },
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

