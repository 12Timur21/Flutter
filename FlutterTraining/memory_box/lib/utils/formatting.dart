enum FormattingType { hourMinute, hourMinuteWithOneDigits, hourMinuteSecond }

String printDurationTime({
  required Duration? duration,
  FormattingType? formattingType,
}) {
  if (duration != null && formattingType != null) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String oneDigitHours = duration.inHours.remainder(60).toString();
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (formattingType == FormattingType.hourMinute) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else if (formattingType == FormattingType.hourMinuteWithOneDigits) {
      return "$oneDigitHours:$twoDigitMinutes";
    } else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }
  return '00:00';
}
