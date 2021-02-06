class TextUtil {
  static String toUperCaseForLable(String str) {
    return str.split(' ').map((part) => toCapital(part)).join(' ');
  }

  static String toCapital(String str){
    return str[0].toUpperCase() + str.substring(1);
  }

  static String makeShort(String str, int length) {
    int lengthTemp = (str.length > length) ? length : str.length;
    String tempStr = str.split('').sublist(0, lengthTemp).join();

    if(str.length > length)
      tempStr += '...';

    return tempStr;
  }
}
