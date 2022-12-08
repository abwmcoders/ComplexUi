import 'package:flutter/material.dart';
import 'dart:math';

class HomeSCreen extends StatefulWidget {
  const HomeSCreen({Key? key}) : super(key: key);

  @override
  State<HomeSCreen> createState() => _HomeSCreenState();
}

class _HomeSCreenState extends State<HomeSCreen>
    with SingleTickerProviderStateMixin {
  double maxSlide = 225.0;
  late AnimationController animationController;
  late var _canDrag;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        animationController.isDismissed && details.globalPosition.dx < 250;
    bool isDragCloseFromRight =
        animationController.isCompleted && details.globalPosition.dx < 360;
    _canDrag = isDragCloseFromRight || isDragOpenFromLeft;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canDrag) {
      double delta = details.primaryDelta! / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
     if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;
      animationController.fling(velocity: visualVelocity);
    }
    else if(animationController.value < 0.5){

    }
    else{

    }
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    var myDrawer = Container(color: Colors.amber);
    var myWidget = Container(color: Colors.blue);
    return Stack(
      children: [
        myDrawer,
        GestureDetector(
          onHorizontalDragStart: _onDragStart,
          onHorizontalDragUpdate: _onDragUpdate,
          onHorizontalDragEnd: _onDragEnd,
          //onTap: toggle,
          child: AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset( maxSlide * (animationController.value), 0),
                child: Transform(
                  transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(-pi / 2 * (animationController.value)),
                  //..rotateY(-3.147 / 2 * animationController.value),
                  alignment: Alignment.centerLeft,
                  child: myWidget,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
