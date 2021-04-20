import 'package:flutter/material.dart';
class Page1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        ),
      ),
    );
  }
}
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Page2(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      //Devuelve un vector con los valores de la transición
      //Tween --> interpolar
      // https://api.flutter.dev/flutter/animation/Cubic-class.html

      var curve = Curves.ease;
      var curveTween = CurveTween(curve: curve);
      var curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      var tween = Tween(begin: begin, end: end).chain(curveTween);
      print(curveTween);
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );

    },
  );

}
class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Page 2'),
      ),
    );
  }
}