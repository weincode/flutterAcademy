import 'package:flutter/material.dart';
import 'package:weincode_design_system/molecules/header.dart';
import 'package:flutter/physics.dart';

class PhysicsCardDragDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OurAppBar(title: 'Simulando física',),
      body: DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;
  DraggableCard({required this.child});

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>  with SingleTickerProviderStateMixin {
  //Single Ticker te provee un ticker sencillo cuando el arbol esta animado
  //El ticker un Callback por frame de la animación
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  @override
  void initState() {
    super.initState();
    //DEFINE CONTRALADOR CON 1 SEGUNDO DE ANIMACIÓN
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    //Agrega elemento de escucha
    _controller.addListener(() {
      setState(() {
        //Valor del porcentaje del avance de la animación
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //toma tamaño del widget
    var size = MediaQuery.of(context).size;
    return GestureDetector(
              onPanDown: (details) {
                _controller.stop();
              },
              onPanUpdate: (details) {
                setState(() {
                  _dragAlignment += Alignment(
                    details.delta.dx / (size.width / 2),
                    details.delta.dy / (size.height / 2),
                  );
                });
              },
              onPanEnd: (details) {
                _runAnimation(details.velocity.pixelsPerSecond, size);
              },
              child: Align(
                alignment: _dragAlignment,
                child: Card(
                  child: widget.child,
                ),
              ),
            );
    }

/*
    Animation<Alignment> _animation;
    void _runAnimation(Offset pixelsPerSecond, Size size) {
      //ENCADENA ANIMACION DE REGRESO
      _animation = _controller.drive(
          AlignmentTween(
            begin: _dragAlignment,
            end: Alignment.center,
          )
      );
      //DETIENE ACTUAL
      _controller.reset();
      //EJECUTA LA SIGUIENTE
      _controller.forward();
    }
    */
    late Animation<Alignment> _animation;
    void _runAnimation(Offset pixelsPerSecond, Size size) {
      _animation = _controller.drive(
        AlignmentTween(
          begin: _dragAlignment,
          end: Alignment.center,
        ),
      );
      // Calculate the velocity relative to the unit interval, [0,1],
      // used by the animation controller.
      final unitsPerSecondX = pixelsPerSecond.dx / size.width;
      final unitsPerSecondY = pixelsPerSecond.dy / size.height;
      final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
      final unitVelocity = unitsPerSecond.distance;
      //propiedades físicas del objeto
      const spring = SpringDescription(
        mass: 100,
        stiffness: 1,
        //estabilización
        damping: 1,
      );

      final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

      _controller.animateWith(simulation);
    }
  }