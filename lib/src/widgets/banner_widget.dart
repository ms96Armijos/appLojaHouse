import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BannerWidget extends StatelessWidget {

  String valor='';
  BannerWidget({@required this.valor});

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                SvgPicture.asset('assets/icons/casa.svg', width: 110, height: 110,),
                SizedBox(
                  height: 10.0,
                  width: double.infinity,
                ),
                Text(valor,
                    style: TextStyle(color: Colors.white60, fontSize: 30.0, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        );
  }
}