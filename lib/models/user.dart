class UserInfo {
  final String name;
  final String phone;
  final String business;
  final String address;
  final String zipcode;
  final String state;
  final bool taxExempt;
  final bool isAdmin;

  UserInfo({
    this.name,
    this.phone,
    this.business,
    this.address,
    this.zipcode,
    this.state,
    this.taxExempt,
    this.isAdmin,
  });

  factory UserInfo.fromJSON(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      phone: json['phone'],
      business: json['business'],
      address: json['address'],
      zipcode: json['zipcode'],
      state: json['state'],
      taxExempt: json['taxExempt'],
      isAdmin: json['isAdmin'],
    );
  }
}