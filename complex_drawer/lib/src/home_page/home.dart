import 'package:complex_drawer/main.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  final double maxSLide = 225.0;
  var _canBeDragged;

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft =
        animationController.isDismissed && details.globalPosition.dx < 250;
    bool isDragCloseFromRight =
        animationController.isCompleted && details.globalPosition.dx < 360;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSLide;
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
    } else if (animationController.value < 0.5) {
      //close();
    } else {
      //open();
    }
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 250,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      // onTap: toggle,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            double slide = maxSLide * animationController.value;
            double scale = 1 - (animationController.value * 0.3);
            return Stack(
              children: [
                Drawer(),
                Transform(
                  transform: Matrix4.identity()
                    ..translate(slide)
                    ..scale(scale),
                  alignment: Alignment.centerLeft,
                  child: Material(
                    child: Scaffold(
                      backgroundColor: Colors.amber,
                      appBar: AppBar(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        leading: IconButton(
                            onPressed: toggle, icon: const Icon(Icons.menu)),
                      ),
                      body: widget.child,
                      floatingActionButton: FloatingActionButton(
                        onPressed: _incrementCounter,
                        tooltip: 'Increment',
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

class DashBody extends StatelessWidget {
  const DashBody({
    Key? key,
    required int counter,
  })  : _counter = counter,
        super(key: key);

  final int _counter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
      ),
    );
  }
}

class Drawer extends StatelessWidget {
   Drawer({Key? key}) : super(key: key);

  int counter = 2;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flutter\nDeveloper',
                  style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const MyHomePage(title: 'MY new screen'),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.not_started),
                    title: Text('Start'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewHome(),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.not_started),
                    title: Text('Start'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dashboard(child: DashBody(counter: counter,)),
                      ),
                    );
                  },
                  child: const ListTile(
                    leading: Icon(Icons.not_started),
                    title: Text('Start'),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.not_started),
                  title: Text('Start'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewHome extends StatelessWidget {
  const NewHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dashboard(
        child: Container(
      color: Colors.purple,
    ));
  }
}
