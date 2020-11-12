class AuthInfo {
  final String token;
  final String email;
  final bool isAdmin;

  AuthInfo({this.token, this.email, this.isAdmin});

  factory AuthInfo.fromJSON(Map<String, dynamic> json) {
    return AuthInfo(
      token: json['token'],
      email: json['email'],
      isAdmin: json['isAdmin'],
    );
  }
}


class AuthLoginInfo {
  String email;
  String password;

  AuthLoginInfo(this.email, this.password)
    : assert(email != null && password != null);
}

class AuthRegisterInfo {
  String email;
  String password;
  String name;
  String phone;
  String business;
  String address;
  String taxExempt;

  AuthRegisterInfo(
      this.email,
      this.password,
      this.name,
      [this.phone,
      this.business,
      this.address,
      this.taxExempt])
      : assert(email != null && password != null && name != null);
}
