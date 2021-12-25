enum SubscriptionType {
  noSubscription,
  monthSubscription,
  yearSubscription,
}

class UserModel {
  String? uid;
  String? displayName;
  String? phoneNumber;
  SubscriptionType subscriptionType;
  UserModel({
    this.uid,
    this.displayName,
    this.phoneNumber,
    required this.subscriptionType,
  });

  factory UserModel.initial() {
    return UserModel(
      uid: null,
      displayName: null,
      phoneNumber: null,
      subscriptionType: SubscriptionType.noSubscription,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    SubscriptionType? subscriptionType;

    for (final value in SubscriptionType.values) {
      String enumValue = value.toString().split('.').last;

      if (enumValue == json['subscriptionType']) {
        print(value);
        subscriptionType = value;
      }
    }

    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      subscriptionType: subscriptionType ?? SubscriptionType.noSubscription,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'subscriptionType': subscriptionType.toString().split('.').last,
      };

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? phoneNumber,
    SubscriptionType? subscriptionType,
    Map<String, String>? soundList,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }
}
