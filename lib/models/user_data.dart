class UserData {
  final String fname;
  final String lname;
  final String phone;
  final String email;
  final String state;
  final String province;
  final String country;
  final String diagnosed;
  final String vSpecialist;
  final String vFname;
  final String vLname;
  final String medicalClear;
  final String active;
  final String passwordChanged;
  final String city;
  final String postalCode;

  UserData({
    required this.fname,
    required this.lname,
    required this.phone,
    required this.email,
    required this.state,
    required this.province,
    required this.country,
    required this.diagnosed,
    required this.vSpecialist,
    required this.vFname,
    required this.vLname,
    required this.medicalClear,
    required this.active,
    required this.passwordChanged,
    required this.city,
    required this.postalCode,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fname: json['fname'],
      lname: json['lname'],
      phone: json['phone'],
      email: json['email'],
      state: json['state'],
      province: json['province'],
      country: json['country'],
      diagnosed: json['diagnosed'],
      vSpecialist: json['v_specialist'],
      vFname: json['v_fname'],
      vLname: json['v_lname'],
      medicalClear: json['medical_clear'],
      active: json['active'],
      passwordChanged: json['password_changed'],
      city: json['city'],
      postalCode: json['postalcode'],
    );
  }

  Map<String, String> toJson() {
    return {
      'fName': fname,
      'lName': lname,
      'phone': phone,
      'email': email,
      'state': state,
      'province': province,
      'country': country,
      'diagnosed': diagnosed,
      'vSpecialist': vSpecialist,
      'vFname': vFname,
      'vLname': vLname,
      'medicalClear': medicalClear,
      'active': active,
      'passwordChanged': passwordChanged,
      'city': city,
      'postalCode': postalCode,
    };
  }
}
