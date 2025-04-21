import 'event.dart';
import 'companion.dart';
class Account {
  String _email;
  String _username;
  bool _isNotificationOn;
  Map<String, List<Event>>? _events;
  Companion _companion;

  Account({
    required String email,
    required String username,
    required bool isNotificationOn,
    required Map<String, List<Event>>? events,
    required Companion companion
  }): _email = email,
      _username = username,
      _isNotificationOn = isNotificationOn,
      _events = events,
      _companion = companion;

  String get email {
    return _email;
  }

  set email(String email) {
    _email = email;
  }

  String get username {
    return _username;
  }

  set username(String username) {
    _username = username;
  }

  bool get isNotificationOn {
    return _isNotificationOn;
  }

  set isNotificationOn(bool value) {
    _isNotificationOn = value;
  }


  Map<String, List<Event>>? get events => _events;

  set events(Map<String, List<Event>>? event) {
    _events = event;
  }


  Companion get companion {
    return _companion;
  }

  set companion(Companion companion) {
    _companion = companion;
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
        email: map['email'],
        username: map['username'],
        isNotificationOn: map['isNotificationOn'],
        events: Map<String, List<Event>>.from(map['events']),
        companion: Companion.fromMap(map['companion'])
    );
  }
}