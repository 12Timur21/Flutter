class DBConnection {
  static DBConnection? dbConnect;
  final String? _connectionID = 'mongodb+srv://12Timur21:***@20Compassssl=true';
  bool isConnected = false;

  factory DBConnection() {
    return dbConnect ??= DBConnection._internal();
  }

  void emulateConnection() {
    if (_connectionID != null) {
      isConnected = true;
    }
  }

  void checkConnection() {
    print(isConnected);
  }

  DBConnection._internal();
}

void main() {
  var s1 = DBConnection();
  var s2 = DBConnection();

  s1.checkConnection();
  s2.emulateConnection();
  s1.checkConnection();
}
