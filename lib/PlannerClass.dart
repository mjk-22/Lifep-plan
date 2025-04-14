class Planner {
  Map<String, List<Event>> plannerEntry;

  Planner({required this.plannerEntry});
}

class Event {
  var startTime;
  var endTime;
  var title;
  var location;

  Event({required this.startTime, required this.endTime, required this.title, required this.location});
}