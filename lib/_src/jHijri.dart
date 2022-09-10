import '_jStatic.dart';

/// [int] method [getDaysInAMonth] That Takes int [year] and int [month] Parameters
/// Return the Days number of the Month
int getDaysInAMonth(int year, int month) {
  int i = _getNewMoonMJDNIndex(year, month);
  return _uMIndex(i) - _uMIndex(i - 1);
}

/// [int] Function[lengthOfYear] That Takes int [year]
/// Return the Days number of the Year
int lengthOfYear(int year) {
  int total = 0;
  for (int m = 0; m <= 11; m++) {
    total += getDaysInAMonth(year, m + 1);
  }
  return total;
}

int _uMIndex(int index) {
  if (index < 0 || index >= umAlData.length) {
    throw Exception(
        "Valid date should be between 1356 AH (14 March 1937 CE) to 1500 AH (16 November 2077 CE)");
  }

  return umAlData[index];
}

int _getNewMoonMJDNIndex(int hy, int hm) {
  int cYears = hy - 1;
  int totalMonths = (cYears * 12) + 1 + (hm - 1);
  return totalMonths - 16260;
}

/// [JHijri] IS the Main Class you Can Call it like
/// final jHijri = JHijri();
class JHijri {
  int fDay = 1, fMonth = 1, fYear = 1;
  DateTime? fDate;
  DisplayMod fDisplay = DisplayMod.DDMMMYYYY;
  JHijri(
      {this.fDay = 1,
      this.fMonth = 1,
      this.fYear = 1,
      this.fDate,
      this.fDisplay = DisplayMod.DDMMMYYYY});
  HijriDate get hijri => _jHiJ();
  String get dayName => hijri.dayName;
  String get monthName => hijri.monthName;
  int get day => hijri.day;
  int get month => hijri.month;
  int get year => hijri.year;
  int get weekday => hijri.weekday;
  DateTime get dateTime => hijri.dateTime;
  String get fullDate => _fullDate();
  HijriDate _jHiJ() {
    if (fYear != 1) {
      return HijriDate.dataToHijri(fDay, fMonth, fYear);
    } else if (fDate != null) {
      return HijriDate.dateToHijri(fDate!);
    } else {
      return HijriDate.now();
    }
  }

  JHijri.now() {
    fYear = 1;
    fDay = 1;
    fMonth = 1;
    fDate = DateTime.now();
    _jHiJ();
  }

  String _fullDate() {
    switch (fDisplay) {
      case DisplayMod.MMDD:
        return "$month-$day";
      case DisplayMod.DDMM:
        return "$day-$month";
      case DisplayMod.MMMDD:
        return "$monthName-$day";
      case DisplayMod.DDMMM:
        return "$day-$monthName";
      case DisplayMod.DDDMMM:
        return "$dayName-$day-$monthName";
      case DisplayMod.MMMDDD:
        return "$monthName-$day-$dayName";
      case DisplayMod.DDDMMMYYYY:
        return "$dayName-$day-$monthName-$year";
      case DisplayMod.MMMDDDYYYY:
        return "$monthName-$day-$dayName-$year";
      case DisplayMod.MMDDYYYY:
        return "$month-$day-$year";
      case DisplayMod.DDMMYYYY:
        return "$day-$month-$year";
      case DisplayMod.MMMYYYY:
        return "$monthName-$year";
      case DisplayMod.YYYYMMM:
        return "$year-$monthName";
      case DisplayMod.MMMDDYYYY:
        return "$monthName-$day-$year";
      case DisplayMod.DDMMMYYYY:
      default:
        return "$day-$month-$year";
    }
  }

  @override
  String toString() {
    return fullDate;
  }

  Map<String, dynamic> toMap() {
    return {
      "Y": year,
      "M": month,
      "MN": monthName,
      "D": day,
      "WD": weekday,
      "DN": dayName,
      "Fl": fullDate,
    };
  }
}

