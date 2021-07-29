import 'package:flutter/material.dart';

import 'custom_container.dart';
import 'type_test_word.dart';

class AnalysisSection extends StatelessWidget {
  final String accuracy;
  final int grossWPM, netWPM;
  final List<TypeTestWord> mistakedWords;

  const AnalysisSection({
    Key key,
    @required this.accuracy,
    @required this.grossWPM,
    @required this.netWPM,
    @required this.mistakedWords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double sizeMultiplier = 1;
    if (width < 500)
      sizeMultiplier = 0.55;
    else if (width < 800)
      sizeMultiplier = 0.75;
    else if (width < 1000)
      sizeMultiplier = 0.85;
    else
      sizeMultiplier = 1;
    return CustomContainer(
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: sizeMultiplier * 32, vertical: sizeMultiplier * 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Performance Analysis:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: sizeMultiplier * 20,
                ),
              ),
            ),
            SizedBox(height: sizeMultiplier * 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'WPM: $grossWPM',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: sizeMultiplier * 18,
                  ),
                ),
                Text(
                  'Accuracy: $accuracy %',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: sizeMultiplier * 18,
                  ),
                ),
                Text(
                  'Net WPM: $netWPM',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: sizeMultiplier * 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: sizeMultiplier * 24),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'Mistakes:',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: sizeMultiplier * 18,
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (mistakedWords.isEmpty)
                  Text(
                    "No mistakes 🥳",
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: mistakedWords
                        .map(
                          (word) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: RichText(
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: '>  ${word.word} ',
                                  ),
                                  TextSpan(
                                    text:
                                        '(${(word.word.length * 100 / word.keyStrokesTook).ceil()}%)',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' typed: ${word.userTyped}',
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                Container(), // to show charts
              ],
            )
          ],
        ),
      ),
    );
  }
}
