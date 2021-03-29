import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget> [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Row(
              children:<Widget> [
                Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage('https://cdn.pixabay.com/photo/2017/01/31/21/23/avatar-2027366_1280.png'),
                      fit: BoxFit.fill,
                    ),
                  ),

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Text('name'),
                        Text('yoldız'),
                        Text('urun'),
                      ],
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