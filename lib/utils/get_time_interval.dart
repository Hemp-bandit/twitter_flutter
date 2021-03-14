//  判断相隔时间
String getTheTimeInterval(DateTime startTime, DateTime endTime) {
  Duration intervalTime = endTime.difference(startTime);
  if (intervalTime.inSeconds < 60) {
    return "${intervalTime.inSeconds}秒钟前";
  } else if (intervalTime.inMinutes < 60) {
    return "${intervalTime.inMinutes}分钟前";
  } else if (intervalTime.inHours < 60) {
    return "${intervalTime.inHours}小时前";
  } else if (intervalTime.inDays < 30) {
    return "${intervalTime.inDays.toInt()}天前";
  } else if (intervalTime.inDays >= 30 && intervalTime.inDays < 365) {
    return "${(intervalTime.inDays ~/ 30)}个月前";
  } else {
    return "${intervalTime.inDays ~/ 365}年前";
  }
}

String getTheDateTime(String dateTimeStr) {
  DateTime dateTime = DateTime.parse(dateTimeStr);
  String hours = dateTime.hour < 10 ? "0${dateTime.hour}" : dateTime.hour.toString();
  String minutes = dateTime.minute < 10 ? "0${dateTime.minute}" : dateTime.minute.toString();
  return "${dateTime.year}/${dateTime.month}/${dateTime.day} $hours:$minutes";
}