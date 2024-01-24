import 'package:intl/intl.dart';

class StringUtil {
  /// 이/가 구분
  static String detectLeeAndGa(String name) {
    assert(name.isNotEmpty);
    final lastChar = name.codeUnitAt(name.length - 1);
    return (lastChar - 0xac00) % 28 > 0 ? "이" : "가";
  }

  /// 과/와 구분
  static String detectGwaAndWa(String name) {
    assert(name.isNotEmpty);
    final lastChar = name.codeUnitAt(name.length - 1);
    return (lastChar - 0xac00) % 28 > 0 ? "과" : "와";
  }

  /// xx외 x명
  static String listToString(List<String> list, {required int maxShowCount}) {
    final overflow = list.length > maxShowCount;
    final showCount = overflow ? maxShowCount : list.length;

    final shownList = list.sublist(0, showCount);
    final shownText =
        shownList.toString().replaceFirst("[", "").replaceFirst("]", "");

    return overflow ? "$shownText 외 ${list.length - maxShowCount}명" : shownText;
  }

  /// date to String
  static String dateToString(
    DateTime date, {
    bool year = true,
    bool month = true,
    bool day = true,
    bool dayOfWeek = true,
    bool full = true, // 2021년 3월 3일 (false : 2021.03.01)
  }) {
    String formatString = "";
    if (year) formatString += full ? "yy년 " : "yy.";
    if (month) formatString += full ? "M월 " : "MM.";
    if (day) formatString += full ? "d일" : "dd";
    if (dayOfWeek) formatString += full ? " EEEE" : " (E)";

    final formatter = DateFormat(formatString, "ko_KR");
    return formatter.format(date);
  }

  /// time to String (오후 3:00)
  ///
  /// short true: 오후 3:00 (false : 오후 3시 00분)
  static String timeToString(
    DateTime date, {
    bool hour = true,
    bool minute = true,
    bool amPm = true,
    bool short = true,
  }) {
    String formatString = "";
    if (amPm) formatString += "a ";
    if (hour) formatString += short ? "h" : "h시";
    if (minute) formatString += short ? ":mm" : " mm분";

    final formatter = DateFormat(formatString, "ko_KR");
    return formatter.format(date);
  }

  static String dateTimeToStringWithDash(DateTime date) {
    // example : 2023-01-12-12-00-00
    final formatter = DateFormat("yyyy-MM-dd-HH-mm-ss", "ko_KR");
    return formatter.format(date);
  }

  /// ~~일 전, ~~시간 전, ~~분 전, 방금 전
  static String beforeDateToString(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays > 30) {
      return "${diff.inDays ~/ 30}개월 전";
    } else if (diff.inDays > 1) {
      return "${diff.inDays}일 전";
    } else if (diff.inDays == 1) {
      return "어제";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}시간 전";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}분 전";
    } else {
      return "방금 전";
    }
  }

  StringUtil._();
}

extension StringUtilKoreanExtension on String {
  String get appendLeeAndGa => "$this${StringUtil.detectLeeAndGa(this)}";

  String get appendGwaAndWa => "$this${StringUtil.detectGwaAndWa(this)}";
}

extension StringUtilListExtension on List<String> {
  String toPersonTextString({required int maxShowCount}) =>
      StringUtil.listToString(this, maxShowCount: maxShowCount);
}

extension StringUtilDateTimeExtension on DateTime {
  String toDateString({
    bool year = true,
    bool month = true,
    bool day = true,
    bool dayOfWeek = true,
    bool full = true, // 2021년 3월 3일 (false : 2021.03.01)
  }) =>
      StringUtil.dateToString(this,
          year: year, month: month, day: day, dayOfWeek: dayOfWeek, full: full);

  /// short true: 오후 3:00 (false : 오후 3시 00분)
  String toTimeString({
    bool hour = true,
    bool minute = true,
    bool amPm = true,
    bool short = true,
  }) =>
      StringUtil.timeToString(this,
          hour: hour, minute: minute, amPm: amPm, short: short);

  String toDateTimeStringWithDash() => StringUtil.dateTimeToStringWithDash(this);

  String toBeforeDateString() => StringUtil.beforeDateToString(this);
}
