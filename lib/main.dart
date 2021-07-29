import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:type_rewards/typing_test.dart';

void main() {
  runApp(Home());
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> sentences;
  var typingTestKey = UniqueKey();
  int randomIndex = 0;

  void loadTests() async {
    final data = await rootBundle.loadString('assets/sentences.json');
    sentences = (jsonDecode(data) as List).map((e) => e.toString()).toList() ??
        [
          "Could not load the practice paragraphs due to some error. But don't worry you can still practice on this very paragraph. Hope the error get fixed soon."
        ];
    shuffleTest();
  }

  void shuffleTest() {
    randomIndex = Random().nextInt(sentences.length);
    typingTestKey = UniqueKey();
    setState(() {});
  }

  @override
  void initState() {
    loadTests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: (sentences == null || sentences.isEmpty)
            ? Center(
                child: SpinKitFadingFour(
                  color: Colors.white,
                  size: 80,
                ),
              )
            : Scrollbar(
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: [
                      SizedBox(height: 24),
                      TypingTest(
                        key: typingTestKey,
                        sentence: sentences[randomIndex],
                        changeText: shuffleTest,
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
