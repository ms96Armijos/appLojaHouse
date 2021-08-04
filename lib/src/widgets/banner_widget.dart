import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BannerWidget extends StatelessWidget {

  String valor='';
  BannerWidget({@required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                FadeInImage(
            placeholder: AssetImage('assets/img/lhb.png'),
            image: AssetImage('assets/img/lhb.png'),
            fadeInDuration: Duration(milliseconds: 200),
            height: 60.0,
            fit: BoxFit.cover,
          ),
          FadeInImage(
            placeholder: AssetImage('assets/img/lhtextow.png'),
            image: AssetImage('assets/img/lhtextow.png'),
            fadeInDuration: Duration(milliseconds: 200),
            height: 25.0,
            fit: BoxFit.cover,
          ),
                //SvgPicture.asset('assets/icons/lhb.svg', width: 110, height: 110,),
                SizedBox(
                  height: 5.0,
                  width: double.infinity,
                ),
                Text(valor,
                    style: TextStyle(color: Colors.white60, fontSize: 30.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center,)
              ],
            ),
          ),
        );
  }
}