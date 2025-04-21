class Companion {
  int _companionId;
  String _name;
  Gender _gender;
  List<String> _replies;
  String _image;


  Companion({
    required int companionId,
    required List<String> replies,
    required String name,
    required Gender gender,
    required String image
  }):
      _companionId = companionId,
      _replies = replies,
      _name = name,
      _gender = gender,
      _image = image;


  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<String> get replies => _replies;

  set replies(List<String> value) {
    _replies = value;
  }

  int get companionId => _companionId;

  set companionId(int value) {
    _companionId = value;
  }

  Gender get gender => _gender;

  set gender(Gender value) {
    _gender = value;
  }


  String get image => _image;

  set image(String value) {
    _image = value;
  }

  Map<String, dynamic> toMap() {
    return {
      'companion_id' : companionId,
      'name' : name,
      'gender' : gender,
      'replies' : replies,
      'companion_image' : image
    };
  }

  factory Companion.fromMap(Map<String, dynamic> map) {
    return Companion(
    companionId: map['companionId'],
    replies: List<String>.from(map['replies']),
    name: map['name'],
    gender: map['gender'],
    image: map['image']
  );
  }
}

enum Gender {
  MALE, FEMALE
}