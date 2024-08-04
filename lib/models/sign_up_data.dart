class SignUpData {
  String phone;
  String fname;
  String lname;
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
    this.fname = '',
    this.lname = '',
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
      'fname': fname,
      'lname': lname,
      'email': email,
      'city': city,
      'state': state,
      'province': province,
      'country': country,
      'postalcode': postalCode,
      'diagnosed': diagnosed,
      'v_specialist': vSpecialist,
      'v_fname': vFname,
      'v_lname': vLname,
      'medical_clear': medicalClear,
    };
  }
}
