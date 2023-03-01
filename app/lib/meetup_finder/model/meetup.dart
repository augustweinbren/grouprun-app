import 'dart:core';

enum RunningSettingType { street, park, track }

enum Day { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday }

class Meetup {
  const Meetup({
    required this.id,
    required this.groupName,
    required this.lat,
    required this.lng,
    required this.day,
    required this.startTime,
    required this.endTime,
    this.url = '',
    required this.bagDrop,
    required this.dogFriendly,
    required this.postRunSocial,
    required this.competitionTraining,
    required this.beginnerFriendly,
    required this.runningSettingType,
  });
  final int id;
  final String groupName;
  final double lat;
  final double lng;
  final int bagDrop;
  final int dogFriendly;
  final int postRunSocial;
  final int competitionTraining;
  final int beginnerFriendly;
  final int runningSettingType;
  final int day;
  final int startTime;
  final int endTime;
  final String url;

  // Convert a Meetup into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'group_name': groupName,
      'latitude': lat,
      'longitude': lng,
      'bag_drop': bagDrop,
      'dog_friendly': dogFriendly,
      'post_run_social': postRunSocial,
      'competition_training': competitionTraining,
      'beginner_friendly': beginnerFriendly,
      'running_setting_type': runningSettingType,
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'url': url,
    };
  }

  // Implement toString to make it easier to see information about
  // each meetup when using the print statement.
  @override
  String toString() {
    return 'Meetup{id: $id, groupName: $groupName, latitude: $lat, longitude: $lng,' +
        'bagDrop: $bagDrop, dogFriendly: $dogFriendly, postRunSocial: $postRunSocial,' +
        'competitionTraining: $competitionTraining, beginnerFriendly: ' +
        '$beginnerFriendly, runningSettingType: $runningSettingType, day: $day,' +
        ' startTime: $startTime, endTime: $endTime, url: $url}';
  }

  String formattedStartToEndTime() {
    // if (this.startTime > 2359 || this.endTime > 2359) {
    //   throw ArgumentError("start time or end time too high");
    // } else if (this.startTime < 0 || this.endTime < 0) {
    //   throw ArgumentError("start/end time is negative");
    // } TODO: should be in db
    int startTimeTenHours = (this.startTime ~/ 1000);
    int startTimeHour = (this.startTime % 1000) ~/ 100;
    int startTimeTenMins = (this.startTime % 100) ~/ 10;
    int startTimeMins = (startTime % 10);
    String startTimeStr = startTimeTenHours.toString() +
        startTimeHour.toString() +
        ":" +
        startTimeTenMins.toString() +
        startTimeMins.toString();
    int endTimeTenHours = (this.endTime ~/ 1000);
    int endTimeHour = ((this.endTime % 1000) ~/ 100);
    int endTimeTenMins = ((this.endTime % 100) ~/ 10);
    int endTimeMins = (endTime % 10);
    String endTimeStr = endTimeTenHours.toString() +
        endTimeHour.toString() +
        ":" +
        endTimeTenMins.toString() +
        endTimeMins.toString();

    return (startTimeStr + " - " + endTimeStr);
  }

  String formattedDay() {
    switch (this.day) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        throw (ArgumentError("Day data entered incorrectly"));
    }
  }
}
