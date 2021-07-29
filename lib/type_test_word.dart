class TypeTestWord {
  String word;
  bool typed = false;
  bool mistaked = false;
  int keyStrokesTook;
  String userTyped;
  TypeTestWord(this.word) {
    keyStrokesTook = word.length;
  }
}
