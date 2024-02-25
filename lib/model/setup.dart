import 'package:flutter/material.dart';
import '/main.dart';

class SetupAnimationScreen extends StatefulWidget {
  @override
  _SetupAnimationScreenState createState() => _SetupAnimationScreenState();
}

class _SetupAnimationScreenState extends State<SetupAnimationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5), // Adjust duration as needed
    );

    _sizeAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true); // Repeat the animation continuously

    _controller.forward().whenComplete(() {
      // Navigation to home screen when animation completes
     Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) =>
                            MainScreen(), // Replace with the next screen
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
       extendBodyBehindAppBar: true,
      appBar: AppBar(
       backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      body: Container(
  height: mediaQuery.height,
          width: mediaQuery.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
            ),
          ),
        child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return ScaleTransition(
              scale: _sizeAnimation,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    foregroundPainter: CircleProgressPainter(
                      currentProgress: _controller.value,
                    ),
                    child: Container(
                      width: 200,
                      height: 200,
                    ),
                  ),
                  ProgressPercentageWidget(
                    percentage: _controller.value,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      )
    );
  }
}

class CircleProgressPainter extends CustomPainter {
  double currentProgress;

  CircleProgressPainter({required this.currentProgress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint outerCircle = Paint()
      ..strokeWidth = 40
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    double progress = currentProgress * 360;

    Paint completeArc = Paint()
      ..strokeWidth = 40
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          Colors.blue,
          Colors.lightBlue, // Intermediate color between blue and orange
          Colors.orange, // Start of orange color
          Colors.yellow,
          Colors.green,
          Colors.lightGreen, // Intermediate color between green and blue
          Colors.blue, // Back to blue color
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2,
        ),
      );

    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = size.width / 2;

    canvas.drawCircle(center, radius, outerCircle);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -90 * (3.14 / 180), progress * (3.14 / 180), false, completeArc);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ProgressPercentageWidget extends StatelessWidget {
  final double percentage;

  ProgressPercentageWidget({required this.percentage});

  @override
  Widget build(BuildContext context) {
    String message;
    if (percentage < 0.25) {
      message = 'Initializing...';
    } else if (percentage < 0.5) {
      message = 'Fetching data...';
    } else if (percentage < 0.75) {
      message = 'Processing...';
    } else {
      message = 'Almost there...';
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(percentage * 100).toInt()}%',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
