import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  DateTime _startTime;
  DateTime _endTime;
  String _title;
  String _location;

  Event({
    required DateTime startTime,
    required DateTime endTime,
    required String title,
    required String location
  }):
      _startTime = startTime,
      _endTime = endTime,
      _title = title,
      _location = location;

  String get location {
    return _location;
  }

  set location(String value) {
    _location = value;
  }

  String get title {
    return _title;
  }

  set title(String value) {
    _title = value;
  }

  DateTime get endTime {
    return _endTime;
  }

  set endTime(DateTime value) {
    _endTime = value;
  }

  DateTime get startTime {
    return _startTime;
  }

  set startTime(DateTime value) {
    _startTime = value;
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
        startTime: (map['start_time'] as Timestamp).toDate(),
        endTime: (map['end_time'] as Timestamp).toDate(),
        title: map["title"],
        location: map['location']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_time' : Timestamp.fromDate(startTime),
      'end_time' : Timestamp.fromDate(endTime),
      'title' : title,
      'location' : location
    };
  }
}