import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:project_pms/save_config.dart';

class ThankYouPage extends StatefulWidget {

  final String uid;

  const ThankYouPage({Key key, this.uid}) : super(key: key);
  @override
  _ThankYouPageState createState() => _ThankYouPageState(uid);
}

class _ThankYouPageState extends State<ThankYouPage> {

  final String uid;
  ConfettiController _controllerCenter;

  _ThankYouPageState(this.uid);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 1));

    Timer _timer = Timer(Duration(milliseconds: 500), ()  {
      setState(() {
        _controllerCenter.play();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerCenter.dispose();
  }


  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:  3.64*SizeConfig.imageSizeMultiplier),
                  child: Container(
                    child: CircleAvatar(backgroundImage: AssetImage("assets/images/emojitwo.png"),
                      radius: 9.08*SizeConfig.imageSizeMultiplier,backgroundColor: Colors.yellow,),
                  ),
                ),
                    SizedBox(height: 20,),
                    Text("Thank You !!\nYour Order has been placed",style: TextStyle(color: Color.fromARGB(
                    255, 0, 173, 207),fontWeight: FontWeight.bold,fontSize: 24,),textAlign: TextAlign.center,),
                  ],
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirection: pi/3.5, // radial value - LEFT
              particleDrag: 0.02, // apply drag to the confetti
              emissionFrequency: 0.08, // how often it should emit
              numberOfParticles: 20, // number of particles to emit
              gravity: 0.05, // gravity - or fall speed
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink
              ], // manually specify the colors to be used
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirection: pi/1.5, // radial value - LEFT
              particleDrag: 0.02, // apply drag to the confetti
              emissionFrequency: 0.08, // how often it should emit
              numberOfParticles: 20, // number of particles to emit
              gravity: 0.05, // gravity - or fall speed
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink
              ], // manually specify the colors to be used
            ),
          ),
        ],
      ),
    );
  }
}
