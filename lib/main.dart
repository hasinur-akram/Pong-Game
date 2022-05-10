import 'package:flutter/material.dart';
import 'dart:math';

main()=>runApp(PongGameApp());

class PongGameApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PongGame(),
      debugShowCheckedModeBanner: false,
    );
  }
}

enum Direction{
  up,
  down,
  left,
  right,
}

class PongGame extends StatefulWidget {
  @override
  _PongGameState createState() => _PongGameState();
}

class _PongGameState extends State<PongGame> with SingleTickerProviderStateMixin{
  Direction vDir=Direction.up;
  Direction hDir=Direction.right;
  late double height;
  late double width;
  late double batHeight;
  late double batWidth;
  late double ballPosX;
  late double ballPosY;
  late double batPosition;
  late AnimationController _animationController;
  late Animation _animation;
  double randX = 1;
  double randY = 1;
  double speed = 7;
  late int score ;

  double randNumber(){
    Random ran = Random();
    int myNum = ran.nextInt(101);
    return (50+myNum)/100;
  }
  safeSetState(Function function) {
    if (mounted && _animationController.isAnimating) {
      setState(() {
        function();
      });
    }
  }
  Future message(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Container(
          height: 150,
          child: Column(
            children: [
              Text('Your Score : $score'),
              Text('Would you like to play again?')
            ],
          ),
        ),
        title: Text('Game Over'),
        actions: [
          TextButton(onPressed: (){
            setState(() {
              score = 0;
              randX = 1;
              randY = 1;
              score=0;
              ballPosX = 40;
              ballPosY = 40;
              batPosition = 40;
              vDir = Direction.up;
              hDir = Direction.right;
              _animationController.repeat();
              Navigator.of(context).pop();
            });
          },
          child: Text('Yes')),
          TextButton(onPressed: () {}, child: Text('NO')),
        ],
      );
    });
  }
  void checkBorder(){
    if (vDir==Direction.up && ballPosY >= height-30) {
      vDir = Direction.down;
      randY=randNumber();
    }
    if (vDir==Direction.down && ballPosY <= 0 + batHeight) {
      if (ballPosX > batPosition -15 &&
          ballPosX < batPosition + batWidth -15){
        vDir = Direction.up;
        score++;
      }else{
          message(context);
          _animationController.stop();
        }

      }

    if (hDir == Direction.right && ballPosX >= width - 30) {
      hDir = Direction.left;
      randX=randNumber();
    }
    if (hDir == Direction.left && ballPosX < 0) {
      hDir = Direction.right;
      randY=randNumber();
    }
  }

  @override
  void initState() {
    setState(() {
      score=0;
      ballPosX = 40;
      ballPosY = 40;
      batPosition = 40;
    });
    score=0;
    ballPosX = 40;
    ballPosY = 40;
    batPosition = 40;
    _animationController =
        AnimationController(vsync: this,duration: Duration(minutes: 10000));
    _animation = Tween(begin: 0, end: 100).animate(_animationController);

    _animation.addListener(() {
      safeSetState(() {
        vDir == Direction.up
            ? ballPosY += speed*randY
            : ballPosY -= speed*randY;
        hDir == Direction.right
            ? ballPosX += speed*randX
            : ballPosX -= speed*randX;
        checkBorder();
      });
    });
    _animationController.forward();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        height=constraints.maxHeight;
        width=constraints.maxWidth;
        batHeight=height/25;
        batWidth=width/6;
          return GestureDetector(
            onHorizontalDragUpdate: (update) {
              safeSetState(() {
                batPosition += update.delta.dx;
              });
            },
            child: Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    top: 40,
                      right: 40,
                      child: Text('Score : $score')
                  ),
                  Positioned(
                    bottom: ballPosY,
                    left: ballPosX,
                    child: Ball(),
                  ),
                  Positioned(
                    bottom: 0,
                      left: batPosition,
                      child: Bat(batHeight: batHeight, batWidth: batWidth),
                  ),
                  Container()
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
}

class Bat extends StatelessWidget {
  const Bat({
    Key? key,
    required this.batHeight,
    required this.batWidth,
  }) : super(key: key);

  final double batHeight;
  final double batWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
                  height: batHeight,
                  width: batWidth,
                  color: Colors.deepOrange,
                );
  }
}

class Ball extends StatelessWidget {
  const Ball({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.purple
      ),
    );
  }
}