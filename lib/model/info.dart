import 'package:flutter/material.dart';
import '/model/custom_appbar.dart';

class PeriodDetailsBlogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
     appBar: CustomAppBar(),
      body:Container( 
        padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
 height: mediaQuery.height,
          width: mediaQuery.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFCE5E7), Color(0xFFC6E2FF)], // Gradient colors
            ),
          ),
        child:  ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle('Introduction'),
          _buildParagraph(
              'Understanding the details of your menstrual cycle is crucial for maintaining good reproductive health. One aspect of this understanding is tracking and analyzing your periods. In this blog post, we\'ll discuss how you can use a Flutter app to delve into the details of your periods.'),
          _buildSectionTitle('Exploring Period Details'),
          _buildParagraph(
              'When it comes to period tracking, it\'s not just about marking the start and end dates. It\'s also essential to note the intensity of flow, any associated symptoms, and personal observations. Let\'s explore how a Flutter app can help you keep track of these details.'),
          _buildSectionTitle('Creating the Period Details Screen'),
          _buildParagraph(
              'The Period Details screen in our Flutter app displays comprehensive information about a specific period. The screen is divided into sections, each focusing on different aspects of the menstrual cycle:'),
          _buildNumberedListItem(
              'Period Start Date', 'Displays the date when the period began.'),
          _buildNumberedListItem(
              'Period End Date', 'Shows the date when the period ended.'),
          _buildNumberedListItem(
              'Flow Intensity',
              'Indicates the intensity of menstrual flow, whether light, moderate, or heavy.'),
          _buildNumberedListItem(
              'Symptoms',
              'Lists any symptoms experienced during the period, such as cramps, fatigue, mood swings, etc.'),
          _buildNumberedListItem(
              'Notes',
              'Provides space for additional notes or reminders, such as medication instructions or observations about the cycle.'),
          _buildSectionTitle('Why Track Period Details?'),
          _buildParagraph(
              'Tracking period details offers several benefits:'),
          _buildNumberedListItem(
              'Health Monitoring',
              'By noting changes in flow intensity and associated symptoms, individuals can monitor their reproductive health and identify any irregularities.'),
          _buildNumberedListItem(
              'Personalized Care',
              'Understanding one\'s menstrual patterns allows for personalized healthcare, such as adjusting medication or lifestyle habits to manage symptoms effectively.'),
          _buildNumberedListItem(
              'Fertility Awareness',
              'Tracking period details can also aid in fertility awareness, helping individuals identify their most fertile days for family planning purposes.'),
          _buildSectionTitle('Conclusion'),
          _buildParagraph(
              'Incorporating period tracking into your health routine provides valuable insights into your reproductive health. With the Period Details screen in our Flutter app, users can delve into the intricacies of their menstrual cycles, empowering them to make informed decisions about their well-being.'),
          _buildParagraph(
              'Take control of your reproductive health journey by leveraging technology to track and analyze your periods. With the Period Details screen in our Flutter app, you can gain a deeper understanding of your menstrual cycle and take proactive steps towards better health. Download our app and start tracking your period details today!'),
        ],
      ),
      )
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildNumberedListItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

