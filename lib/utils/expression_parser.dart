class CustomExpressionParser {
  static String preprocess(String exp) {
    return exp
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', '3.1415926535')
        .replaceAll('e', '2.718281828');
  }
}