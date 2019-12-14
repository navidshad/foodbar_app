class TextUtil {
  static String toUperCaseForLable(String str) {
    // String newStr = str.splitMapJoin('', onMatch: (m) {
    //   String word = m.group(0);
    //   return word[0].toUpperCase() + word.substring(1);
    // });

    // return newStr;

    return str.split(' ').map((part) => toCapital(part)).join(' ');

    //return str[0].toUpperCase() + str.substring(1);
  }

  static String toCapital(String str){
    return str[0].toUpperCase() + str.substring(1);
  }
}
