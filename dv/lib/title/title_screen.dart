import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ImageHoleAnimation(),
  ));
}

class ImageHoleAnimation extends StatefulWidget {
  @override
  ImageHoleAnimationState createState() => ImageHoleAnimationState();
}

class ImageHoleAnimationState extends State<ImageHoleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<double> _positionAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // 이미지 크기 변화 (구멍에서 점점 커지는 효과)
    _sizeAnimation = Tween<double>(begin: 0.0, end: 100.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 이미지 위치 변화 (구멍에서 위로 올라오는 효과)
    _positionAnimation = Tween<double>(begin: 150, end: 50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // 마지막에 살짝 위로 튀어오르는 효과
    _bounceAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // 애니메이션 실행
    Future.delayed(Duration(milliseconds: 500), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
        
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: Container(
                    width: 120,
                    height: 120,
                    color: Colors.black,
                    child: ShaderMask(shaderCallback: (bounds) {
                      return RadialGradient(colors: [Colors.transparent, Colors.black],
                        stops: [0.6, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstOut,),
                  ),
                ),
                // 이미지 애니메이션
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      top: _positionAnimation.value + _bounceAnimation.value, // 살짝 위로 튀는 효과 추가
                      child: Opacity(
                        opacity: _controller.value,
                        child: Image.asset(
                          'assets/title/logo.png', // 사용할 이미지 경로
                          width: _sizeAnimation.value,
                          height: _sizeAnimation.value,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          
        
      ),
    );
  }
}

