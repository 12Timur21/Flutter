enum TimeFormattingType {
  minuteSecond,
  hourMinute,
  hourMinuteSecond,
}

enum DayTimeFormattingType {
  dayMonthYear,
  dayMonth,
  day,
}

String convertDurationToString({
  Duration? duration,
  required TimeFormattingType? formattingType,
}) {
  if (duration != null) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String oneDigitHours = twoDigits(duration.inHours.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (formattingType == TimeFormattingType.minuteSecond) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
    if (formattingType == TimeFormattingType.hourMinute) {
      return "$oneDigitHours:$twoDigitMinutes";
    }
    return "${duration.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  }
  return '00:00:00';
}

String convertDateTimeToString({
  DateTime? date,
  DayTimeFormattingType? dayTimeFormattingType,
}) {
  if (date != null && dayTimeFormattingType != null) {
    if (dayTimeFormattingType == DayTimeFormattingType.dayMonthYear) {
      return "${date.day}.${date.month}.${date.year}";
    }
    if (dayTimeFormattingType == DayTimeFormattingType.dayMonth) {
      return "${date.day}.${date.month}";
    }
    if (dayTimeFormattingType == DayTimeFormattingType.day) {
      return "${date.day}";
    }
  }
  return '';
}
