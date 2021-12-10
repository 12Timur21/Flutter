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
    SubscriptionType subscriptionType = SubscriptionType.values.firstWhere(
      (e) => e.toString() == json['subscriptionType'],
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
        'subscriptionType': subscriptionType.toString().split('.').last,
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
