class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String dob;
  final String idCard;
  final String gender;
  final String? profilePicture;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.idCard,
    required this.gender,
    this.profilePicture,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      dob: json['dob'],
      idCard: json['id_card'],
      gender: json['gender'],
      profilePicture: json['profile_picture'],
    );
  }

  Map<String, String> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'dob': dob,
      'id_card': idCard,
      'gender': gender,
    };
  }
}