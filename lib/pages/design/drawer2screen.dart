import 'package:flutter/material.dart';
import 'package:weincode_design_system/atoms/wc_text.dart';
import 'package:weincode_design_system/molecules/header.dart';
import 'package:weincode_design_system/tokens/colors.dart';

//TODO: Agregar al sistema de diseño
class Drawer2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Widget> drawerContent =  <Widget>[
      DrawerHeader(
      child: H1(text: 'Cabecera drawer', key: Key('hola'),),
      decoration: BoxDecoration(
        color: BRAND_PRIMARY,
      ),
      ),
      ListTile(
        title: Text('Item 1'),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      ListTile(
        title: Text('Item 2'),
        onTap: () {},
      ),
    ];
    return Scaffold(
      appBar: OurAppBar(title: 'Drawer',),
      body: Center(child: Text('My Page!')),
      //Drawer: cajon
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerContent,
        ),
      ),
    );
  }
}

