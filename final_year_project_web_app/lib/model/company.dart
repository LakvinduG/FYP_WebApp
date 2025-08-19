class Company {
  final int companyId;
  final String name;
  final String registrationNo;
  final String companyType;
  final String hqAddress;
  final String phoneNumber;
  final String email;
  final String website;
  final String healthSafetyCertificates;

  Company({
    required this.companyId,
    required this.name,
    required this.registrationNo,
    required this.companyType,
    required this.hqAddress,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.healthSafetyCertificates,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: json['companyId'],
      name: json['name'],
      registrationNo: json['registrationNo'],
      companyType: json['companyType'],
      hqAddress: json['hqAddress'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      website: json['website'],
      healthSafetyCertificates: json['healthSafetyCertificates'],
    );
  }
}
