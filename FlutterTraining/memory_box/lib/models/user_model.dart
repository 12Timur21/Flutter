enum SubscriptionType {
  noSubscription,
  month,
  year,
}

class UserModel {
  String? uid;
  String? displayName;
  String? phoneNumber;
  SubscriptionType? subscriptionType;
  UserModel({
    this.uid,
    this.displayName,
    this.phoneNumber,
    this.subscriptionType,
  });

  factory UserModel.initial() {
    return UserModel(
      uid: null,
      displayName: null,
      phoneNumber: null,
      subscriptionType: null,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    SubscriptionType subscriptionType = SubscriptionType.values.firstWhere(
      (f) => f.toString() == json['subscriptionType'],
      orElse: () => SubscriptionType.noSubscription,
    );

    print(subscriptionType);

    return UserModel(
      uid: json['uid'],
      displayName: json['displayName'],
      phoneNumber: json['phoneNumber'],
      subscriptionType: subscriptionType,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'phoneNumber': phoneNumber,
        'subscriptionType': subscriptionType.toString(),
      };

  UserModel copyWith({
    String? uid,
    String? displayName,
    String? phoneNumber,
    SubscriptionType? subscriptionType,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      subscriptionType: subscriptionType ?? this.subscriptionType,
    );
  }
}
