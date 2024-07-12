class User {
  int? id;
  String? username;
  String? email;
  String? refresh;
  String? access;

  // A private static instance of the class
  static final User _instance = User._internal();

  // A private named constructor
  User._internal();

  // A factory constructor that returns the same instance every time
  factory User() {
    return _instance;
  }

  // Method to initialize the User instance with data
  void initialize({int? id, String? username, String? email, String? refresh, String? access}) {
    this.id = id;
    this.username = username;
    this.email = email;
    this.refresh = refresh;
    this.access = access;
  }

  // Named constructor to create User instance from JSON
   // A factory constructor that returns the same instance every time
  factory User.fromJson(Map<String, dynamic> json) {
    _instance.id = json['user']['id'];
    _instance.username = json['user']['username'];
    _instance.email = json['user']['email'];
    _instance.refresh = json['refresh'];
    _instance.access = json['access'];
    return _instance;
  }

  // Method to convert User instance to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['refresh'] = this.refresh;
    data['access'] = this.access;
    return data;
  }
}
