enum FormattingType { HourMinute, HourMunuteSecond }

String printDurationTime({
  required Duration? duration,
  FormattingType? formattingType,
}) {
  if (duration != null && formattingType != null) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (formattingType == FormattingType.HourMinute) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }
  return '00:00';
}
