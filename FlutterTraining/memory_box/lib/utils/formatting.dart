enum FormattingType { HourMinute, HourMunuteSecond }

String printDurationTime(
    {required Duration? duration, FormattingType? formattingType}) {
  //!Убрать лишний код
  Duration duration2 = duration ?? Duration();
  FormattingType formattingType2 = formattingType ?? FormattingType.HourMinute;

  String twoDigits(int n) => n.toString().padLeft(2, "0");
  String twoDigitMinutes = twoDigits(duration2.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration2.inSeconds.remainder(60));

  if (formattingType == FormattingType.HourMinute) {
    return "$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "${twoDigits(duration2.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
