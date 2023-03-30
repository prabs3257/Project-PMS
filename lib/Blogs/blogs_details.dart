import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:project_pms/authentication/sign_in.dart';
import 'package:project_pms/shared/loading.dart';



class BlogsDetails extends StatefulWidget {

  final String blogId;

  const BlogsDetails({Key key, this.blogId}) : super(key: key);
  @override
  _BlogsDetailsState createState() => _BlogsDetailsState(blogId);
}

class _BlogsDetailsState extends State<BlogsDetails> {
  final String blogId;

  bool showText = true;
  bool showImage = true;

  DocumentSnapshot ds;

  String htmlOpeningString = "<!DOCTYPE html><html><body>";
  String htmlClosingString = "</body></html>";

  _BlogsDetailsState(this.blogId);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBlogDetails();
  }



  Future<void> getBlogDetails() async{


    setState(() {
      loading = true;
    });

    ds = await FirebaseFirestore.instance.collection('Blogs').doc(blogId).get();



    setState(() {
      loading = false;
    });


  }
  @override
  Widget build(BuildContext context) {
    return loading ? Loading(): Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [


            FadeInImage.assetNetwork(
              placeholder: 'assets/images/shop_banner.jpg',
              image: ds['BlogCoverImage'],

              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              fit: BoxFit.fill,

            ),




            Html(data: ds['BlogHtml']),

            /*
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),

                itemCount: ds['BlogBody'].length,
                itemBuilder: (context,index){
                  double Width = 300;
                  double titlePadding = 15.0;




                  if(ds['BlogBody'][index]['Image'] == "https://firebasestorage.googleapis.com/v0/b/project-pms-4770e.appspot.com/o/null_image_final.png?alt=media&token=2a5ebfd5-677d-42dc-8f3c-3bc172809e67"){
                    Width = 0;
                  }

                  if(ds['BlogBody'][index]['Title'] == ""){

                    titlePadding = 0;


                  }

                  return Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(titlePadding),
                        child: Align(
                          alignment:Alignment.centerLeft,
                          child: Text(ds['BlogBody'][index]['Title'],
                            style: TextStyle(
                                fontSize: 20,
                              fontWeight: FontWeight.w800
                            ),
                            textAlign: TextAlign.left,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Align(
                          alignment:Alignment.centerLeft,
                          child: Text(ds['BlogBody'][index]['Text'],
                          style: TextStyle(
                            fontSize: 18
                          ),
                          textAlign: TextAlign.justify,),
                        ),
                      ),
                      Image.network(ds['BlogBody'][index]['Image'].toString().replaceAll("\\n", "\n"),
                        width: Width,
                        fit: BoxFit.contain,
                      )
                    ],
                  );
            })

             */





          ],
        ),
      ),
    );
  }
}
