class AuthInfo {
  final String token;
  final String email;
  final bool isAdmin;
  final bool needsRegistration;

  AuthInfo({this.token, this.email, this.isAdmin, this.needsRegistration});

  factory AuthInfo.fromJSON(Map<String, dynamic> json) {
    return AuthInfo(
        token: json['token'],
        email: json['email'],
        isAdmin: json['isAdmin'],
        needsRegistration: json['needsRegistration']);
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
  String name;
  String phone;
  String business;
  String address;
  String addrState;
  String addrZip;
  String taxExempt;

  AuthRegisterInfo(this.email, this.name,
      {this.phone, this.business, this.address, this.addrState, this.addrZip, this.taxExempt})
      : assert(email != null && name != null);
}
