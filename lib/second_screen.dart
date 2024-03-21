import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class SecondScreen extends StatefulWidget {
  SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with TickerProviderStateMixin {
  List<String> images = [
    "assets/images/nun_background.jpg",
    "assets/images/poster_nun.jpg"
  ];

  bool b = true;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          setState(() {
            b = !b;
          });
        }),
        body: ColoredBox(
          color: Colors.white,
          child: FadeTransition(
            opacity: _animation,
            child:
                const Padding(padding: EdgeInsets.all(8), child: FlutterLogo()),
          ),
        )
        // LiquidSwipe(
        //     waveType: WaveType.circularReveal,
        //     initialPage: 0,
        //     pages: List.generate(
        //       2,
        //       (index) => Container(
        //         decoration: BoxDecoration(
        //             image: DecorationImage(
        //                 fit: BoxFit.cover, image: AssetImage(images[index]))),
        //       ),
        //     )),
        );
  }
}