/// [HijriDate] IS a Sub Class
class HijriDate {
  int _jDay = 1, _jMonth = 1, _jYear = 1356, _jWeekday = 1;
  String _jDayName = '', _jMonthName = '';
  int get day => _jDay;
  int get month => _jMonth;
  int get year => _jYear;
  int get weekday => _jWeekday;
  String get dayName => _jDayName;
  String get monthName => _jMonthName;
  InternalConverter _jHijriDate = InternalConverter();
  InternalConverter get hijriDate => _jHijriDate;
  DateTime _dateTime = DateTime.now();
  DateTime get dateTime => _dateTime;

  HijriDate.dataToHijri(int jD, int jM, int jY) {
    final vv = _valid(jY);
    if (vv == "w") {
      final d = _toHijri(jY, jM, jD);
      _jHijriDate = d;
      _jDay = d.day;
      _jMonth = d.month;
      _jYear = d.year;
      _jMonthName = d.monthName;
      _jDayName = d.dayName;
      _jWeekday = d.weekday;
      final d2 = DateTime(jY, jM, jD);
      _dateTime = d2;
    } else if (vv == "h") {
      final d = _toWestern(jY, jM, jD);
      _dateTime = DateTime(d.year, d.month, d.day);
      final d2 = _toHijri(d.year, d.month, d.day);
      _jHijriDate = d2;
      _jDay = d2.day;
      _jMonth = d2.month;
      _jYear = d2.year;
      _jMonthName = d2.monthName;
      _jDayName = d2.dayName;
      _jWeekday = d2.weekday;
    } else {
      _jDay = jD;
      _jMonth = jM;
      _jYear = jY;
      _jWeekday = 1;
    }
  }
  HijriDate.dateToHijri(DateTime jDD) {
    final d = _toHijri(jDD.year, jDD.month, jDD.day);
    _jDay = d.day;
    _jMonth = d.month;
    _jYear = d.year;
    _jMonthName = d.monthName;
    _jDayName = d.dayName;
    _jWeekday = d.weekday;
    _dateTime = jDD;
    _jHijriDate = d;
  }
  HijriDate.now() {
    final jDD = DateTime.now();
    final d = _toHijri(jDD.year, jDD.month, jDD.day);
    _jDay = d.day;
    _jMonth = d.month;
    _jYear = d.year;
    _jMonthName = d.monthName;
    _jDayName = d.dayName;
    _jWeekday = d.weekday;
    _dateTime = jDD;
    _jHijriDate = d;
  }
  String _valid(int jY) {
    if (jY > 1937 && jY < 2077) {
      return "w";
    } else if (jY > 1356 && jY < 1500) {
      return "h";
    } else {
      return "b";
    }
  }

  InternalConverter _toWestern(int hYear, int hMonth, int hDay) {
    return _d2g2(_h2d2(hYear, hMonth, hDay));
  }

  InternalConverter _toHijri(int gYear, int gMonth, int gDay) {
    return _d2h2(gYear, gMonth, gDay);
  }

  int _umIndex(int index) {
    if (index < 0 || index >= umAlData.length) {
      throw Exception(
          "Valid date should be between 1356 AH (14 March 1937 CE) to 1500 AH (16 November 2077 CE)");
    }

    return umAlData[index];
  }

  int _h2d2(int hy, int hm, int hd) {
    int jy = hy;
    int jm = hm;
    int jd = hd;
    int ji = jy - 1;
    int jlN = (ji * 12) + 1 + (jm - 1);
    int j = jlN - 16260;
    int mcJdn = jd + _umIndex(j - 1) - 1;
    int cJdn = mcJdn + 2400000;
    return cJdn;
  }

