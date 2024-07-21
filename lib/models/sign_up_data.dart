class SignUpData {
  String phone;
  String fName;
  String lName;
  String email;
  String city;
  String state;
  String province;
  String country;
  String postalCode;
  String diagnosed;
  String vSpecialist;
  String vFname;
  String vLname;
  String medicalClear;

  SignUpData({
    this.phone = '',
    this.fName = '',
    this.lName = '',
    this.email = '',
    this.city = '',
    this.state = '',
    this.province = '',
    this.country = '',
    this.postalCode = '',
    this.diagnosed = '',
    this.vSpecialist = '',
    this.vFname = '',
    this.vLname = '',
    this.medicalClear = '',
  });

  Map<String, String> toJson() {
    return {
      'phone': phone,
      'fName': fName,
      'lName': lName,
      'email': email,
      'city': city,
      'state': state,
      'province': province,
      'country': country,
      'postalCode': postalCode,
      'diagnosed': diagnosed,
      'vSpecialist': vSpecialist,
      'vFname': vFname,
      'vLname': vLname,
      'medicalClear': medicalClear,
    };
  }
}
