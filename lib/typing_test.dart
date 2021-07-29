import 'package:flutter/material.dart';

import 'analysis_section.dart';
import 'custom_container.dart';
import 'type_test_word.dart';

class TypingTest extends StatefulWidget {
  final String sentence;
  final Function changeText;

  const TypingTest({Key key, this.sentence, this.changeText}) : super(key: key);

  @override
  _TypingTestState createState() => _TypingTestState();
}

class _TypingTestState extends State<TypingTest> {
  String sentence;

  List<TypeTestWord> words;
  int _currentIndex = 0;
  int _length = 0;

  bool finished = false;

  final _controller = TextEditingController();

  int _nonSpaceKeyStrokes = 0;
  DateTime _startTime;
  int _completionMillis;

  int _keyStrokeTillLastKeyword = 0;

  int _currWPM = 0;

  bool _hideWhatYouType = false;

  String latestTypedByUser = "";

  void _calculateCurrentWPM() {
    int mills = DateTime.now().difference(_startTime).inMilliseconds;
    _currWPM = (_nonSpaceKeyStrokes + _currentIndex) * 60 * 1000 ~/ (mills * 5);
  }

  void _assessPerTypedWord() {
    words[_currentIndex].typed = true;

    if (_nonSpaceKeyStrokes - _keyStrokeTillLastKeyword !=
        words[_currentIndex].word.length) {
      words[_currentIndex].mistaked = true;
      words[_currentIndex].keyStrokesTook =
          _nonSpaceKeyStrokes - _keyStrokeTillLastKeyword;
      words[_currentIndex].userTyped = latestTypedByUser;
    }
    latestTypedByUser = "";
    _keyStrokeTillLastKeyword = _nonSpaceKeyStrokes;
    _currentIndex++;
    _controller.text = "";
    setState(() {});
  }

  @override
  void initState() {
    sentence = widget.sentence;
    words = sentence.split(' ').map((e) => TypeTestWord(e)).toList();
    _length = words.length;
    super.initState();
  }

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

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomContainer(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: sizeMultiplier * 48.0,
                horizontal: sizeMultiplier * 64),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: RichText(
                    text: TextSpan(
                        children: words
                            .map((word) => TextSpan(
                                text: word.word + ' ',
                                style: TextStyle(
                                  color: word.typed
                                      ? word.mistaked
                                          ? Colors.red
                                          : Colors.green
                                      : Colors.white,
                                  fontWeight: word.typed
                                      ? FontWeight.normal
                                      : FontWeight.w500,
                                  decoration: word.mistaked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontSize: sizeMultiplier * 24,
                                )))
                            .toList()),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: sizeMultiplier * 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_startTime != null && !finished)
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'WPM: ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: sizeMultiplier * 24)),
                            TextSpan(
                                text: '$_currWPM',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: sizeMultiplier * 24)),
                          ],
                        )),
                      Divider(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                onTap: () => widget.changeText(),
                                child: Card(
                                  color: Colors.yellowAccent.withOpacity(0.2),
                                  elevation: 4,
                                  shadowColor: Colors.white.withOpacity(0.2),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.refresh_outlined,
                                          color: Colors.yellow,
                                          size: sizeMultiplier * 20,
                                        ),
                                        Text(
                                          ' Change Text',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: sizeMultiplier * 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                width < 700
                                    ? _hideWhatYouType
                                        ? "Hide"
                                        : "Hide typing"
                                    : "Hide what you type",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              Switch(
                                  activeTrackColor: Colors.white,
                                  activeColor: Colors.yellow,
                                  value: _hideWhatYouType,
                                  onChanged: (val) {
                                    setState(() {
                                      _hideWhatYouType = val;
                                    });
                                  }),
                              if (_hideWhatYouType)
                                Text(
                                  '🧠😎',
                                  style: TextStyle(
                                    fontSize: sizeMultiplier * 22,
                                  ),
                                )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                RawKeyboardListener(
                  focusNode: FocusNode(),
                  autofocus: true,
                  onKey: (keyEvent) {
                    if (keyEvent.character != null &&
                        keyEvent.character.length == 1 &&
                        keyEvent.character[0] != ' ') {
                      if (keyEvent.character[0] != ' ') {
                        print(keyEvent.character);
                        if (_startTime == null) _startTime = DateTime.now();
                        _nonSpaceKeyStrokes++;
                      }
                      latestTypedByUser += keyEvent.character;
                    }
                  },
                  child: Container(
                    child: TextField(
                      controller: _controller,
                      enabled: !finished,
                      enableInteractiveSelection: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      style: TextStyle(
                        fontSize: sizeMultiplier * 20,
                        color: _hideWhatYouType
                            ? Colors.transparent
                            : Colors.white,
                      ),
                      smartDashesType: SmartDashesType.disabled,
                      smartQuotesType: SmartQuotesType.disabled,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: sizeMultiplier * 16.0),
                          child: Icon(
                            Icons.keyboard_alt_rounded,
                            color: Colors.white,
                            size: sizeMultiplier * 32,
                          ),
                        ),
                        hintText: _currentIndex < _length
                            ? words[_currentIndex].word
                            : "Completed",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: sizeMultiplier * 24),
                      ),
                      onChanged: (val) {
                        if (_currentIndex >= _length) return;
                        if (_startTime != null) _calculateCurrentWPM();

                        if (_currentIndex == _length - 1 &&
                            val == words[_currentIndex].word) {
                          _completionMillis = DateTime.now()
                              .difference(_startTime)
                              .inMilliseconds;
                          finished = true;
                          _calculateCurrentWPM();
                          _assessPerTypedWord();
                          print(
                              '${_nonSpaceKeyStrokes + words.length} ${sentence.length}');
                        } else if (val.isNotEmpty &&
                            val[val.length - 1] == ' ' &&
                            val.trimRight() == words[_currentIndex].word) {
                          _assessPerTypedWord();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: sizeMultiplier * 40),
        if (finished)
          AnalysisSection(
            accuracy: (100 *
                    sentence.length /
                    (_nonSpaceKeyStrokes + words.length - 1))
                .toStringAsFixed(2),
            grossWPM: (_nonSpaceKeyStrokes + words.length) *
                60 *
                1000 ~/
                (_completionMillis * 5),
            netWPM: sentence.length * 60 * 1000 ~/ (_completionMillis * 5),
            mistakedWords:
                words.where((word) => word.mistaked == true).toList(),
          )
      ],
    );
  }
}
