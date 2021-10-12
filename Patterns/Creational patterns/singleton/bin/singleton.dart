class DBConnection {
  static DBConnection? _dbConnection;
  bool _isConnected = false;

  factory DBConnection() {
    return _dbConnection ??= DBConnection._internal();
  }

  DBConnection._internal();

  void emulateConnection() {
    print('Подключение установлено');
    if (_isConnected == false) _isConnected = true;
  }

  void checkConnection() {
    print(_isConnected);
  }
}

void main() {
  // ignore: omit_local_variable_types
  DBConnection s1 = DBConnection();
  DBConnection s2 = DBConnection();

  s1.checkConnection();
  s2.emulateConnection();
  s1.checkConnection();
}
