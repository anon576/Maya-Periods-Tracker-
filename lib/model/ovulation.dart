import 'package:flutter/material.dart';
import '/model/custom_appbar.dart';


class OvulationInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
       extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
         
        ),
      body: Center(
          child:  Container(
            padding: EdgeInsets.fromLTRB(20, 150, 20, 0),
          height: mediaQuery.height,
          width: mediaQuery.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ovulation Information',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Ovulation typically occurs around halfway through your menstrual cycle. '
                'It is the release of an egg from the ovary into the fallopian tube, '
                'where it can be fertilized by sperm. Ovulation is a key event in the '
                'menstrual cycle for women trying to conceive.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Signs of Ovulation:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '- Increase in basal body temperature\n'
                '- Changes in cervical mucus\n'
                '- Abdominal pain or cramping\n'
                '- Heightened sense of smell\n'
                '- Changes in libido',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Remember, everyone’s body is different, and not all women will '
                'experience these signs. If you are trying to conceive, consider '
                'tracking your menstrual cycle and monitoring these signs to identify '
                'your most fertile days.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
