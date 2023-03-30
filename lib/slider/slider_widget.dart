import 'package:flutter/material.dart';
import 'custom_slider_thumb_rect.dart';

class SliderWidget extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  final double value;

  SliderWidget(
      {this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false, this.value});

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _value = 0;

  double value = 0.4;


  double getValue(){

    return _value;
  }

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .3)),
        ),

      ),
      child: Row(
        children: <Widget>[


          Expanded(
            child: Center(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.grey.withOpacity(0.4),
                  inactiveTrackColor: Colors.grey.withOpacity(0.4),

                  trackHeight: 4.0,
                  thumbShape: CustomSliderThumbCircle(
                    thumbRadius: this.widget.sliderHeight * .4,
                    min: this.widget.min,
                    max: this.widget.max,
                  ),
                  overlayColor: Colors.white.withOpacity(.4),
                  //valueIndicatorColor: Colors.white,
                  activeTickMarkColor: Colors.white,
                  inactiveTickMarkColor: Colors.red.withOpacity(.7),
                ),
                child: Slider(
                    value: value,
                    onChanged: (value) {
                      setState(() {
                        value = value;
                      });
                    }),
              ),
            ),
          ),


        ],
      ),
    );
  }
}