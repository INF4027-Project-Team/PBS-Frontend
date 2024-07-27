class userSession {

  static final userSession _instance = userSession._internal();
  String? userEmail;
  String? userName;
  String? userSurname;

  factory userSession() {
    return _instance;
  }

  userSession._internal();

  void setEmail(String? email) {
    userEmail = email;
  }

  void setName(String name) {
    userName = name;
  }

  void setSurname(String surname) {
    userSurname = surname;
  }

  void clearSession() {
    userEmail = null;
    userName = null;
    userSurname = null;
  }
}