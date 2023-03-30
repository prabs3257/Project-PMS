import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_pms/save_config.dart';
import 'package:project_pms/shop/add_details.dart';



class SelectLocation extends StatefulWidget {

  final String type;
  final String uid;

  const SelectLocation({Key key, this.type, this.uid}) : super(key: key);
  @override
  _SelectLocationState createState() => _SelectLocationState(type,uid);
}

class _SelectLocationState extends State<SelectLocation> {

  final String type;
  final String uid;
  bool showButton = false;

  LatLng SelectedLocation;
  Set<Marker> _tappedMarkers = {};

  _SelectLocationState(this.type, this.uid);

  void _HandleTap(LatLng TappedPoint){


    if(_tappedMarkers.isEmpty){

      setState(() {
        _tappedMarkers.add(
            Marker(
              markerId: MarkerId("1"),
              position: TappedPoint,

            )
        );

      });
      showButton = true;
      SelectedLocation = TappedPoint;

    }else{
      print("already selected");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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

      body: Stack(
          children: [


            GoogleMap(
              initialCameraPosition: CameraPosition(target: LatLng(28.5723921,77.0449214),
                  zoom: 15),
              myLocationEnabled: true,
              onTap: _HandleTap,
              markers: _tappedMarkers,
              myLocationButtonEnabled: true,

            ),
            Stack(
              children: [
                Container(
                  color: Color.fromARGB(255, 0, 173, 207),
                  width: double.infinity,
                  height: 8.78 * SizeConfig.heightMultiplier,
                  child: Center(
                    child: Text(
                      "Choose a Location",
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                          fontSize: 3.22*SizeConfig.textMultiplier),

                    ),
                  ),
                ),


              ],
            ),



          ]
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
            child: Visibility(
              visible: showButton,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => AddDetails(uid: uid,type: type,location: SelectedLocation,)));

                },
                label: const Text('Select'),
                icon: const Icon(Icons.thumb_up),
                backgroundColor: Color.fromARGB(
                    255, 0, 173, 207),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
