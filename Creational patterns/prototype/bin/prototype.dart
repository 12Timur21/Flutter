abstract class Account {
  Object clone();
}

class GoogleAccount implements Account {
  String? fullName;
  String? password;

  GoogleAccount(this.fullName, this.password);

  // GoogleAccount _fromSource(GoogleAccount? account) {
  //   if (account != null) {
  //     return GoogleAccount(account.fullName, account.password);
  //   } else {
  //     throw Exception("No data to copy");
  //   }
  // }

  // @override
  // GoogleAccount clone() {
  //   return _fromSource(this);
  // }

  @override
  GoogleAccount clone() {
    return this;
  }
}

void main() {
  GoogleAccount account = new GoogleAccount('Timur', '12345eQ');
  var accountBackup = account.clone();

  print('Original: ${account.fullName}, Backup: ${accountBackup.fullName}');
}
