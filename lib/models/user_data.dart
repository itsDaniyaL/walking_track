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
  final String? gPhone;
  final String? gEmail;

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
    this.gPhone,
    this.gEmail,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      fname: json['fname'] ?? '',
      lname: json['lname'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      state: json['state'] ?? '',
      province: json['province'] ?? '',
      country: json['country'] ?? '',
      diagnosed: json['diagnosed'].toString(),
      vSpecialist: json['v_specialist'].toString(),
      vFname: json['v_fname'] ?? '',
      vLname: json['v_lname'] ?? '',
      medicalClear: json['medical_clear'].toString(),
      active: json['active'].toString(),
      passwordChanged: json['password_changed'].toString(),
      city: json['city'] ?? '',
      postalCode: json['postalcode'] ?? '',
      gPhone: json['g_phone'],
      gEmail: json['g_email'],
    );
  }

  Map<String, String?> toJson() {
    return {
      'fname': fname,
      'lname': lname,
      'phone': phone,
      'email': email,
      'state': state,
      'province': province,
      'country': country,
      'diagnosed': diagnosed,
      'v_specialist': vSpecialist,
      'v_fname': vFname,
      'v_lname': vLname,
      'medical_clear': medicalClear,
      'active': active,
      'password_changed': passwordChanged,
      'city': city,
      'postalcode': postalCode,
      'g_phone': gPhone,
      'g_email': gEmail,
    };
  }

  @override
  String toString() {
    return 'UserData(fname: $fname, lname: $lname, phone: $phone, email: $email, state: $state, '
        'province: $province, country: $country, diagnosed: $diagnosed, vSpecialist: $vSpecialist, '
        'vFname: $vFname, vLname: $vLname, medicalClear: $medicalClear, active: $active, '
        'passwordChanged: $passwordChanged, city: $city, postalCode: $postalCode, '
        'gPhone: $gPhone, gEmail: $gEmail)';
  }
}
