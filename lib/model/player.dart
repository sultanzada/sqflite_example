class Player {
  int _id;
  String _name;
  double _rateValue;
  String _role;

  //Is used for creating a new player the is not need of id
  Player(
    this._name,
    this._rateValue,
    this._role,
  );
  //Is used to updating an existing player which id is needed
  Player.withId(
    this._id,
    this._name,
    this._rateValue,
    this._role,
  );

  int get id => _id;
  String get name => _name;
  double get rateValue => _rateValue;
  String get role => _role;

  set name(String name) {
    this._name = name;
  }

  set rateValue(double rate) {
    this._rateValue = rate;
  }

  set role(String role) {
    this._role = role;
  }

  //For saving data to the SQLite database we need to map data into it
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['name'] = _name;
    map['rate'] = _rateValue;
    map['role'] = _role;

    return map;
  }

  // For getting data from database and show it we need to convert data from MapList to the ObjectList
  Player.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._rateValue = map['rate'];
    this._role = map['role'];
  }
}
