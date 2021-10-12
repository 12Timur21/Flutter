void main() {
  Web site = Proxy();
  site.authorizeUser('12Timur21', '192.153.11.33');
  site.authorizeUser('Timur2001', '193.193.19.11');
}

abstract class Web {
  void authorizeUser(String userName, String userIP);
}

class Proxy implements Web {
  List<String> _blockedIP = ['192.153.11.33', '194.123.31.13', '195.213.31.32'];

  Server? _server;

  void authorizeUser(String userName, String userIP) {
    bool isBan = false;
    _blockedIP.forEach((blockedIP) {
      if (userIP == blockedIP) {
        print('$userName, ваш IP заблокирован');
        isBan = true;
      }
    });

    if (!isBan) {
      _getInstance()?.authorizeUser(userName, userIP);
    }
  }

  Server? _getInstance() {
    if (_server != null) {
      return _server;
    }
    _server = Server();
    return _server;
  }
}

class Server implements Web {
  void authorizeUser(String userName, String userIP) {
    print('User: $userName с IP $userIP авторизован');
  }
}
