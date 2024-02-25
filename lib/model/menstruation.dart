import 'package:flutter/material.dart';
import '/model/custom_appbar.dart';

class PeriodCycleBlog extends StatelessWidget {
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
          child: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Understanding the Menstrual Cycle: A Comprehensive Guide',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Introduction:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The menstrual cycle is a natural process that occurs in the bodies of women of reproductive age. Understanding the menstrual cycle, including its phases and lengths, is crucial for women\'s health and reproductive planning.',
            ),
            SizedBox(height: 16.0),
            Text(
              'What is the Menstrual Cycle?',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'The menstrual cycle is a series of changes that occur in a woman\'s body roughly every 28 days, although it can vary from person to person. It is regulated by hormones and involves the shedding of the uterine lining if pregnancy does not occur.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Phases of the Menstrual Cycle:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '1. Menstrual Phase: This phase marks the beginning of the menstrual cycle, characterized by the shedding of the uterine lining. It typically lasts 3-7 days.',
            ),
            Text(
              '2. Follicular Phase: Following menstruation, the follicular phase begins, during which follicles in the ovaries mature in preparation for ovulation. This phase usually lasts about 7-10 days.',
            ),
            Text(
              '3. Ovulation: Ovulation is the release of a mature egg from the ovary, ready for fertilization. It usually occurs around the midpoint of the menstrual cycle, approximately 14 days before the start of the next period.',
            ),
            Text(
              '4. Luteal Phase: After ovulation, the luteal phase begins, during which the empty follicle transforms into a structure called the corpus luteum. This phase lasts about 10-14 days and ends with the start of menstruation if pregnancy does not occur.',
            ),
            SizedBox(height: 16.0),
            // Similar sections can be added for 'Understanding Ovulation', 'Signs of Ovulation', etc.
            Text(
              'Conclusion:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Understanding the menstrual cycle, including its phases, ovulation, and period length, is essential for women\'s health and well-being. By tracking their cycles and paying attention to any changes or abnormalities, women can better manage their reproductive health and make informed decisions about contraception, fertility, and overall wellness.',
            ),
            SizedBox(height: 16.0),
            Text(
              'Disclaimer:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'This blog post is intended for informational purposes only and should not be considered medical advice. Women experiencing irregularities or concerns regarding their menstrual cycles should consult with a healthcare professional for personalized guidance and support.',
            ),
          ],
        ),
      ),
          )));
  }
}