  InternalConverter _d2g2(int jdn) {
    int jz = (jdn + 0.5).floor();
    int ja = ((jz - 1867216.25) / 36524.25).floor();
    ja = jz + 1 + ja - (ja / 4).floor();
    int jb = ja + 1524;
    int jc = ((jb - 122.1) / 365.25).floor();
    int jd = (365.25 * jc).floor();
    int je = ((jb - jd) / 30.6001).floor();
    int jD = jb - jd - (je * 30.6001).floor();
    int jM = je - (je > 13.5 ? 13 : 1);
    int jY = jc - (jM > 2.5 ? 4716 : 4715);
    if (jY <= 0) {
      jY--;
    }
    int dbN = jdn + 1;
    int bbNK = dbN - (dbN ~/ 7) * 7;
    String jDN = englishDay(bbNK);
    String jMN = englishMonth(jM);
    return InternalConverter(
        fDay: jD,
        fYear: jY,
        fMonth: jM,
        fMonthName: jMN,
        fDayName: jDN,
        fWeekday: bbNK);
  }

  InternalConverter _d2h2(int pYear, int pMonth, int pDay) {
    int jda = (pDay);
    int jmo = (pMonth);
    int jye = (pYear);
    int jm = jmo;
    int jy = jye;
    if (jm < 3) {
      jy -= 1;
      jm += 12;
    }
    int ja = (jy / 100).floor();
    int jgc = ja - (ja / 4.0).floor() - 2;
    int cJdn = (365.25 * (jy + 4716)).floor() +
        (30.6001 * (jm + 1)).floor() +
        jda -
        jgc -
        1524;
    ja = ((cJdn - 1867216.25) / 36524.25).floor();
    jgc = ja - (ja / 4.0).floor() + 1;
    int jb = cJdn + jgc + 1524;
    int jc = ((jb - 122.1) / 365.25).floor();
    int jd = (365.25 * jc).floor();
    jmo = ((jb - jd) / 30.6001).floor();
    jda = (jb - jd) - (30.6001 * jmo).floor();
    if (jmo > 13) {
      jc += 1;
      jmo -= 12;
    }

    jmo -= 1;
    jye = jc - 4716;
    int mcJdn = cJdn - 2400000;
    int ji;
    for (ji = 0; ji < umAlData.length; ji++) {
      if (_umIndex(ji) > mcJdn) break;
    }
    int jlN = ji + 16260;
    int jj = ((jlN - 1) / 12).floor();
    int jY = jj + 1;
    int jM = jlN - 12 * jj;
    int jD = mcJdn - _umIndex(ji - 1) + 1;
    //int jML = _umIndex(i) - _umIndex(i - 1);
    int dbN = cJdn + 1;
    int bbNK = dbN - (dbN ~/ 7) * 7;
    String jDN = arabicDay(bbNK);
    String jMN = arabicMonth(jM);
    return InternalConverter(
        fDay: jD,
        fYear: jY,
        fMonth: jM,
        fMonthName: jMN,
        fDayName: jDN,
        fWeekday: bbNK);
  }

  @override
  String toString() {
    return "$dayName-$day-$monthName-$year";
  }

  Map<String, dynamic> toMap() {
    return {
      "Y": year,
      "M": month,
      "MN": monthName,
      "D": day,
      "WD": weekday,
      "DN": dayName,
      "Fl": "$dayName-$day-$monthName-$year"
    };
  }
}

/// [InternalConverter] IS a Sub Class you
class InternalConverter {
  String fMonthName = '', fDayName = '';
  int fDay = 1, fMonth = 1, fYear = 1356, fWeekday = 1;
  String get dayName => fDayName;
  String get monthName => fMonthName;
  int get day => fDay;
  int get month => fMonth;
  int get year => fYear;
  int get weekday => fWeekday;
  InternalConverter(
      {this.fMonthName = '',
      this.fDayName = '',
      this.fYear = 1356,
      this.fWeekday = 1,
      this.fMonth = 1,
      this.fDay = 1});
  @override
  String toString() {
    return "$dayName-$day-$monthName-$year";
  }

  Map<String, dynamic> toMap() {
    return {
      "Y": year,
      "M": month,
      "MN": monthName,
      "D": day,
      "WD": weekday,
      "DN": dayName,
      "Fl": "$dayName-$day-$monthName-$year"
    };
  }
}
