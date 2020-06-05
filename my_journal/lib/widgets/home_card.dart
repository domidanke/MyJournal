import 'package:flutter/material.dart';
import 'package:my_journal/constants.dart';

class HomeCard extends StatelessWidget {
  const HomeCard(
      {this.headerText, this.image, this.text, this.icon, this.onTap});

  final AssetImage image;
  final String text;
  final Icon icon;
  final Function onTap;
  final String headerText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Material(
            //color: ,
            elevation: 10.0,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: Container(
              decoration: kCardDecoration,
              width: 300.0,
              height: 225.0,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 35.0,
                    child: Text(
                      headerText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: 150.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 30.0),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 15.0),
                          child: icon,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
