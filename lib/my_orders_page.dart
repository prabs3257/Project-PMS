import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shared/loading.dart';
class MyOrdersPage extends StatefulWidget {

  final String uid;

  const MyOrdersPage({Key key, this.uid}) : super(key: key);
  @override
  _MyOrdersPageState createState() => _MyOrdersPageState(uid);
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final String uid;

  DocumentSnapshot ds;

  _MyOrdersPageState(this.uid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getOrdersList();
  }

  void getOrdersList()async{

     ds = await FirebaseFirestore.instance.collection('userdata').doc(uid).get();
     setState(() {
       loading = false;
     });
  }
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
      body: ListView.builder(

          itemCount: ds['Orders'].length,
          itemBuilder: (context,index){



        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Order ID : " + ds['Orders'][index]['OrderId'].toString(),
                          style: TextStyle(color: Color.fromARGB(
                              255, 0, 173, 207),fontWeight: FontWeight.w900,fontSize: 16),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 5),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Items : ",
                        style: TextStyle(color: Color.fromARGB(
                            255, 0, 173, 207),fontWeight: FontWeight.w900,fontSize: 16),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("\u2022 "+ds['Orders'][index]['ItemName'],
                        style: TextStyle(fontWeight: FontWeight.w700,fontSize: 16),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Amount : "+ ds['Orders'][index]['ItemPrice'].toString(),
                          style: TextStyle(color: Color.fromARGB(
                              255, 0, 173, 207),fontWeight: FontWeight.w900,fontSize: 16),),
                        Text("Date : "+ ds['Orders'][index]['OrderingTime'].toString().substring(0,16),
                          style: TextStyle(color: Color.fromARGB(
                              255, 0, 173, 207),fontWeight: FontWeight.w900,fontSize: 16),),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 0.66*SizeConfig.heightMultiplier),


                            child: RaisedButton(

                              elevation: 5.0,
                              onPressed: () => print('Login Button Pressed'),
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color.fromARGB(
                                  255, 0, 173, 207),
                              child: Text(
                                'VIEW DETAILS',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize:3.37 * SizeConfig.imageSizeMultiplier,
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

                                await FirebaseFirestore.instance.collection('users').doc(uid).update({
                                  'Orders':FieldValue.arrayRemove([ds['Orders'][index]])
                                });

                                setState(() {
                                  getOrdersList();
                                });
                              },
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: Color.fromARGB(255, 245, 167, 29),
                              child: Text(
                                'TRACK',
                                style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  fontSize: 3.37 * SizeConfig.imageSizeMultiplier,
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

                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
