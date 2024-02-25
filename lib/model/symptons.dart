import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import '/model/custom_appbar.dart';
import '../apis/home_api.dart';

class Symptons extends StatefulWidget {
  final DateTime selectedDate;

  const Symptons({Key? key, required this.selectedDate}) : super(key: key);
  @override
  State<Symptons> createState() => _SymptonsState();
}

class _SymptonsState extends State<Symptons> {
  @override
  void initState() {
    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    var t = DateTime.now();
     final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
       extendBodyBehindAppBar: true,
        appBar: CustomAppBar(
        
        ),
       body: Container(
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
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Text(
                      DateFormat('MMMMd').format(t),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 10, 0),
                      child: Text(
                        "Cycle day , 23",
                        style: TextStyle(color: Colors.red[400]),
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: const Text(
                            "Menstruation Flow",
                            // style: TextStyle(color: Colors.red[400]),
                          )),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/light.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                        buttonText: 'Light - Try heating pad.',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Light',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/medium.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                         buttonText: 'Medium - Take pain relievers', 
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Medium',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/heavy.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                        buttonText: 'Heavy - Consider consulting doctor',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Heavy',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/spotting.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                      buttonText: 'Spotting - Monitor for changes',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Spotting',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                              child: const Text(
                            "Moods",
                            // style: TextStyle(color: Colors.red[400]),
                          )),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset: ('lib/icon/calm.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 16, 234, 241),
                                        buttonText: 'Calm',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Calm',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/happy.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 16, 234, 241),
                                        buttonText: 'Happy',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Happy',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset: ('lib/icon/sad.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 16, 234, 241),
                                        buttonText: 'Sad - Try relaxation techniques', 
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Sad',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                              child: const Text(
                            "Symptoms",
                            // style: TextStyle(color: Colors.red[400]),
                          )),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset: ('lib/icon/ok.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 230, 135, 133),
                                        buttonText: 'Ok - Stay hydrated', 
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/cramps.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 230, 135, 133),
                                         buttonText: 'Cramps - Apply heat pad', 
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Cramps',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset: ('lib/icon/acne.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 230, 135, 133),
                                        buttonText: 'Acne - Gentle skincare',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Acne',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/fatigue.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 230, 135, 133),
                                         buttonText: 'Fatigue - Get enough rest', 
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Fatigue',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                              child: const Text(
                            "Sex",
                            // style: TextStyle(color: Colors.red[400]),
                          )),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/no-sex.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 240, 66, 231),
                                        buttonText: 'No Sex',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'No Sex',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/protectedsex.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 240, 66, 231),
                                        buttonText: 'Proteced Sex',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Proteced Sex',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/unpresex.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 240, 66, 231),
                                        buttonText: 'Unpre Sex',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Unpre Sex',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                              child: const Text(
                            "Vaginal discharge",
                            // style: TextStyle(color: Colors.red[400]),
                          )),
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/light.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                        buttonText: 'Click Me',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Light',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/medium.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                        buttonText: 'Click Me',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Medium',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/heavy.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                        buttonText: 'Click Me',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Heavy',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 17, 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ColorfulButton(
                                        initialIconAsset:
                                            ('lib/icon/spotting.png'),
                                        initialButtonColor:
                                            const Color.fromARGB(
                                                255, 228, 83, 81),
                                        buttonText: 'Click Me',
                                        selectedDate: widget.selectedDate,
                                      ),
                                      const SizedBox(height: 5),
                                      const Text(
                                        'Spotting',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ]),
          ),
        ],
      ),
      
    ));
  }
}

class ColorfulButton extends StatefulWidget {
  final String initialIconAsset;
  final Color initialButtonColor;
  final String buttonText;
  final DateTime selectedDate; // Add this line

  const ColorfulButton({
    Key? key,
    required this.initialIconAsset,
    required this.initialButtonColor,
    required this.buttonText,
    required this.selectedDate, // Add this line
  }) : super(key: key);

  @override
  _ColorfulButtonState createState() => _ColorfulButtonState();
}

class _ColorfulButtonState extends State<ColorfulButton> {
  bool isButtonColored = false;

  Future<void> createSymptons() async {

    await HomeApi.createSymptons(widget.selectedDate, widget.buttonText);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
         setState(() {
          isButtonColored = !isButtonColored;
        });
        createSymptons();

       
      },
      child: Container(
        width: 50, // Adjust the width based on your needs
        height: 50, // Adjust the height based on your needs
        decoration: BoxDecoration(
          color:
              isButtonColored ? widget.initialButtonColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: isButtonColored
                ? Colors.transparent
                : widget.initialButtonColor,
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.initialIconAsset,
              color: isButtonColored ? Colors.white : widget.initialButtonColor,
              width: 24, // Adjust the width based on your needs
              height: 24, // Adjust the height based on your needs
            ),
          ],
        ),
      ),
    );
  }
}
