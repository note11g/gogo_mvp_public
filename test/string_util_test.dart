import 'package:flutter_test/flutter_test.dart';
import 'package:gogo_mvp/presentation/src/core/util/string_util.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  group('StringUtil', () {
    test('detectLeeAndGa', () {
      const exampleLeeList = ["김승빈", "박지현", "최성민", "한예슬", "윤재원", "송서영"];
      const exampleGaList = ["김민지", "이승우", "장민호", "고영희", "김민수", "최은서"];

      for (final exampleLee in exampleLeeList) {
        expect(StringUtil.detectLeeAndGa(exampleLee), "이");
      }
      for (final exampleGa in exampleGaList) {
        expect(StringUtil.detectLeeAndGa(exampleGa), "가");
      }
    });

    test('listToString', () {
      final users = ["김승빈", "김승빈", "김승빈", "김승빈", "김승빈", "김승빈", "김승빈"];
      final result = StringUtil.listToString(users, maxShowCount: 1);
      expect(result, "김승빈 외 6명");
    });

    test('beforeDateToString', () {
      final now = DateTime.now();
      final eightMinutesAgo = now.add(const Duration(minutes: -8));
      final sevenHoursAgo = now.add(const Duration(hours: -7));
      final yesterday = now.add(const Duration(days: -1));
      final threeDaysAgo = now.add(const Duration(days: -3));
      final twentyDaysAgo = now.add(const Duration(days: -20));
      final twoMonthsAgo = now.add(const Duration(days: -60));

      expect(now.toBeforeDateString(), "방금 전");
      expect(eightMinutesAgo.toBeforeDateString(), "8분 전");
      expect(sevenHoursAgo.toBeforeDateString(), "7시간 전");
      expect(yesterday.toBeforeDateString(), "어제");
      expect(threeDaysAgo.toBeforeDateString(), "3일 전");
      expect(twentyDaysAgo.toBeforeDateString(), "20일 전");
      expect(twoMonthsAgo.toBeforeDateString(), "2개월 전");
    });

    test('dateToString', () {
      initializeDateFormatting('ko_KR');

      final dateKor = DateTime(2023, 5, 30);
      final resultKor = StringUtil.dateToString(dateKor);
      expect(resultKor, "23년 5월 30일 화요일");

      final shortDate = DateTime(2023, 5, 30);
      final resultShort = StringUtil.dateToString(shortDate, full: false);
      expect(resultShort, "23.05.30 (화)");
    });

    test('timeToString', () {
      initializeDateFormatting('ko_KR');

      final dateKor = DateTime(2023, 5, 30, 15, 0);
      final resultKor = StringUtil.timeToString(dateKor);
      expect(resultKor, "오후 3:00");

      final shortDate = DateTime(2023, 5, 30, 15, 0);
      final resultShort = StringUtil.timeToString(shortDate, short: false);
      expect(resultShort, "오후 3시 00분");
    });
  });
}
